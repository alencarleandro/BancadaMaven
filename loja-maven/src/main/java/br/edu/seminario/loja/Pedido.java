package br.edu.seminario.loja;

import java.math.BigDecimal;
import java.math.RoundingMode;

/** Calcula um pedido de um produto com desconto percentual. */
public final class Pedido {
    private final BigDecimal subtotal;
    private final BigDecimal desconto;

    /**
     * Cria o resumo financeiro de um pedido.
     * @param precoUnitario preço não negativo do produto
     * @param quantidade quantidade maior que zero
     * @param percentualDesconto desconto de zero a cem por cento
     */
    public Pedido(BigDecimal precoUnitario, int quantidade,
                  BigDecimal percentualDesconto) {
        if (precoUnitario == null || precoUnitario.signum() < 0) {
            throw new IllegalArgumentException("Preco deve ser maior ou igual a zero.");
        }
        if (quantidade <= 0) {
            throw new IllegalArgumentException("Quantidade deve ser maior que zero.");
        }
        if (percentualDesconto == null || percentualDesconto.signum() < 0
                || percentualDesconto.compareTo(new BigDecimal("100")) > 0) {
            throw new IllegalArgumentException("Desconto deve estar entre 0 e 100.");
        }
        subtotal = precoUnitario.multiply(BigDecimal.valueOf(quantidade))
                .setScale(2, RoundingMode.HALF_UP);
        desconto = subtotal.multiply(percentualDesconto)
                .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
    }

    /**
     * Consulta o valor antes do desconto.
     * @return valor dos produtos com duas casas decimais
     */
    public BigDecimal subtotal() {
        return subtotal;
    }

    /**
     * Consulta o desconto calculado.
     * @return valor monetário do desconto com duas casas decimais
     */
    public BigDecimal desconto() {
        return desconto;
    }

    /**
     * Consulta o valor final a pagar.
     * @return subtotal menos desconto
     */
    public BigDecimal total() {
        return subtotal.subtract(desconto);
    }
}
