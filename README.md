# JMeter XQT
A utility for adding headless execution to the JMeter GUI

## Introduction
The utility consists of primarily a JMeter plugin, which observes a particular
execution footprint designed to operate from an arbitrary git clone directory.

### Installation
-	Ensure `bin` and `log` subdirectories exist under `${HOME}`
-	Install JMeter directly under `${HOME}`, in subdirectory (or with symbolic link) named `jmeter`
-	Copy the platform-suitable script to `${HOME}/bin`
	(`jmxqtctl.bat` for Windows, `jmxqtctl` otherwise)
-	Place the JMeter plugin (`AA-xqt.jar`) in `${HOME}/jmeter/lib/ext`

### Operation
-	Change working directory to a github clone directory containing test sources
-	Start JMeter GUI by invoking the platform-suitable JMeter script in `${HOME}/jmeter/bin`
-	Load a JMX in the JMeter GUI and click the large "jewel" button
-	Output of headless operation will be logged to `${HOME}/log/jmxqt.log`
-	Default behavior can be overridden with a custom script under `${HOME}/bin`:
	-	Named `jmxqt` for Linux or MacOS, `jmxqt.bat` for Windows
	-	Calling convention/parameters can be discerned from the stock script

## Linux
The generic installation instructions (above) should be effective.

## MacOS
The generic installation instructions (above) should be effective.

## Windows
The JMeter batch file can be invoked directly via full path in a `command.exe`
terminal, or a desktop shortcut can be set up, with these considerations:
-	A batch file launched from a desktop shortcut will create a terminal window,
	unless one of a variety of techniques is employed:
	-	Use an invocation style like:
		`cmd.exe /c "start /min %userprofile%\jmeter\bin\jmeter.bat"`
	-	Use some intervening startup mechanic, such as a VBScript wrapper
-	The `Start in` setting of the shortcut would have to be changed to match
	the full path of your git clone directory, for each project you work on
