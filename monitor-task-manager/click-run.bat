:: 讀取時間
SET @TodayYear=%date:~0,4%
SET @TodayMonth=%date:~5,2%
SET @TodayDay=%date:~8,2%
REM SET @weekday=%date:~11,2%
SET @time=%time:~0,8%


:: 時間格式
:: time format for two digit.
SET @hour=%time:~0,2%
IF "%@hour:~0,1%" == " " SET @hour=0%@hour:~1,1%
SET @min=%time:~3,2%
IF "%@min:~0,1%" == " " SET @min=0%@min:~1,1%
REM SET @secs=%time:~6,2%
REM IF "%@secs:~0,1%" == " " SET @secs=0%@secs:~1,1%


:: print out to check cd(currect directory, a.k.a. pwd)
:: time format append to txt
echo %cd% > E:/NCHC/gitlab_project/monitor-task-manager/cd.txt
chcp 65001
echo %@TodayYear%-%@TodayMonth%-%@TodayDay%T%@hour%%@min% >> E:/NCHC/gitlab_project/monitor-task-manager/datetime.txt
pause

tasklist /V /FO CSV > %@TodayYear%-%@TodayMonth%-%@TodayDay%T%@hour%%@min%.csv
REM 路徑用反斜線也可以 E:\fish\raw_data\123.txt
REM 開始位置 E:\fish\raw_data 或是 E:\fish\raw_data\ 都可以。
REM 用最高管理員才可以順利執行，我不知道為甚麼。

