package br.edu.seminario.loja;

import java.math.BigDecimal;

/** Aplicação de terminal usada para apresentar o JAR gerado pelo Maven. */
public final class App {
    private App() { }

    /**
     * Mostra um pedido. Sem argumentos, usa preço 5.00, quantidade 3 e desconto 10.
     * @param args preço unitário, quantidade e desconto percentual, ou nenhum argumento
     */
    public static void main(String[] args) {
        if (args.length != 0 && args.length != 3) {
            System.err.println("Uso: java -jar target/loja-maven-1.0.0.jar [preco quantidade desconto]");
            System.err.println("Exemplo: java -jar target/loja-maven-1.0.0.jar 5.00 3 10");
            System.exit(1);
            return;
        }
        try {
            BigDecimal preco = new BigDecimal(args.length == 0 ? "5.00" : args[0]);
            int quantidade = args.length == 0 ? 3 : Integer.parseInt(args[1]);
            BigDecimal percentual = new BigDecimal(args.length == 0 ? "10" : args[2]);
            Pedido pedido = new Pedido(preco, quantidade, percentual);
            System.out.println("=== LOJA MAVEN ===");
            System.out.println("Preco unitario: R$ " + preco.toPlainString());
            System.out.println("Quantidade: " + quantidade);
            System.out.println("Subtotal: R$ " + pedido.subtotal().toPlainString());
            System.out.println("Desconto: R$ " + pedido.desconto().toPlainString());
            System.out.println("TOTAL: R$ " + pedido.total().toPlainString());
            System.out.println("Aplicacao executada a partir do JAR gerado pelo Maven.");
        } catch (NumberFormatException error) {
            System.err.println("Informe preco e desconto com ponto decimal e quantidade inteira.");
            System.exit(1);
        } catch (IllegalArgumentException error) {
            System.err.println(error.getMessage());
            System.exit(1);
        }
    }
}
