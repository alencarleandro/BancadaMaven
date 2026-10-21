package br.edu.seminario.loja;

import java.math.BigDecimal;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class PedidoTest {
    private Pedido pedido(String preco, int quantidade, String desconto) {
        return new Pedido(new BigDecimal(preco), quantidade, new BigDecimal(desconto));
    }

    @Test void calculaTotalSemDesconto() {
        assertEquals(new BigDecimal("15.00"), pedido("5.00", 3, "0").total());
    }

    @Test void aplicaDezPorCento() {
        Pedido resumo = pedido("5.00", 3, "10");
        assertEquals(new BigDecimal("15.00"), resumo.subtotal());
        assertEquals(new BigDecimal("1.50"), resumo.desconto());
        assertEquals(new BigDecimal("13.50"), resumo.total());
    }

    @Test void rejeitaPrecoNegativo() {
        assertThrows(IllegalArgumentException.class, () -> pedido("-1.00", 1, "0"));
    }

    @Test void rejeitaQuantidadeZero() {
        assertThrows(IllegalArgumentException.class, () -> pedido("5.00", 0, "0"));
    }

    @Test void rejeitaDescontoAcimaDeCem() {
        assertThrows(IllegalArgumentException.class, () -> pedido("5.00", 1, "101"));
    }

    @Test void rejeitaDescontoNegativo() {
        assertThrows(IllegalArgumentException.class, () -> pedido("5.00", 1, "-1"));
    }

    @Test void arredondaDescontoParaCentavos() {
        assertEquals(new BigDecimal("8.99"), pedido("9.99", 1, "10").total());
    }
}
