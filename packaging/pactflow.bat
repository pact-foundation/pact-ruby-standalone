@echo off

SET RUNNING_PATH=%~dp0
CALL :RESOLVE "%RUNNING_PATH%\.." ROOT_PATH

:: Tell Bundler where the Gemfile and gems are.
set "BUNDLE_GEMFILE=%ROOT_PATH%\lib\vendor\Gemfile"
set BUNDLE_IGNORE_CONFIG=
set RUBYGEMS_GEMDEPS=
set BUNDLE_APP_CONFIG=
set BUNDLE_FROZEN=1

:: Run the actual app using the bundled Ruby interpreter, with Bundler activated.
@"%ROOT_PATH%\lib\ruby\bin\ruby.bat" -E UTF-8 -rbundler/setup -I "%ROOT_PATH%\lib\app\lib" "%ROOT_PATH%\lib\app\pactflow.rb" %*

GOTO :EOF

:RESOLVE
SET %2=%~f1
GOTO :EOF
