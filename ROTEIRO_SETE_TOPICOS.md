# Demonstração dos sete tópicos com Maven

## Preparação antes da aula

Clone este repositório. É necessário ter JDK 17 ou superior e Git no PATH. O Maven Wrapper oficial baixa e usa o Maven automaticamente, sem exigir mvn no PATH. Execute primeiro o ensaio explicado no README com internet para preparar o Maven e as dependências; depois os comandos com -o funcionam offline.
Abra o PowerShell na pasta BancadaMaven. Antes da aula, prepare o terminal e limpe a saída. Mantenha o pom.xml aberto no editor.

```powershell
. .\loja-maven\preparar-terminal.ps1
.\loja-maven\maven.cmd -o -f loja-maven/pom.xml clean
```

## 1 Geração do script de construção

Tempo sugerido: 50 segundos. Pasta: BancadaMaven, a pasta principal do kit.

```powershell
$env:MAVEN_DEMO_OFFLINE = '-o'
.\gerar-projeto.cmd
Get-Content oficina/projeto-gerado/pom.xml -TotalCount 25
```

**O que mostrar:** Mostre o POM e as pastas src/main/java e src/test/java recém-criados em oficina/projeto-gerado.

**O que falar:** Vou pedir ao Maven um projeto inicial a partir de um modelo chamado archetype. Ele gera o pom.xml e a estrutura Java. O POM é o arquivo declarativo de configuração do build: ali ficam a identidade do projeto, as dependências e os plugins. Depois podemos personalizá-lo.

**Cuidado e contexto:** O arquivo gerar-projeto.cmd apenas chama o plugin Archetype oficial com parâmetros fixos. Abra esse arquivo se o professor quiser ver o comando completo. O projeto gerado ilustra este tópico; os próximos passos usam a loja já preparada. Para repetir, escolha outro nome: gerar-projeto.cmd projeto-gerado-2.

## 2 Integração com controle de versão

Tempo sugerido: 45 segundos. Pasta: Entre em loja-maven e permaneça nela até o fim.

```powershell
cd loja-maven
.\maven.cmd -o scm:checkout
Get-Content target/copia-git/loja-maven/pom.xml -TotalCount 10
```

**O que mostrar:** Mostre a cópia do projeto em target/copia-git, obtida do próprio repositório BancadaMaven clonado em seu computador.

**O que falar:** Agora o plugin SCM do Maven está chamando o Git para obter uma cópia da branch main. O repositório é local, então não dependemos de GitHub ou internet. Aqui está o POM recuperado do controle de versão. É uma integração do Maven com Git.

**Cuidado e contexto:** A seção scm do POM usa a URL local preparada no terminal. O plugin foi configurado para a branch main e para o diretório target/copia-git. Esta operação não envia commits e não altera repositórios externos.

## 3 Recompilação mínima

Tempo sugerido: 40 segundos. Pasta: loja-maven.

```powershell
.\maven.cmd -o compile
.\maven.cmd -o compile
```

**O que mostrar:** Compare a compilação inicial com a segunda execução. Na segunda, procure Nothing to compile - all classes are up to date.

**O que falar:** Na primeira execução, o plugin compila as classes. Sem alterar os arquivos e sem usar clean, executo novamente. Agora ele informa que as classes estão atualizadas e evita uma nova compilação. Esse é o comportamento observado neste exemplo.

**Cuidado e contexto:** Não prometa recompilação mínima universal. Ao alterar um arquivo, este plugin pode recompilar todo o módulo. Clean remove as classes e exige reconstruí-las. Para uma extensão opcional, adicione um comentário em Pedido.java, salve e execute compile novamente.

## 4 Criação do sistema executável

Tempo sugerido: 45 segundos. Pasta: loja-maven.

```powershell
.\maven.cmd -o package
java -jar target/loja-maven-1.0.0.jar
```

**O que mostrar:** Mostre BUILD SUCCESS, o JAR na pasta target e o total de R$ 13.50 calculado pela loja.

