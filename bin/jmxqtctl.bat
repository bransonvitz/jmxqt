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
set JTD=%HDL%\jmeter
set OK=-1

set DOC=""
if NOT "%1"=="" (set DOC=%1)
set TST=0
if NOT "%2"=="" (set TST=%2)

call :stgJMeter OK
if /I "%OK%"=="0" call :xqtJMeter RC
if /I "%RC%" NEQ "0" (set OK=1)
exit /B %OK%

:stgJMeter
if /I "!TST!" LEQ "0" ( set TST=101)
if EXIST "%HDL%\bin\jmxqt.bat" (
	CALL %HDL%\bin\jmxqt.bat stage !DOC! !TST!
	set "%~1=%errorlevel%"
) else ( set "%~1=0" )
exit /B 0

:xqtJMeter
if NOT EXIST "%HDL%\bin\jmxqt.bat" (
	set JHX=2048
	set CSV=%CD%\txn.csv
	set JLF=%CD%\jmeter.log
	FOR /F "tokens=* USEBACKQ" %%F IN (`dir /B /S !DOC!`) DO ( set JTF=%%F)
	if EXIST "!JTF!" (
		cd !JTD!\bin
		java -Xms512M -Xmx!JHX!M -jar ApacheJMeter.jar -n -d "!JTD!" -j "!JLF!" -l "!CSV!" -t !JTF! >>!LFN! 2>&1
		set "%~1=0"
	) else (
		echo "ERR: no valid JMX specified !JTF!" >> !LFN! 2>&1
		set "%~1=1"
	)
) else (
	CALL %HDL%\bin\jmxqt.bat launch !DOC! !TST!
	set "%~1=%errorlevel%"
)
exit /B 0
