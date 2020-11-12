# README

專案更新時間: 2020-11-12

---

## 未來目標

- 資料處理: 用 python 再寫一版。
- 串接資料庫與雲平台: AWS, GCP, Azure。嘗試使用 postgress, prometheus
- 監測: Grafana, Prometheus, shiny。要想一下工具的定位。

---

## 工具

把會使用到的工具，都先列出來。

- 資料處理: batch, R
- 資料庫與雲平台: TWCC, mysql
- 監測: Grafana
- 告警: Gmail, Line, Telegram
- Git: 練習程式碼版本控制

--

### cmd/powershell 指令

batch 主要就是用這兩個指令。  
至於他們可以下那些參數，可以用下面的方式做查詢。  

- taskkill /?
- tasklist /?
- chcp: 可以改編碼，會影響到輸出結果。(950:big5、65001:UTF-8)
- cls: 清空畫面
- F7: history 功能

---

## 目標成果

希望能做電腦的效能管理與監測。

一些名詞或是階層關係先認識一下，

- 處理程序(Process)除了映像名稱(Imagename)之外，還包含 CPU, 記憶體, 硬碟使用量等。
- 處理程序(Process)的映像名稱(Imagename)，不盡相同。
- 一個映像名稱(Imagename)，底下可能會有許多處理程序(Process)，會被收整在一起。

--

### 指標

列出會有哪些資料表與函式功能。

**資料收集與整理流程:**

- 每5分鐘抓一次資料，不斷複寫。用於監測電腦狀況
- 每30分鐘抓一次資料，存在本機端。
- 本機端每天的資料處理後刪除: plot, racing-bar, SMS(Short Message Service), upload to DB。

**資料庫:**

總共四張表。

- tasklist info: [datatime, imagename, PID, username, memusage]
  - PID 是刪除東西的時候需要用到，上傳資料庫其實不需要這一欄位。
  - memusage 是 MEM Usage，單位為 KB。
- 統計使用情況，做出下列三張表
  - 以天為本: [datetime, process_num, process_max, process_min, memusage_total, memusage_max, memusage_min]
  - 以使用者為本: [datetime, user, process_num, process_mean, process_max, process_min, memusage_total, memusage_mean, memusage_max, memusage_min]
  - 以映像名稱為本: [datetime, imagename, process_num, process_mean, process_max, process_min, memusage_total, memusage_mean, memusage_max, memusage_min]

**電腦-清理:**

- 定期刪除無法結束的程序: 這個解決方法不正確，但先這樣做。
  - 依照 imagename 刪除。
  - 依照 PID 刪除。
  - /T: 終止指定的處理程序，以及任何由它所啟動的子處理程序。
  - /F: 指定此參數可強制終止處理程序。

**監測:**

- 監測工具、畫面、racing bar: Grafana, prometheus, shiny
  - status map: 多台電腦的狀況
  - [x, y] = [datetime, process]
  - [x, y] = [datetime, memusage]
  - [x, y, group] = [datetime, process, user]: 可以繪製 racing-bar。
  - [x, y, group] = [datetime, memusage, user]: 可以繪製 racing-bar。
  - [x, y, group] = [datetime, process, imagename]: 可以繪製 racing-bar。
  - [x, y, group] = [datetime, memusage, imagename]: 可以繪製 racing-bar。

**告警:**

- 下列條件滿足任一都要告警。
  - process 超過某個數量，超過三次。
  - memusage(RAM) 超過某個使用量，超過三次。
- 方式
  - email: Gmail
  - LINE
  - telegram
  - slack

---

## 架構圖

見 schema.pptx

---

## END

---

## 還需要研究的部分

- Task Manager 其他欄位的資訊意義。
- 如何把 Task Manager 其他的資訊也一併匯出

--

一些不錯的文章，再讀一遍

* [Windows 10 將在應用程式加入開機執行時發出通知（同場加映：快速取消開機執行） - 電腦王阿達](https://www.kocpc.com.tw/archives/350158?fbclid=IwAR0U-GdT4xX9apuaPGVNwOBU5NJ-x5nYWgJfqcmaSkTsH3slMLpjVl6zLfk)
* [HP 電腦 － 使用工作管理員 (Windows 10,8) | HP®顧客支援](https://support.hp.com/tw-zh/document/c03724137)
* [改變Windows 10 工作管理員 的預設顯示頁面 - 挨踢路人甲](https://walker-a.com/archives/5603)
* [[實用技巧] 打開工作管理員藏起來的系統資訊 | 硬是要學](https://www.soft4fun.net/how-to/tips/%E5%AF%A6%E7%94%A8%E6%8A%80%E5%B7%A7-%E6%89%93%E9%96%8B%E5%B7%A5%E4%BD%9C%E7%AE%A1%E7%90%86%E5%93%A1%E8%97%8F%E8%B5%B7%E4%BE%86%E7%9A%84%E7%B3%BB%E7%B5%B1%E8%B3%87%E8%A8%8A.htm)
* [Kill a Process in Windows 10 | Tutorials](https://www.tenforums.com/tutorials/101472-kill-process-windows-10-a.html)
* [Kill Processes from Command Prompt](https://tweaks.com/windows/39559/kill-processes-from-command-prompt/)
* [在Windows下，利用tasklist與taskkill來刪除Process](https://blog.twtnn.com/2013/11/windowstasklisttaskkillprocess.html)
* [windows tasklist user - Google 搜尋](https://www.google.com/search?sxsrf=ALeKk01qN5G8P9G88PYYvqSGHX-f8A1sXg%3A1602753344340&ei=QBOIX9e2FOKRr7wPyae8gAY&q=windows+tasklist+user&oq=windows+tasklist+user&gs_lcp=CgZwc3ktYWIQAzICCAAyBggAEAgQHjIGCAAQCBAeOgUIABCwAzoHCAAQsAMQHjoJCAAQsAMQChAeOgsIABCwAxAIEAoQHjoJCAAQsAMQCBAeOgUIABCxAzoECCMQJzoFCAAQywFQhK4yWPrPMmDE0jJoAXAAeACAATSIAbUEkgECMTOYAQCgAQGqAQdnd3Mtd2l6yAEJwAEB&sclient=psy-ab&ved=0ahUKEwjX1oG-obbsAhXiyIsBHckTD2AQ4dUDCA0&uact=5)
* [process - How can I see which user accounts are running which processes in Windows 8.1? - Super User](https://superuser.com/questions/893372/how-can-i-see-which-user-accounts-are-running-which-processes-in-windows-8-1)

* [batch file - Windows shell command to get the full path to the current directory? - Stack Overflow](https://stackoverflow.com/questions/607670/windows-shell-command-to-get-the-full-path-to-the-current-directory)
* [How to get date / time in batch file](https://www.windows-commandline.com/get-date-time-batch-file/)
* [如何在 Batch 檔取得系統的日期、時間欄位 (第三版) | The Will Will Web](https://blog.miniasp.com/post/2009/11/03/How-to-get-system-date-time-in-batch-file-part-III)
* [windows - How to append text files using batch files - Stack Overflow](https://stackoverflow.com/questions/19750653/how-to-append-text-files-using-batch-files)
