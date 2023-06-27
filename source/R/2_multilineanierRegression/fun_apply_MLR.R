
apply_MLR <- function(i, key, columns_set_up, model) {
  
  

  #for (i in 1:nrow(testStationInfo)) {
  station_no <- testStationInfo$grdc_no[i]
  test_data <- read.csv(paste0('../data/allpredictors_pca/allpredictors_', station_no, '.csv'))
  
  # Rename the column "Obs_dis" to "obs"
  colnames(test_data)[colnames(test_data) == "pcr_dis"] <- "pcr"
  colnames(test_data)[colnames(test_data) == "lis_dis"] <- "lis"
  colnames(test_data)[colnames(test_data) == "wg3_dis"] <- "wg3"
  
  # Select columns and convert to numeric
  test_data_pre <- test_data %>%
    select(all_of(columns_set_up))  %>% 
    mutate_all(as.numeric) 

  
  # Apply trained MLR model to predict discharge
  mlr.result <- test_data_pre %>%
    mutate(dis_corrected = predict(model, test_data_pre)) %>%
    
    mutate(dis_corrected = replace(dis_corrected, dis_corrected < 0, 0)) %>%
    mutate(average_dis = rowMeans(select(., c("pcr", "lis", "wg3"
                                              )), na.rm = TRUE)) %>%
    mutate(res = obs - average_dis) %>% #Residual based on avergae_dis
    mutate(res_corrected = obs - dis_corrected)
  

  #Add datetime column to the results
  mlr.result$datetime <- test_data$datetime

  
  # Save MLR result tables to disk
  outputDirTables <- paste0(outputDirValidation, key, '/')
  if (!dir.exists(outputDirTables)) {
    dir.create(outputDirTables, showWarnings = FALSE, recursive = TRUE)
  }
  
  write.csv(mlr.result, paste0(outputDirTables, 'mlr_result_', station_no, '.csv'), row.names = FALSE)
  
  # Calculate KGE uncalibrated and corrected
  ml.eval <- mlr.result %>%
    summarise(grdc_no = station_no,
              KGE = KGE(sim = average_dis, obs = obs,
                        s = c(1, 1, 1), na.rm = TRUE, method = "2009"),
              
              KGE_pcr = KGE(sim = pcr, obs = obs,
                            s = c(1, 1, 1), na.rm = TRUE, method = "2009"),
              KGE_lis = KGE(sim = lis, obs = obs,
                            s = c(1, 1, 1), na.rm = TRUE, method = "2009"),
              KGE_wg3 = KGE(sim = wg3, obs = obs,
                            s = c(1, 1, 1), na.rm = TRUE, method = "2009"),
              
              KGE_corrected = KGE(sim = dis_corrected, obs = obs,
                                  s = c(1, 1, 1), na.rm = TRUE, method = "2009"),
              
              
              # KGE components (r, alpha, beta), uncalibrated and corrected average
              KGE_r = cor(obs, average_dis, method = 'pearson', use = 'complete.obs'),
              KGE_alpha = sd(average_dis, na.rm = TRUE) / sd(obs, na.rm = TRUE),
              KGE_beta = mean(average_dis, na.rm = TRUE) / mean(obs, na.rm = TRUE),
              
              # KGE components (r, alpha, beta), uncalibrated pcrglob 
              KGE_r_pcr = cor(obs, pcr, method = 'pearson', use = 'complete.obs'),
              KGE_alpha_pcr = sd(pcr, na.rm = TRUE) / sd(obs, na.rm = TRUE),
              KGE_beta_pcr = mean(pcr, na.rm = TRUE) / mean(obs, na.rm = TRUE),
              
              
              # KGE components (r, alpha, beta), uncalibrated  wg3
              KGE_r_wg3 = cor(obs, wg3, method = 'pearson', use = 'complete.obs'),
              KGE_alpha_wg3 = sd(wg3, na.rm = TRUE) / sd(obs, na.rm = TRUE),
              KGE_beta_wg3 = mean(wg3, na.rm = TRUE) / mean(obs, na.rm = TRUE),
              
              
              # KGE components (r, alpha, beta), uncalibrated and corrected lis
              KGE_r_lis = cor(obs, lis, method = 'pearson', use = 'complete.obs'),
              KGE_alpha_lis = sd(lis, na.rm = TRUE) / sd(obs, na.rm = TRUE),
              KGE_beta_lis = mean(lis, na.rm = TRUE) / mean(obs, na.rm = TRUE),
              
              
              
              
              KGE_r_corrected = cor(obs, dis_corrected, method = 'pearson', use = 'complete.obs'),
              KGE_alpha_corrected = sd(dis_corrected, na.rm = TRUE) / sd(obs, na.rm = TRUE),
              KGE_beta_corrected = mean(dis_corrected, na.rm = TRUE) / mean(obs, na.rm = TRUE),
              
              
              # Other metrics
              NSE = NSE(sim = average_dis, obs = obs, na.rm = TRUE),
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
  
    
    return(ml.eval)
}
  