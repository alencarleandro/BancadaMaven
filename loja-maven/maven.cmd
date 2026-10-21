@echo off
setlocal
if defined MAVEN_DEMO_REPO (
  set "DEMO_REPO_ARG=-Dmaven.repo.local=%MAVEN_DEMO_REPO%"
)
if defined MAVEN_HOME if exist "%MAVEN_HOME%\bin\mvn.cmd" goto mavenHome
where mvn.cmd >nul 2>&1
if errorlevel 1 (
  echo Maven nao encontrado. Instale o Apache Maven e adicione sua pasta bin ao PATH.
  exit /b 1
)
if defined MAVEN_DEMO_REPO (
  call mvn.cmd "%DEMO_REPO_ARG%" %*
) else (
  call mvn.cmd %*
)
exit /b %ERRORLEVEL%

:mavenHome
if defined MAVEN_DEMO_REPO (
  call "%MAVEN_HOME%\bin\mvn.cmd" "%DEMO_REPO_ARG%" %*
) else (
  call "%MAVEN_HOME%\bin\mvn.cmd" %*
)
exit /b %ERRORLEVEL%
