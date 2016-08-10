@echo off

set "CATALINA_HOME=${catalina_home}"
set "CATALINA_BASE=${catalina_base}"
set "TOMCAT_VERSION=${tomcat_version}"
set "SERVICE_NAME=${service_name}"

echo ---------------------------------------------------------
echo Install tomcat%TOMCAT_VERSION%%SERVICE_NAME% service...
echo ---------------------------------------------------------

call %CATALINA_HOME%\bin\service.bat install "tomcat%TOMCAT_VERSION%%SERVICE_NAME%"

pause