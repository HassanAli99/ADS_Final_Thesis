# cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")  #with grey
# cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7") #with black

plot_hydrograph <- function(station_no, convRatio, model, variable_setup){
  
  all_q <- read.csv(paste0(dir, station_no,'.csv'), header = T) %>%
    mutate(datetime=as.Date(datetime)) %>% 
    relocate(average_dis, .before = dis_corrected) %>% 
  
    select(., everything())
  
    #select(., datetime:res_corrected)
  
  
  
  # all_q$pcr[is.na(all_q$obs)] <- NA
  # all_q$pcr_corrected[is.na(all_q$obs)] <- NA
  
  plotData <- all_q %>% select(-c('res','res_corrected')) %>% 
    gather(.,condition, value, obs:dis_corrected)
  
  
  ggplot(plotData,
         aes(x=datetime, y=value, col=condition, group = condition)) +
    geom_line(size=0.7, alpha = 0.6) +
    geom_point(aes(shape=condition), size=1.5, alpha = 0.6, show.legend = F) +
    xlab('date\n') + 
    ylab('flow depth (m/d)\n') +
    scale_y_continuous(sec.axis = sec_axis(~.*convRatio, name=expression('discharge (' *m^{3}/s* ')'))) +
    
    scale_color_manual(labels = c("Observed discharge", "uncalibrated discharge (Ensembled mean)",paste0("Post-processed ", model, " ", variable_setup)),
                       
                       values=c("#56B4E9","#000000","#E69F00"))+
    
    scale_linetype_manual(values=1:3, 
                          labels = c("Observed discharge   ", "uncalibrated discharge (Ensembled mean)","Post-processed (allpredictors)")) +
    theme_minimal() +
    theme(legend.title=element_blank(),
          legend.text = element_text(size=16),
          axis.title.x = element_text(face="bold", size=16),
          axis.title.y = element_text(size=16),
          axis.text.x = element_text(size=12),
          axis.text.y = element_text(size=12))+
    guides(colour = guide_legend(override.aes = list(size=3)))
  
}


plot_ecdf <- function(station_no, convRatio){
  
  all_q <- read.csv(paste0(dir, station_no,'.csv'), header = T) %>%
    mutate(datetime=as.Date(datetime)) %>% 
    relocate(average_dis, .before = dis_corrected) %>% 
    select(., everything())%>%
    na.omit(.)
  
  plotData <- all_q %>% select(-c('res','res_corrected')) %>% 
    gather(.,condition, value, obs:dis_corrected)
  
  ggplot(plotData, aes(value, col=condition)) +
    stat_ecdf(size=1, alpha=0.6, show.legend = F)+
    # scale_x_continuous(sec.axis = sec_axis(~.*convRatio, name=expression('discharge (' *m^{3}/s* ')'))) +
    coord_flip() +
    xlab('flow depth (m/d)\n') + 
    ylab('p\n') +
    scale_color_manual(values=c("#56B4E9","#000000","#E69F00")) +
    theme_minimal() +
    theme(axis.title.x = element_text(face="bold", size=16),
          axis.title.y = element_text(size=16),
          axis.text.x = element_text(size=12),
          axis.text.y = element_text(size=12))

}


plot_residuals <- function(station_no, convRatio){
  
  all_q <- read.csv(paste0(dir, station_no,'.csv'), header = T) %>%
    mutate(datetime=as.Date(datetime)) %>% 
    relocate(average_dis, .before = dis_corrected) %>% 
    select(., everything()) %>% 
    na.omit()
  
  plotData <- all_q %>% 
    select(-c('average_dis','dis_corrected')) %>% 
    gather(.,condition, value, res:res_corrected)
  
  ggplot(plotData, aes(x=obs, y=value, col=condition)) +
    geom_point(size=2,alpha=0.6, show.legend = F)+
    # scale_y_continuous(sec.axis = sec_axis(~.*convRatio, name=expression('residual (\n' *m^{3}/s* ') \n'))) +
    # scale_y_continuous(position = "right")+
    xlab('observed flow depth (m/d)\n') +
    ylab('residual (m/d)\n') +
    scale_color_manual(values=c("#000000","#E69F00")) +
    theme_minimal() +
    theme(axis.title.x = element_text(face="bold", size=16),
          axis.title.y = element_text(size=16),
          axis.text.x = element_text(size=12),
          axis.text.y = element_text(size=12))
  
}
