**O que falar:** Package gera o artefato distribuível. O JAR Plugin foi configurado com a classe principal, permitindo executar o resultado com Java. A loja recebe três produtos de cinco reais, aplica dez por cento de desconto e retorna treze reais e cinquenta centavos.

**Cuidado e contexto:** Este é um JAR executável pela JVM, não um arquivo nativo .exe. Package também percorre a fase de testes, por isso eles já aparecem neste passo. Não use clean agora, pois ele apagaria a cópia Git mostrada anteriormente.

## 5 Automação dos testes

Tempo sugerido: 40 segundos. Pasta: loja-maven.

```powershell
.\maven.cmd -o test
```

**O que mostrar:** Aponte Tests run: 7, Failures: 0, Errors: 0 e BUILD SUCCESS.

**O que falar:** O Surefire executa os testes automaticamente com JUnit. Eles verificam cálculo, desconto, arredondamento e entradas inválidas. Eu não preciso abrir cada teste e executá-lo manualmente. O resultado mostra sete testes aprovados.

**Cuidado e contexto:** JUnit é a dependência dos testes e Surefire é o plugin que os executa. Se quiser mostrar uma falha, mude a expectativa 13.50 para 14.00 no teste aplicaDezPorCento, execute test e restaure 13.50 antes de continuar. Deixe essa extensão para um ensaio mais longo.

## 6 Emissão de relatórios

Tempo sugerido: 40 segundos. Pasta: loja-maven.

```powershell
.\maven.cmd -o surefire-report:report-only
Invoke-Item target/reports/surefire.html
```

**O que mostrar:** No navegador, mostre o resumo com sete testes, zero falhas e zero erros.

**O que falar:** Os testes gravam seus resultados. Agora outro plugin transforma esses dados em um relatório HTML, que facilita consultar quantidade de testes, falhas, erros e tempo de execução. Este comando apenas monta o relatório dos resultados existentes.

**Cuidado e contexto:** Report-only não executa testes. Por isso este passo vem depois de test. Se mostrar uma falha opcional, restaure o teste e rode test novamente antes de gerar o relatório final.

## 7 Geração da documentação

Tempo sugerido: 40 segundos. Pasta: loja-maven.

```powershell
.\maven.cmd -o javadoc:javadoc
Invoke-Item target/reports/apidocs/index.html
```

**O que mostrar:** Abra a classe Pedido na documentação e mostre a descrição, os parâmetros do construtor e os métodos subtotal, desconto e total.

**O que falar:** O Javadoc Plugin gera documentação HTML a partir dos comentários do código. Aqui temos a descrição da classe, seus parâmetros e seus métodos. Assim, o Maven também automatiza a publicação da documentação técnica da API.

**Cuidado e contexto:** É documentação da API Java, não um manual completo para usuários finais. A geração depende dos comentários Javadoc já escritos no código. Clean apaga a documentação porque ela fica dentro de target.

## Encerramento

Nesta sequência, o Maven gerou uma estrutura inicial, integrou Git por meio de plugin, evitou recompilar classes sem mudanças, gerou um JAR executável, automatizou testes, emitiu um relatório e produziu documentação.

## Tempo

Os sete passos somam 5 minutos, com cache pronto e comandos ensaiados. Para o seminário de 10 minutos, reserve 4min30s aos slides e 30s às perguntas. Ensaie a sequência antes da apresentação.

## Fontes

- [Geração com Archetype](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html)
- [Integração SCM](https://maven.apache.org/scm/maven-scm-plugin/usage.html)
- [Compiler Plugin](https://maven.apache.org/plugins/maven-compiler-plugin/compile-mojo.html)
- [Ciclo de vida do build](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)
- [Relatório Surefire](https://maven.apache.org/surefire/maven-surefire-report-plugin/report-only-mojo.html)
- [Javadoc Plugin](https://maven.apache.org/plugins/maven-javadoc-plugin/usage.html)
