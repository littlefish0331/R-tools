# ---
# 輸入: 
# - mydata: 原始資料 character vector
# 
# 功能:
# - 解決BOM問題，將 utf-8-bom 前面的bom碼去除。
# 
# 輸出: 
# - 前面的bom碼去除後，吐回原始資料
# 
# ---
# 測試參數與資料:
# - 這個測試資料無法生成，因為我沒辦法用複製的方式取得，所以請看 UTF-8-BOM_testdata.txt
# - UTF-8-BOM_testdata.txt 用 VScode 或是 notepad++ 打開，都會在右下角出現 UTF-8-BOM 的提示。
# 
# ---
# 函數本身:
rm.utf8bom <- function(mydata){
  t1 <- mydata[1]
  t2 <- t1 %>% charToRaw() %>% head(3)
  if (sum(t2==c("ef", "bb", "bf"))==3) {
    t3 <- t1 %>% 
      charToRaw() %>% tail(-3) %>% rawToChar() %>% 
      iconv(x = ., from = "UTF-8", "UTF-8")
  }
  res <- c(t3, mydata[-1])
  return(res)
}

