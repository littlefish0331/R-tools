# ---
# 輸入: 
# - mydata: 原始資料 character vector
# 
# 功能:
# - 判斷 character vector 依序是否只有 [英文|數字|標點符號|空白] 組成，是的話返回 eng，不是的話則返回 cht
# 
# 輸出: 
# - character vector [cht, eng, ...]
# 
# ---
# 測試參數:
# - mydata_test <- c("ABC", "A BC", "A B C!?", "ABC你")
# - judge.lang(mydata = mydata_test)
# 
# ---
# 函數本身:
judge.lang <- function(mydata){
  pp1 <- "^[a-zA-Z0-9[:punct:]\n ]+$"
  # pp2 <- "^[\u4e00-\u9fa5 ]+$"
  res <- ifelse(grepl(pattern = pp1, x = mydata), "eng", "cht")
  return(res)
}
