# Execute com ponto e espaco: . .\loja-maven\preparar-terminal.ps1
if (-not (Get-Command java -ErrorAction SilentlyContinue)) { throw 'Java nao encontrado. Instale um JDK 17 ou superior.' }
# Java escreve as propriedades em stderr. O Windows PowerShell 5.1 transforma
# essas linhas em ErrorRecord; capture-as sem interromper o ensaio com Stop.
$preferenciaErroLoja = $ErrorActionPreference
try {
    $ErrorActionPreference = 'Continue'
    $javaInfoLoja = & java -XshowSettings:properties -version 2>&1
    $javaExitLoja = $LASTEXITCODE
} finally {
    $ErrorActionPreference = $preferenciaErroLoja
}
if ($javaExitLoja -ne 0) { throw 'Nao foi possivel executar o Java. Confira a instalacao do JDK.' }
$javaHomeLinhaLoja = $javaInfoLoja | ForEach-Object { "$_" } | Where-Object { $_ -match '^\s*java.home\s*=' } | Select-Object -First 1
if (-not $javaHomeLinhaLoja) { throw 'Java nao encontrado. Instale um JDK 17 ou superior.' }
$jdkLoja = ($javaHomeLinhaLoja -split '=', 2)[1].Trim()
if (-not (Test-Path -LiteralPath (Join-Path $jdkLoja 'bin/javac.exe'))) { throw 'Configure um JDK 17 ou superior, incluindo javac.' }
$javaVersionLoja = $javaInfoLoja | ForEach-Object { "$_" } | Where-Object { $_ -match '^\s*java.specification.version\s*=' } | Select-Object -First 1
if (-not $javaVersionLoja -or [int](($javaVersionLoja -split '=', 2)[1].Trim()) -lt 17) { throw 'Este projeto exige JDK 17 ou superior.' }
$env:JAVA_HOME = $jdkLoja
$env:Path = (Join-Path $jdkLoja 'bin') + ';' + $env:Path
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Instale o Git e adicione ao PATH.' }
$repoLocalLoja = & git -C $PSScriptRoot rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0) { throw 'Clone o repositorio com git clone antes de preparar o terminal.' }
$env:LOJA_GIT_URL = ([System.Uri]::new(($repoLocalLoja.Trim() -replace '/', '\'))).AbsoluteUri
Write-Host "JDK preparado: $jdkLoja"
Write-Host "Maven SCM usara o repositorio local: $env:LOJA_GIT_URL"
