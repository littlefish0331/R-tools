## -----------------------------------------------------------------------------
# 基本上一開始的路徑要改(line:5)，其餘都是相對路徑!
# 這邊改好之後，再覆蓋 cp950 編碼的版本。
## -----------------------------------------------------------------------------
rm(list = ls()); invisible(gc())
setwd("E:/AWS_SAA/Exam-Practice/")
library(kableExtra)
library(dplyr)
library(data.table)
library(Nippon)




## -----------------------------------------------------------------------------
# - crawler chatbot data from cellphone, then for-loop to do following steps
#   - read data_original
#   - read dict
## -----------------------------------------------------------------------------
allfile <- list.files("./data_original/", pattern = "LINE", full.names = T)
lang <- fread("./dict/language.txt", encoding = "UTF-8", header = F)
cate <- fread("./dict/category.txt", encoding = "UTF-8", header = F)





i <- 4
## -----------------------------------------------------------------------------
# FOR LOOP
## -----------------------------------------------------------------------------
for (i in 1:length(allfile)) {
  print(i)
  tmp01 <- readLines(con = allfile[i], encoding = "UTF-8")
  delTF <- T
  
  
  
  
  ## -----------------------------------------------------------------------------
  # - split data to metadata and textdata
  ## -----------------------------------------------------------------------------
  tmp <- tmp01 %>% head(10)
  lang_i <- 1
  for (lang_i in 1:length(lang)) {
    idx_meta <- tmp %>% grep(pattern = lang$V1[lang_i], x = .) %>% sum
    if (idx_meta!=0) {
      metadata <- tmp01[1:idx_meta]
      textdata <- tmp01[-(1:idx_meta)]
      language <- lang$V2[lang_i]
      break
    }
  }
  
  
  
  
  ## -----------------------------------------------------------------------------
  # - clean metadata
  #   - remove utf-8-bom
  #   - find language by dict-language.txt
  #   - find category by dict-category.txt
  #   - update datetime
  #   - filename = [category]-[language]-[update datetime]
  ## -----------------------------------------------------------------------------
  source("./code/rm.utf8bom.R", encoding = "UTF-8")
  metadata <- rm.utf8bom(mydata = metadata)
  
  # language 在上一步驟，切割 metadata 和 textdata 的時候已經找出。
  
  for (cate_i in 1:nrow(cate)) {
    TF <- metadata %>% grepl(pattern = cate$V1[cate_i], x = .) %>% sum
    if (TF) {
      category <- cate$V2[cate_i]
      break
    }
  }
  update_datetime <- metadata[2] %>% 
    gsub(".* ([0-9/]+) ([0-9:]+)", "\\1T\\2", .) %>% 
    gsub("(/|:)", "", .)
  
  filename <- paste(category, language, update_datetime, sep = "-")
  filename_pattern <- paste(category, language, sep = "-")
  filename_full <- paste0("./data_format/", filename, ".csv")
  
  
  
  
  
  ## -----------------------------------------------------------------------------
  # - clean textdata
  #   - multi-line combine in one
  #   - clean option format
  #     - to "(A|B|C|D) "
  #     - delete begin and end '"'
  #     - clean \n and lot \n problem
  #   - check rows length is right or not, alert and DO NOT delete file if wrong
  #   - transfer to table: [question, OptionA, OptionA, OptionA, OptionA, language, category, answer(目前沒有，需手動加入)]
  #   - judge it has cht or all-eng
  ## -----------------------------------------------------------------------------
  tmp01 <- textdata %>% grepl("^(上|下)午", .)
  tmp02 <- ifelse(tmp01==TRUE, 1, 0) %>% cumsum()
  tmp03 <- data.table(textdata = textdata, splitdata = tmp02)
  tmp04 <- tmp03[, .(textdata_combine = paste0(textdata, collapse = "\n")), by = .(splitdata)]
  tmp05 <- tmp04$textdata_combine %>% gsub(".*\t(.*)", "\\1", .)
  
  tmp06 <- tmp05 %>% 
    sapply(., zen2han, USE.NAMES = F) %>% 
    gsub("^ 按需求分配", "(D) 按需求分配", .) %>%
    gsub("^\\(四\\)", "(D) ", .) %>%
    gsub("^\"\\((A|B|C|D)\\)", "(\\1) ", .) %>% #清理 '"(D)'
    gsub("^\"(A|B|C|D)\\.", "(\\1) ", .) %>% #清理 '"D.'
    gsub("^\\(\\((A|B|C|D)\\) \\)", "(\\1) ", .) %>% #清理 '"((D) )'
    gsub("(A|B|C|D)\\.", "(\\1) ", .) %>% #清理 'D.'
    gsub("^\\((A|B|C|D)\\)", "(\\1) ", .) %>% #正規化 '"(D) "'
    gsub(" +", " ", .) %>% #清理多個空格為一個
    gsub("\"$", "", .) %>%  #清理句尾 '"'
    gsub("^\"", "", .) %>%  #清理句首 '"'
    trimws(x = ., which = "both") %>% 
    gsub("\n *\n", "\n", .) %>% 
    gsub("( |\n)+$", "", .) %>% 
    gsub("\"", "'", .) #這個很重要，是為了後續的 remove duplicate，不然文件讀取進來都會是 ""XXX""
  
  idx_optionD <- seq(from = 5, to = length(tmp06), by = 5)
  checknum <- tmp06[idx_optionD] %>% substring(text = ., 1, 4) %>% table %>% as.numeric() %>% .[1]
  if (checknum!=(length(tmp06)/5)){
    print("有內鬼! 終止交易")
    delTF <- FALSE
  }
  
  source("./code/judge.lang.R", encoding = "UTF-8")
  if (delTF) {
    tmp07 <- tmp06 %>% matrix(data = ., ncol = 5, byrow = T) %>% data.table()
    colnames(tmp07) <- c("question", "optionA", "optionB", "optionC", "optionD")
    tmp07[, `:=`(language = language, 
                 category = category,
                 language2 = judge.lang(mydata = tmp07$question))]
  }
  
  
  
  
  
  
  ## -----------------------------------------------------------------------------
  # - append to last table
  #   - remove duplicate
  ## -----------------------------------------------------------------------------
  if (delTF) {
    tmp <- list.files(path = "./data_format/", pattern = filename_pattern, full.names = T)
    if (length(tmp)!=0) {
      data_last <- fread(tmp, encoding = "UTF-8")
      unlink(tmp)
      res <- list(data_last, tmp07) %>% rbindlist() %>% unique()
    } else {
      res <- tmp07 %>% unique()
    }
    fwrite(x = res, file = filename_full, row.names = F)
  }
}




