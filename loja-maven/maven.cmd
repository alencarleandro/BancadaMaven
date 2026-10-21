@echo off
setlocal
if defined MAVEN_DEMO_REPO (
  set "DEMO_REPO_ARG=-Dmaven.repo.local=%MAVEN_DEMO_REPO%"
)
if not exist "%~dp0mvnw.cmd" (
  echo Maven Wrapper nao encontrado. Atualize o repositorio com git pull.
  exit /b 1
)
if defined MAVEN_DEMO_REPO (
  call "%~dp0mvnw.cmd" "%DEMO_REPO_ARG%" %*
) else (
  call "%~dp0mvnw.cmd" %*
)
exit /b %ERRORLEVEL%
