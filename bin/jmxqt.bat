:: Copyright (c) 2020 All Rights Reserved
:: Contact information for this software is available at:
:: https://github.com/bransonvitz/jmxqt
::
:: This file is part of jmxqt.
::
:: jmxqt is free software: you can redistribute it and/or modify
:: it under the terms of the GNU Lesser General Public License as
:: published by the Free Software Foundation, either version 3 of
:: the License, or (at your option) any later version.
::
:: jmxqt is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU Lesser General Public License for more details.
::
:: You should have received a copy of the
:: GNU Lesser General Public License along with jmxqt.
:: If not, see <http://www.gnu.org/licenses/>.
@echo off
setlocal enabledelayedexpansion
set HDL=%USERPROFILE%
set LFN=%HDL%\log\jmxqt.log
set BDL=%HDL%\var\test
set WDL=%BDL%
set JTD=%HDL%\jmeter
set OK=-1

set DOC=""
if NOT "%2"=="" (set DOC=%2)
set TST=0
if NOT "%3"=="" (set TST=%3)

if "%1"=="stage" (
	call :stgJMeter OK
) else if "%1"=="launch" (
	echo "xqtJMeter invoked" >>!LFN! 2>&1
	call :xqtJMeter OK
) else (
	set OK=1
)
exit /B %OK%

:stgJMeter
if /I "!TST!" LEQ "0" (
	set TST=101
	echo "Removing %BDL%\!TST!" >>%LFN% 2>&1
	rmdir %BDL%\!TST! /S /Q 2>nul
)
echo "DBG... HOME: %HDL%, DOC: %DOC%, TST: %TST%" >>%LFN% 2>&1
if EXIST ".\src\test\jmeter\%DOC%" (
	set WDL=!BDL!\!TST!
	set JTD=!WDL!\jmeter
	mkdir !JTD! !WDL!\log >>!LFN! 2>&1
	xcopy /E !HDL!\jmeter !JTD! >>!LFN! 2>&1
	xcopy /E .\target\jmeter !JTD! >>!LFN! 2>&1
	xcopy .\src\test\jmeter\!DOC! !JTD!\bin >>!LFN! 2>&1
	set "%~1=0"
)
exit /B 0

:xqtJMeter
set WDL=%BDL%\%TST%
set JTD=%WDL%\jmeter
echo "DBG... JTD: %JTD%, DOC: %DOC%, TST: %TST%" >>%LFN% 2>&1
set JHX=2048
set BOT=1
set BNS=001
set VUC=4
set CSV=%WDL%\txn.csv
set JTF=%DOC%
cd !JTD!\bin
echo "DBG: running test %TST% ... java -Xms512M -Xmx%JHX%M -jar ApacheJMeter.jar -n -Jlg=%BOT% -Jthreads=%VUC% -d !JTD! -j %WDL%/log/jmeter-%BNS%.log -l %CSV% -t %JTF%" >>%LFN% 2>&1
java -Xms512M -Xmx%JHX%M -jar ./ApacheJMeter.jar -n -Jlg=%BOT% -Jthreads=%VUC% -d "!JTD!" -j "%WDL%/log/jmeter-%BNS%.log" -l "%CSV%" -t %JTF% >>%LFN% 2>&1
set "%~1=0"
exit /B 0
