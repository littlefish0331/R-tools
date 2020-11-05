
# ---
# File Target
# - 把所有題目都抓取下來。(手動)
#   - 英文版
#   - 中文版
# - 對象與時間抓取，製作檔案名稱
# - 清理數據
#   - 說話對象去除
#   - 對話時間去除
# - 格式
#   - 題目之間要空一行
#   - 整理成下列形式。好險題目都是選擇題，且四個選項。
#     - 題目
#     - (A)
#     - (B)
#     - (C)
#     - (D)
#     (空一行)
# - save
# - transfer to table
# - txt to csv
# - csv to txt



# ---
rm(list = ls()); invisible(gc())
library(dplyr)
library(data.table)
t1 <- list.files("./", full.names = T) %>% grepl("LINE", .) %>% which()
tar_file <- list.files("./")[t1]

# 讀取
tmp01 <- readLines(con = tar_file, encoding = "UTF-8")


# --
# 解決BOM問題
tmp01_BOM <- tmp01[1]
tt <- tmp01_BOM %>% charToRaw() %>% head(3)
if (sum(tt==c("ef", "bb", "bf"))==3) {
  tmp01_BOM <- tmp01_BOM %>% 
    charToRaw() %>% tail(-3) %>% rawToChar() %>% 
    iconv(x = ., from = "UTF-8", "UTF-8")
}
tmp02 <- c(tmp01_BOM, tmp01[-1])


# --
# - 對象與時間抓取，製作檔案名稱
file_who <- tmp02[1] %>% gsub("(.*) 與(.*)(的聊天記錄)", "\\2", .)
file_time <- tmp02[2] %>% gsub("[^ ]+ (.*)$", "\\1", .) %>% 
  gsub("/", "-", .) %>% gsub(" ", "T", .) %>% gsub(":", "", .)
file_nn <- paste0(file_time, "_", file_who)


# --
# - 清理數據
#   - 合併
#   - 說話對象去除
#   - 對話時間去除
tmp03 <- tmp02[-c(1:4)]
t1 <- tmp03 %>% grepl("^(上|下)", .)
t2 <- ifelse(t1==TRUE, 1, 0) %>% cumsum()
tmp04 <- data.table(rawdata = tmp03, splitdata = t2)
tmp05 <- tmp04[, .(combinedata = paste0(rawdata, collapse = "\n")), by = .(splitdata)]
tmp06 <- tmp05$combinedata %>% gsub(".*\t(.*)", "\\1", .)


# --
# - 格式
#   - 題目之間要空一行
#   - 整理成下列形式
#     - 題目
#     - (A)
#     - (B)
#     - (C)
#     - (D)
#     (空一行)
quiz_num <- length(tmp06)/5
t1 <- (0:(quiz_num-1))*6
idx_quiz <- rep(t1, each = 5)+(1:5)
idx_blank <- (1:(quiz_num-1))*6
result <- rep(NA, length(tmp06)+quiz_num-1)
result[idx_quiz] <- tmp06
result[idx_blank] <- ""


# --
# - save
write.table(x = result, file = paste0(file_nn, ".txt"), 
            fileEncoding = "UTF-8", row.names = F, col.names = F, quote = F)


# --
# - transfer to table
tmp06 <- tmp06 %>% gsub("\n \n", "\n", .)
tmp07 <- tmp06 %>% matrix(data = ., ncol = 5, byrow = T) %>% 
  data.table() %>% 
  `colnames<-`(c("question", "optionA", "optionB", "optionC", "optionD"))
fwrite(x = tmp07, file = paste0(file_nn, ".csv"), row.names = F)


# --
# txt to csv
# csv to txt
txt2csv <- result[idx_quiz] %>% matrix(data = ., ncol = 5, byrow = T) %>% 
  data.table() %>% 
  `colnames<-`(c("question", "optionA", "optionB", "optionC", "optionD"))
csv2txt <- tmp07 %>% transpose %>% unlist(., use.names = F)


# ---
# END

