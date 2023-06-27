# cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")  #with grey
# cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7") #with black

plot_hydrograph <- function(station_no, convRatio, model, variable_setup) {
  
  all_q1 <- read.csv(paste0(dir1, station_no,'.csv'), header = T) %>%
    mutate(datetime=as.Date(datetime)) %>% 
    relocate(average_dis, .before = dis_corrected) %>% 
    select(datetime, dis_corrected, res, res_corrected) %>% 
    rename(dis_mmc = dis_corrected, res_average = res, res_mmc = res_corrected) %>% 
    select(., everything())
  
  print(all_q1)
  
  all_q2 <- read.csv(paste0(dir2, station_no,'.csv'), header = T) %>%
    mutate(datetime=as.Date(datetime)) %>% 
    select(datetime, obs, pcr, dis_corrected, res, res_corrected) %>% 
    rename(dis_pcr_calibrated = dis_corrected, res_pcr = res, res_pcr_calibrated = res_corrected) %>% 
    select(., everything())
  
  print(all_q2)
  
  all_q <- merge(all_q1, all_q2, by = "datetime", all = F)
  
  
  plotData <- all_q %>%
    select(datetime, obs, pcr, dis_mmc, dis_pcr_calibrated) %>%
    gather(., key = "condition", value = "value", obs:dis_pcr_calibrated)
  
  
  print(plotData)
  ggplot(plotData, aes(x = datetime, y = value, color = condition)) +
    geom_line(size = 0.7, alpha = 0.6) +
    xlab('date\n') +
    ylab('flow depth (m/d)\n') +
    theme_minimal() +
    theme(
      legend.title = element_blank(),
      legend.text = element_text(size = 16),
      axis.title.x = element_text(face = "bold", size = 16),
      axis.title.y = element_text(size = 16),
      axis.text.x = element_text(size = 12),
      axis.text.y = element_text(size = 12)
    )
  
  
  
  
  
}

