rm(list = ls)
invisible(gc())
library(dplyr)
library(data.table)

# readClipboard() %>% normalizePath(., winslash = "/")
path_target <- "E:/NCHC/MOD_project/s3_web_client/filestash/client/locales/zh.json"
path_dict <- "E:/NCHC/MOD_project/s3_web_client/zhCN2zhTW.txt"
convert_CN2tw <- function(path_target, path_dict){
  tmp01 <- readLines(path_dict, encoding = "UTF-8")
  tmp02 <- strsplit(x = tmp01, split = " ") %>% unlist() %>% 
    matrix(data = ., ncol = 2, byrow = T) %>% data.table()
  colnames(tmp02) <- c("word_from", "word_to")
  dict <- tmp02
  pp <- dict$word_from
  rr <- dict$word_to
  
  target <- readLines(path_target, encoding = "UTF-8")
  # target <- target %>% toTrad() #效果比 vscode 差
  for (word_i in 1:length(pp)) {
    target <- target %>% 
      gsub(pattern = pp[word_i], replacement = rr[word_i], x = .)
  }
  return(target)
}
res <- convert_CN2tw(path_target = path_target, path_dict = path_dict)
writeLines(text = res, con = "D:/zh.json", useBytes = T)


