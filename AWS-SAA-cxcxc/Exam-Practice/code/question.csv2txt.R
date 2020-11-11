rm(list = ls())
invisible(gc())
library(dplyr)
library(data.table)

# --------------------------------------------------------
# File Target
# - 將整理好格式的試題，做成題目與解題空間的形式。
# - file_path: 整理好格式的試題
# - quiz_num: 題目數。
# - blank_num: 解題空間行數。
# - output_path: 輸出位置
# --------------------------------------------------------

file_path <- "./data_format/SAA-cht-20201105T0559.csv"
quiz_num <- 10
blank_num <- 8
output_path <- "./output.txt"

question.csv2txt <- function(file_path, quiz_num, blank_num, output_path){
  # ---
  # Read data
  # transfer to vector
  tmp01 <- fread(file_path, encoding = "UTF-8")
  idx <- sample(1:nrow(tmp01), size = quiz_num, replace = F)
  tmp02 <- tmp01[idx, 1:5, with = F] %>% transpose() %>% unlist(., use.names = F)
  
  
  # ---
  # create idx for quiz
  # create idx for blank
  t1 <- (0:(quiz_num-1))*(1+4+blank_num)
  idx_quiz <- rep(t1, each = 5)+(1:5)
  t2 <- (0:(quiz_num-1))*(1+4+blank_num)
  idx_blank <- rep(t2, each = blank_num)+(6:(1+4+blank_num))
  
  
  # ---
  # insert data in result
  # output
  res <- NULL
  res[idx_quiz] <- tmp02
  res[idx_blank] <- ""
  return(res)
}

result <- question.csv2txt(file_path = file_path, 
                           quiz_num = quiz_num, 
                           blank_num = blank_num, 
                           output_path = output_path)
# result %>% View()
writeLines(text = result, con = output_path, useBytes = T)

