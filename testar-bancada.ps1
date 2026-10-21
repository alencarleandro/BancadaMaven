param([switch]$Offline)

# Ensaio verificavel dos sete topicos. Rode a partir de qualquer pasta.
$ErrorActionPreference = 'Stop'
$localAnteriorBancada = Get-Location
$offlineAnteriorBancada = $env:MAVEN_DEMO_OFFLINE
try {
    Set-Location -LiteralPath $PSScriptRoot
    . ./loja-maven/preparar-terminal.ps1
    $modoBancada = @()
    if ($Offline) { $modoBancada = @('-o'); $env:MAVEN_DEMO_OFFLINE = '-o' }
    else { $env:MAVEN_DEMO_OFFLINE = '' }
    New-Item -ItemType Directory -Force -Path '.bancada/logs' | Out-Null
    function Invoke-EtapaBancada {
        param([string]$Nome, [scriptblock]$Acao)
        $arquivoBancada = Join-Path $PSScriptRoot ".bancada/logs/$Nome.log"
        & $Acao *> $arquivoBancada
        if ($LASTEXITCODE -ne 0) {
            Get-Content -LiteralPath $arquivoBancada -Tail 35
            throw "Falha em $Nome. Veja $arquivoBancada"
        }
        Write-Host "OK: $Nome"
    }
    Invoke-EtapaBancada '00-limpar' { & ./loja-maven/maven.cmd @modoBancada -f loja-maven/pom.xml clean }
    $nomeEnsaioBancada = 'ensaio-' + [guid]::NewGuid().ToString('N').Substring(0, 8)
    Invoke-EtapaBancada '01-gerar-pom' { & ./gerar-projeto.cmd $nomeEnsaioBancada }
    if (-not (Test-Path "oficina/$nomeEnsaioBancada/pom.xml")) { throw 'POM gerado ausente.' }
    Set-Location loja-maven
    Invoke-EtapaBancada '02-checkout-git' { & ./maven.cmd @modoBancada scm:checkout }
    if (-not (Test-Path 'target/copia-git/loja-maven/pom.xml')) { throw 'Checkout sem o projeto. Confira os commits da branch main.' }
    Invoke-EtapaBancada '03-compilar' { & ./maven.cmd @modoBancada compile }
    Invoke-EtapaBancada '03-compilar-novamente' { & ./maven.cmd @modoBancada compile }
    if (-not (Select-String -LiteralPath "$PSScriptRoot/.bancada/logs/03-compilar-novamente.log" -SimpleMatch 'Nothing to compile')) { throw 'A segunda compilacao nao reutilizou as classes.' }
    Invoke-EtapaBancada '04-empacotar' { & ./maven.cmd @modoBancada package }
    Invoke-EtapaBancada '04-executar' { & java -jar target/loja-maven-1.0.0.jar }
    if (-not (Select-String -LiteralPath "$PSScriptRoot/.bancada/logs/04-executar.log" -SimpleMatch 'TOTAL: R$ 13.50')) { throw 'Total inesperado.' }
    Invoke-EtapaBancada '05-testar' { & ./maven.cmd @modoBancada test }
    [xml]$resultadoBancada = Get-Content 'target/surefire-reports/TEST-br.edu.seminario.loja.PedidoTest.xml'
    if ($resultadoBancada.testsuite.tests -ne '7' -or $resultadoBancada.testsuite.failures -ne '0' -or $resultadoBancada.testsuite.errors -ne '0') { throw 'Os sete testes devem passar.' }
    Invoke-EtapaBancada '06-relatorio' { & ./maven.cmd @modoBancada surefire-report:report-only }
    Invoke-EtapaBancada '07-documentacao' { & ./maven.cmd @modoBancada javadoc:javadoc }
    foreach ($saidaBancada in @('target/reports/surefire.html', 'target/reports/apidocs/index.html')) {
        if (-not (Test-Path -LiteralPath $saidaBancada)) { throw "Saida ausente: $saidaBancada" }
    }
    Write-Host 'BANCADA APROVADA: sete topicos demonstrados, sete testes sem falhas.'
    Write-Host 'Relatorio: loja-maven/target/reports/surefire.html'
    Write-Host 'Documentacao: loja-maven/target/reports/apidocs/index.html'
} finally {
    $env:MAVEN_DEMO_OFFLINE = $offlineAnteriorBancada
    Set-Location -LiteralPath $localAnteriorBancada.Path
}
