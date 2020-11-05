@echo off
REM 在 windows 上面執行需要用 cp950 編碼儲存 Rcode。
SET LookForFile="E:\AWS_SAA\Exam-Practice\code\finish.txt"
SET ExecuteFile="E:/AWS_SAA/Exam-Practice/code/final-version-20201104-cp950.R"
SET DelCreateFolder="E:\AWS_SAA\Exam-Practice\data_original"
cmd /c start /min C:\\PROGRA~1\\MICROS~1\\ROPEN~1\\R-35~1.3\\bin\\x64\\Rcmd.exe BATCH %ExecuteFile%

:CheckForFile
IF EXIST %LookForFile% GOTO FoundIt

REM If we get here, the file is not found.
REM Wait 3 seconds and then recheck.
TIMEOUT /T 3
GOTO CheckForFile

:FoundIt
ECHO Process over
ECHO Found: %LookForFile%
ECHO Shoe Process Time
powershell Get-Content final-version-20201104-cp950.Rout -Tail 3
pause

ECHO clear data_original folder and delete finish.txt
del %LookForFile%
RD /S /Q %DelCreateFolder%
MD %DelCreateFolder%%
pause

::reference - for loop
::https://stackoverflow.com/questions/27906705/loop-until-file-exists-using-windows-batch-command
