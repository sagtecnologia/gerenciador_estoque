-- =====================================================
-- SCRIPT: Limpar Movimentações de Teste
-- Descrição: Remove pedidos, itens e movimentações de estoque
-- mantendo produtos, fornecedores, clientes e usuários
-- =====================================================

-- IMPORTANTE: Este script remove TODOS os pedidos e movimentações
-- Use com cuidado! Faça backup antes de executar.

BEGIN;

-- 1. Limpar itens de pedidos (deve ser feito antes de limpar pedidos)
DELETE FROM pedido_itens;

-- 2. Limpar pedidos (compras e vendas)
DELETE FROM pedidos;

-- 3. Limpar movimentações de estoque
DELETE FROM estoque_movimentacoes;

-- 4. Resetar estoque dos produtos para zero
UPDATE produtos SET estoque_atual = 0;

-- 5. Resetar estoque dos sabores para zero (se existir a tabela)
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'produto_sabores') THEN
        UPDATE produto_sabores SET quantidade = 0;
    END IF;
END $$;

-- 6. Resetar sequências/contadores (opcional)
-- Se você quiser que os próximos pedidos comecem do número 1 novamente

COMMIT;

-- =====================================================
-- VERIFICAÇÕES
-- =====================================================

-- Verificar se está tudo limpo
SELECT 
    'pedidos' as tabela,
    COUNT(*) as total
FROM pedidos
UNION ALL
SELECT 
    'pedido_itens',
    COUNT(*)
FROM pedido_itens
UNION ALL
SELECT 
    'estoque_movimentacoes',
    COUNT(*)
FROM estoque_movimentacoes
UNION ALL
SELECT 
    'produtos com estoque',
    COUNT(*)
FROM produtos
WHERE estoque_atual > 0;

-- Listar produtos e seus estoques
SELECT 
    codigo,
    nome,
    estoque_atual,
    estoque_minimo
FROM produtos
ORDER BY nome;
