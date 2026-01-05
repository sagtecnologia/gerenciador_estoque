-- =====================================================
-- REMOVER FLUXO DE APROVAÇÃO DE PEDIDOS
-- =====================================================
-- Este script remove a necessidade de aprovação para finalizar pedidos
-- tanto de compra quanto de venda

-- 1. Atualizar função de finalizar pedido (remover validação de aprovação)
CREATE OR REPLACE FUNCTION finalizar_pedido(p_pedido_id UUID, p_usuario_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_item RECORD;
    v_status VARCHAR;
    v_tipo_pedido VARCHAR;
BEGIN
    -- Buscar informações do pedido
    SELECT status, tipo_pedido INTO v_status, v_tipo_pedido FROM pedidos WHERE id = p_pedido_id;
    
    -- Não permitir finalizar pedidos já finalizados
    IF v_status = 'FINALIZADO' THEN
        RAISE EXCEPTION 'Este pedido já foi finalizado';
    END IF;

    -- Processar movimentação de estoque baseado no tipo de pedido
    FOR v_item IN 
        SELECT produto_id, quantidade 
        FROM pedido_itens 
        WHERE pedido_id = p_pedido_id
    LOOP
        IF v_tipo_pedido = 'COMPRA' THEN
            -- Pedido de compra: ENTRADA no estoque
            PERFORM processar_movimentacao_estoque(
                v_item.produto_id,
                'ENTRADA',
                v_item.quantidade,
                p_usuario_id,
                p_pedido_id,
                'Entrada automática - Finalização de pedido de compra'
            );
        ELSE
            -- Pedido de venda: SAÍDA do estoque
            PERFORM processar_movimentacao_estoque(
                v_item.produto_id,
                'SAIDA',
                v_item.quantidade,
                p_usuario_id,
                p_pedido_id,
                'Baixa automática - Finalização de pedido de venda'
            );
        END IF;
    END LOOP;

    -- Atualizar status do pedido
    UPDATE pedidos 
    SET status = 'FINALIZADO', 
        data_finalizacao = NOW()
    WHERE id = p_pedido_id;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Garantir permissões de execução para usuários autenticados
GRANT EXECUTE ON FUNCTION finalizar_pedido(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION processar_movimentacao_estoque(UUID, VARCHAR, NUMERIC, UUID, UUID, TEXT) TO authenticated;

-- 3. Adicionar política RLS para ADMIN cancelar/reabrir pedidos
DROP POLICY IF EXISTS "ADMIN pode cancelar ou reabrir pedidos" ON pedidos;
CREATE POLICY "ADMIN pode cancelar ou reabrir pedidos"
    ON pedidos FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role = 'ADMIN'
        )
    );

-- 4. Adicionar políticas RLS para excluir pedidos em RASCUNHO
DROP POLICY IF EXISTS "Solicitante pode excluir pedidos em RASCUNHO" ON pedidos;
CREATE POLICY "Solicitante pode excluir pedidos em RASCUNHO"
    ON pedidos FOR DELETE
    USING (
        solicitante_id = auth.uid() AND status = 'RASCUNHO'
    );

DROP POLICY IF EXISTS "ADMIN pode excluir pedidos em RASCUNHO" ON pedidos;
CREATE POLICY "ADMIN pode excluir pedidos em RASCUNHO"
    ON pedidos FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role = 'ADMIN'
        ) AND status = 'RASCUNHO'
    );

-- 5. Corrigir foreign key de estoque_movimentacoes para permitir exclusão de pedidos
-- Remove constraint antiga e cria nova com ON DELETE SET NULL
ALTER TABLE estoque_movimentacoes 
    DROP CONSTRAINT IF EXISTS estoque_movimentacoes_pedido_id_fkey;

ALTER TABLE estoque_movimentacoes 
    ADD CONSTRAINT estoque_movimentacoes_pedido_id_fkey 
    FOREIGN KEY (pedido_id) 
    REFERENCES pedidos(id) 
    ON DELETE SET NULL;

-- 6. (OPCIONAL) Atualizar pedidos existentes que estão em status ENVIADO ou APROVADO
-- Descomente as linhas abaixo se quiser mudar pedidos existentes para RASCUNHO ou outro status

-- UPDATE pedidos SET status = 'RASCUNHO' WHERE status IN ('ENVIADO', 'APROVADO') AND status != 'FINALIZADO';

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
-- IMPORTANTE: Execute este script no SQL Editor do Supabase
-- A função agora permite finalizar pedidos diretamente, sem aprovação
-- SECURITY DEFINER permite que a função execute com privilégios do dono (bypass RLS)
