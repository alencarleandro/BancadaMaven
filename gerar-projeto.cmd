@echo off
setlocal
set "NOME_PROJETO=%~1"
if "%NOME_PROJETO%"=="" set "NOME_PROJETO=projeto-gerado"
if exist "%~dp0oficina\%NOME_PROJETO%" (
  echo Essa pasta ja existe. Repita com um nome novo: gerar-projeto.cmd outro-projeto
  exit /b 1
)
pushd "%~dp0"
echo O Maven vai gerar o POM e a estrutura Java a partir do archetype quickstart.
call "%~dp0loja-maven\maven.cmd" %MAVEN_DEMO_OFFLINE% -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate ^
 "-DarchetypeGroupId=org.apache.maven.archetypes" ^
 "-DarchetypeArtifactId=maven-archetype-quickstart" ^
 "-DarchetypeVersion=1.5" ^
 "-DgroupId=br.edu.seminario" ^
 "-DartifactId=%NOME_PROJETO%" ^
 "-Dversion=1.0.0" ^
 "-Dpackage=br.edu.seminario.gerado" ^
 "-DinteractiveMode=false" ^
 "-DarchetypeCatalog=internal" ^
 "-DoutputDirectory=oficina"
set "DEMO_RESULT=%ERRORLEVEL%"
popd
exit /b %DEMO_RESULT%
