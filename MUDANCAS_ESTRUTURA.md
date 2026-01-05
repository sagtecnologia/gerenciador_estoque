# 🔄 Mudanças na Estrutura do Sistema

## Data: Janeiro 2026

## ⚠️ IMPORTANTE: Remoção do Sistema de Sabores

Este projeto foi **simplificado** e **não possui mais** o sistema de sabores/variações de produtos. 

### O que foi removido:

#### 1. **Banco de Dados**
- ❌ Tabela `produto_sabores` (completamente removida)
- ❌ Campo `sabor_id` na tabela `pedido_itens`
- ❌ Campo `sabor_id` na tabela `estoque_movimentacoes`
- ❌ Campo `marca` na tabela `produtos` (consolidado em `categoria`)
- ❌ Triggers e funções relacionadas a sabores

#### 2. **JavaScript / Services**
- ❌ Função `getSaboresProduto()`
- ❌ Função `createProdutoComSabores()`
- ❌ Função `updateProdutoComSabores()`
- ❌ Função `getMarcas()`
- ❌ Função `getProdutosPorMarca()`

#### 3. **Arquivos que devem ser ignorados**
- `database/migration-produto-sabores.sql` - NÃO EXECUTAR
- `database/dados-pods-descartaveis.sql` - NÃO EXECUTAR (contém sabores)
- `CORRECAO_ESTOQUE_SABORES.md` - Documentação obsoleta

---

## ✅ Nova Estrutura Simplificada

### Tabela de Produtos (Atualizada)

```sql
CREATE TABLE produtos (
    id UUID PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(100),
    unidade VARCHAR(20) NOT NULL,
    estoque_atual DECIMAL(10,2) DEFAULT 0,
    estoque_minimo DECIMAL(10,2) DEFAULT 0,
    preco_compra DECIMAL(10,2) DEFAULT 0,
    preco_venda DECIMAL(10,2) DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

### Fluxo de Trabalho Atual

1. **Cadastro de Produtos**: Apenas dados básicos (código, nome, categoria, preços)
2. **Controle de Estoque**: Direto na tabela `produtos.estoque_atual`
3. **Pedidos/Vendas**: Item aponta direto para `produtos` (sem sabor)
4. **Movimentações**: Entrada/Saída direto no estoque do produto

---

## 📋 Como Migrar do Sistema Antigo

Se você tinha um sistema com sabores anteriormente:

### Opção 1: Consolidar Sabores em Produtos Separados
```sql
-- Transformar cada sabor em um produto individual
INSERT INTO produtos (codigo, nome, categoria, ...)
SELECT 
    CONCAT(p.codigo, '-', ps.sabor),
    CONCAT(p.nome, ' - ', ps.sabor),
    p.categoria,
    ...
FROM produtos p
JOIN produto_sabores ps ON p.id = ps.produto_id;
```

### Opção 2: Somar Estoques dos Sabores
```sql
-- Consolidar todos os sabores no estoque do produto principal
UPDATE produtos p
SET estoque_atual = (
    SELECT COALESCE(SUM(quantidade), 0)
    FROM produto_sabores ps
    WHERE ps.produto_id = p.id
);
```

---

## 🚀 Próximos Passos

1. Execute o novo `database/schema.sql` em um banco de dados limpo
2. Use as funções simplificadas: `createProduto()` e `updateProduto()`
3. Ignore todos os arquivos/documentos que mencionam "sabores"
4. As páginas HTML que referenciam sabores precisarão ser atualizadas (em breve)

---

## 📞 Suporte

Para dúvidas sobre a nova estrutura, consulte:
- [README.md](README.md) - Visão geral do sistema
- [database/schema.sql](database/schema.sql) - Estrutura completa do banco
- [DOCUMENTACAO_TECNICA.md](DOCUMENTACAO_TECNICA.md) - Detalhes técnicos

