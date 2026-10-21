# Bancada Maven

Projeto didático para apresentar **sete funcionalidades de uma ferramenta de build** com Apache Maven. A aplicação é uma loja de terminal: calcula subtotal, desconto e total de um pedido. O exemplo padrão tem três unidades de R$ 5,00 e desconto de 10%, totalizando **R$ 13,50**.

## Começar

No Windows, instale **JDK 17 ou superior**, **Git** e **Apache Maven**. Deixe `java`, `javac`, `git` e `mvn` disponíveis no PATH. O VS Code é opcional para mostrar os arquivos; os comandos rodam no PowerShell.

```powershell
git clone https://github.com/alencarleandro/BancadaMaven.git
cd BancadaMaven
. .\loja-maven\preparar-terminal.ps1
.\loja-maven\maven.cmd -version
```

Use `git clone`, pois a demonstração de SCM precisa do histórico Git. O script prepara o JDK e a URL Git apenas na sessão atual. `maven.cmd` chama o Maven instalado; ele não é o Maven Wrapper oficial e não baixa o Maven. Também aceita `MAVEN_HOME` para apontar a uma instalação existente.

## Ensaiar antes da aula

Com internet, execute uma vez para baixar os plugins e as dependências e conferir toda a bancada:

```powershell
.\testar-bancada.ps1
```

Depois, confirme o funcionamento sem downloads:

```powershell
.\testar-bancada.ps1 -Offline
```

O ensaio gera um projeto de nome único em `oficina`, faz checkout Git local, compila duas vezes, gera e executa o JAR, roda os sete testes e gera relatório e Javadoc. Verifica os arquivos, o total calculado e a reutilização das classes na segunda compilação. Os logs ficam em `.bancada/logs`. O script começa com `clean`, que apaga as saídas anteriores em `loja-maven/target`.

Se o PowerShell bloquear scripts, use uma sessão com política permitida no seu computador ou execute os comandos manualmente após configurar `JAVA_HOME` e `LOJA_GIT_URL`, conforme `preparar-terminal.ps1`.

## Demonstração: os sete tópicos

O [roteiro completo](ROTEIRO_SETE_TOPICOS.md) contém as falas, o que mostrar e os tempos sugeridos, somando cerca de **5 minutos**. Após o ensaio com internet, abra um terminal na raiz do repositório e prepare a apresentação:

```powershell
. .\loja-maven\preparar-terminal.ps1
$env:MAVEN_DEMO_OFFLINE = '-o'
.\loja-maven\maven.cmd -o -f loja-maven/pom.xml clean
```

### 1. Geração do script de construção

```powershell
.\gerar-projeto.cmd
Get-Content oficina/projeto-gerado/pom.xml -TotalCount 25
```

Mostre o `pom.xml` e as pastas Java geradas pelo Archetype Plugin. O POM é uma configuração declarativa do build. O arquivo `.cmd` apenas passa parâmetros ao plugin oficial. Se a pasta já existir, use outro nome: `.\gerar-projeto.cmd projeto-gerado-2`.

### 2. Integração com controle de versão

```powershell
cd loja-maven
.\maven.cmd -o scm:checkout
Get-Content target/copia-git/loja-maven/pom.xml -TotalCount 10
```

O SCM Plugin chama o Git e copia a branch `main` do próprio repositório local para `target/copia-git`. Isso demonstra a integração sem depender de internet. O checkout contém somente arquivos já commitados. Permaneça em `loja-maven` até o passo 7.

### 3. Recompilação mínima

```powershell
.\maven.cmd -o compile
.\maven.cmd -o compile
```

Na segunda execução, procure `Nothing to compile - all classes are up to date`. Sem mudanças, o plugin evita recompilar. Ao alterar fontes, ele pode recompilar o módulo inteiro; o exemplo não promete recompilação de apenas um arquivo em todos os casos.

### 4. Criação do sistema executável

```powershell
.\maven.cmd -o package
java -jar target/loja-maven-1.0.0.jar
java -jar target/loja-maven-1.0.0.jar 10.00 2 10
```

O primeiro pedido retorna `13.50`; o segundo, `18.00`. O JAR tem a classe principal configurada e é executado pela JVM. **Curiosidade:** `package` já percorre a fase de testes antes de empacotar. Um teste que falha impede a geração de um novo pacote bem-sucedido.

### 5. Automação dos testes

```powershell
.\maven.cmd -o test
```

Mostre `Tests run: 7, Failures: 0, Errors: 0`. JUnit fornece os testes e Surefire os executa. Eles cobrem cálculos, arredondamento e entradas inválidas. Veja [PedidoTest.java](loja-maven/src/test/java/br/edu/seminario/loja/PedidoTest.java).

### 6. Emissão de relatórios

```powershell
.\maven.cmd -o surefire-report:report-only
Invoke-Item target/reports/surefire.html
```

Abra o HTML com o resumo dos testes. `report-only` usa os resultados já gerados; não executa novos testes.

### 7. Geração da documentação

```powershell
.\maven.cmd -o javadoc:javadoc
Invoke-Item target/reports/apidocs/index.html
```

Abra a classe `Pedido` e mostre os parâmetros e métodos documentados a partir dos comentários Javadoc. É documentação da API Java.

**Durante os passos 2 a 7, não execute `clean`: ele apaga o checkout, as classes, os relatórios e a documentação em `target`.**

## Organização

```text
BancadaMaven/
  README.md                    instruções e comandos
  ROTEIRO_SETE_TOPICOS.md       falas para a apresentação
  gerar-projeto.cmd            geração de um projeto com Archetype
  testar-bancada.ps1           ensaio automático dos sete tópicos
  loja-maven/
    pom.xml                    dependências e plugins com versões fixadas
    preparar-terminal.ps1      JDK e URL Git local na sessão atual
    maven.cmd                  chamada ao Maven instalado
    src/main/java/             aplicação e classe Pedido
    src/test/java/             sete testes JUnit
```

`target`, `oficina`, logs e caches não são versionados. As versões fixadas no POM reproduzem a demonstração; não indicam as versões mais recentes. O repositório contém fontes, sem distribuição do Maven ou cache de dependências.

## Referências

- [Ciclo de vida do Maven](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)
- [Archetype Plugin](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html)
- [SCM Plugin](https://maven.apache.org/scm/maven-scm-plugin/usage.html)
- [Compiler Plugin](https://maven.apache.org/plugins/maven-compiler-plugin/compile-mojo.html)
- [Surefire Report Plugin](https://maven.apache.org/surefire/maven-surefire-report-plugin/report-only-mojo.html)
- [Javadoc Plugin](https://maven.apache.org/plugins/maven-javadoc-plugin/usage.html)
