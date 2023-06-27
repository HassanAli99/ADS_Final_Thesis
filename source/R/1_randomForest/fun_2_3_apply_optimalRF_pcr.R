

apply_optimalRF <- function(i, key, columns_set_up, optimal_ranger) {
  
  station_no <- testStationInfo$grdc_no[i]
  print(station_no)
  test_data <- read.csv(paste0('../data/allpredictors_pcr/pcr_allpredictors_', station_no, '.csv'))
  
 
  test_data_pre <- 
    test_data %>% 
    select(all_of(columns_set_up))  %>% 
    mutate_all(as.numeric)
  
  # Apply trained random forest model to predict discharge
  rf.result <- test_data_pre %>%
    mutate(dis_corrected = predict(optimal_ranger, test_data_pre) %>%
             predictions()) %>%
    
    mutate(dis_corrected = replace(dis_corrected, dis_corrected < 0, 0)) %>%
    mutate(res = obs - pcr) %>%  # Calculate residuals based on pcr
    mutate(res_corrected = obs - dis_corrected)  # Calculate corrected residuals

  #Add datetime column to the results
  rf.result$datetime <- test_data$datetime
  
  
  # Save allpredictor tables to disk
  #if (key == 'allpredictors') {
  outputDirTables <- paste0(outputDirValidation, key, '/')
  dir.create(outputDirTables, showWarnings = FALSE, recursive = TRUE)
  
  file_path <- paste0(outputDirTables, 'rf_result_', station_no, '.csv')
  write.csv(rf.result, file_path, row.names = FALSE)
  
  
  # Calculate KGE uncalibrated and corrected
  rf.eval <- rf.result %>%
    summarise(grdc_no = station_no,
              KGE = KGE(sim = pcr, obs = obs,
                        s = c(1, 1, 1), na.rm = TRUE, method = "2009"), # simulated discharge is set to pcr. This is the unclaibrated 
              
           
              KGE_corrected = KGE(sim = dis_corrected, obs = obs,
                                  s = c(1, 1, 1), na.rm = TRUE, method = "2009"),
              
              
              # KGE components (r, alpha, beta), uncalibrated and corrected pcr
              KGE_r = cor(obs, pcr, method = 'pearson', use = 'complete.obs'),
              KGE_alpha = sd(pcr, na.rm = TRUE) / sd(obs, na.rm = TRUE),
              KGE_beta = mean(pcr, na.rm = TRUE) / mean(obs, na.rm = TRUE),
              
              
              KGE_r_corrected = cor(obs, dis_corrected, method = 'pearson', use = 'complete.obs'),
              KGE_alpha_corrected = sd(dis_corrected, na.rm = TRUE) / sd(obs, na.rm = TRUE),
              KGE_beta_corrected = mean(dis_corrected, na.rm = TRUE) / mean(obs, na.rm = TRUE),
              
              
              # Other metrics
              NSE = NSE(sim = pcr, obs = obs, na.rm = TRUE),
              NSE_corrected = NSE(sim = dis_corrected, obs = obs, na.rm = TRUE),
              RMSE = sqrt(mean((res)^2, na.rm = TRUE)),
              RMSE_corrected = sqrt(mean((res_corrected)^2, na.rm = TRUE)),
              MAE = mean(abs(res), na.rm = TRUE),
              MAE_corrected = mean(abs(res_corrected), na.rm = TRUE),
              nRMSE = sqrt(mean((res)^2, na.rm = TRUE)) / mean(obs),
              nRMSE_corrected = sqrt(mean((res_corrected)^2, na.rm = TRUE)) / mean(obs),
              nMAE = mean(abs(res), na.rm = TRUE) / mean(obs),
              nMAE_corrected = mean(abs(res_corrected), na.rm = TRUE) / mean(obs)
    )
  
  
  return(rf.eval)
}


