rm(list = ls())
invisible(gc())
library(dplyr)
library(data.table)
library(pdftools)

all_files <- list.files(path = "./TANet2020論文集/", pattern = "pdf$", full.names = T)
i <- 1
j <- 1
for (i in 1:length(all_files)) {
  print(i)
  tmp01 <- pdf_data(pdf = all_files[i])
  nn <- all_files[i] %>% basename() %>% gsub("\\.pdf", "", .)
  nn_output <- all_files[i] %>% 
    gsub("\\.pdf", ".csv", .) %>% 
    gsub("TANet2020論文集", "TANet2020論文集-extract-text", .)
  res <- list()
  
  for (j in 1:length(tmp01)) {
    tmp02 <- tmp01[[j]] %>% data.table()
    
    # ---
    next_x <- tmp02$width+tmp02$x
    diff_x <- c(0, (head(next_x, -1) - tmp02$x[-1])) %>% abs
    diff_y = c(0, diff(tmp02$y)) %>% abs
    
    # ---
    tmp02[, `:=`(diff_x = diff_x,
                 diff_y = diff_y,
                 x_group = ifelse(diff_x<=10, 0, 1),
                 y_group = ifelse(diff_y<=16, 0, 1) )
          ][, `:=`(xy_group = ifelse(tmp02$x_group==1 & tmp02$y_group==1, 
                                     1, 0) %>% cumsum())]
    tmp03 <- tmp02[, .(text_group = paste0(text, collapse = "")), by = .(xy_group)]
    
    
    # ---
    # 整理結果
    tmp04 <- data.table(filename = nn, page = j, tmp03)
    res[[j]] <- tmp04
  }
  
  res_total <- rbindlist(res)
  fwrite(x = res_total, file = nn_output, row.names = F)
}