## -----------------------------------------------------------------------------
# 生成一個 finish.txt 檔案，要讓 batch 做偵測知道結束了。
## -----------------------------------------------------------------------------
write("GOOD!!", file = "./code/finish.txt")






## -----------------------------------------------------------------------------
# - setting schedule
#   - 最後用 batch 中間暫停，看一下 output 如果沒有問題，就把 data_original/ 清空。
#   - 註解前面的 "'"，是按 Ctrl+Shift+c 自動生成的。
#   - 點擊執行，不用排程。
## -----------------------------------------------------------------------------
# 1. touch code/click-run.bat
# 2. edit to add the following script
# 
#' @echo off
#' SET LookForFile="E:\AWS_SAA\Exam-Practice\code\finish.txt"
#' SET ExecuteFile="E:/AWS_SAA/Exam-Practice/code/final-version-20201104-cp950.R"
#' SET DelCreateFolder="E:\AWS_SAA\Exam-Practice\data_original"
#' cmd /c start /min C:\\PROGRA~1\\MICROS~1\\ROPEN~1\\R-35~1.3\\bin\\x64\\Rcmd.exe BATCH %ExecuteFile%
#' 
#' :CheckForFile
#' IF EXIST %LookForFile% GOTO FoundIt
#' 
#' REM If we get here, the file is not found.
#' REM Wait 3 seconds and then recheck.
#' TIMEOUT /T 3
#' GOTO CheckForFile
#' 
#' :FoundIt
#' ECHO Process over
#' ECHO Found: %LookForFile%
#' ECHO Shoe Process Time
#' powershell Get-Content final-version-20201104-cp950.Rout -Tail 3
#' pause
#' 
#' ECHO clear data_original folder and delete finish.txt
#' del %LookForFile%
#' RD /S /Q %DelCreateFolder%
#' MD %DelCreateFolder%%
#' pause




# --- END ----


