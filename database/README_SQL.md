# 📁 Guia de Arquivos SQL do Projeto

## ✅ EXECUTAR (Necessários para o sistema funcionar)

### 1. **schema.sql** - BASE PRINCIPAL ✓
**STATUS**: ✅ Já contém tudo que precisa  
Execute primeiro. Contém:
- Todas as tabelas básicas (users, produtos, fornecedores, clientes, pedidos, etc)
- Funções principais (processar_movimentacao_estoque, finalizar_pedido)
- RLS policies completas
- Triggers e views

### 2. **empresa-config.sql** - CONFIGURAÇÕES DA EMPRESA
**STATUS**: ⚠️ RECOMENDADO - Adicionar ao schema ou executar separado  
Adiciona:
- Tabela `empresa_config` para dados da empresa
- Logo, endereço, contatos da empresa
- **NECESSÁRIO** para a página de configurações funcionar

### 3. **EXECUTAR_adicionar-pagamentos-parciais.sql** - SISTEMA DE PAGAMENTOS
**STATUS**: ⚠️ RECOMENDADO - Executar após schema  
Adiciona:
- Colunas: `pagamento_status`, `valor_pago`, `valor_pendente`
- Tabela `pagamentos` (histórico de pagamentos)
- **NECESSÁRIO** se usar o sistema de pagamentos parciais

### 4. **EXECUTAR_add-status-cancelado.sql** - STATUS CANCELADO
**STATUS**: ⚠️ RECOMENDADO - Executar após schema  
Adiciona:
- Status 'CANCELADO' aos pedidos
- Permite cancelar vendas/pedidos

### 5. **EXECUTAR_adicionar-whatsapp-api.sql** - INTEGRAÇÃO WHATSAPP
**STATUS**: 🔵 OPCIONAL - Só se usar WhatsApp  
Adiciona colunas em `empresa_config`:
- `whatsapp_api_provider`, `whatsapp_api_url`, `whatsapp_api_key`
- Necessário para notificações automáticas via WhatsApp

---

## ❌ NÃO EXECUTAR (Obsoletos ou relacionados a sabores)

### ❌ migration-produto-sabores.sql
**Motivo**: Sistema de sabores foi REMOVIDO

### ❌ EXECUTAR_criar-funcao-estoque-sabor.sql
**Motivo**: Funções de sabores não existem mais

### ❌ migration-fix-estoque-sabores.sql
**Motivo**: Correções de sabores desnecessárias

### ❌ dados-pods-descartaveis.sql
**Motivo**: Dados de exemplo com sabores

### ❌ debug-estoque-sabores.sql
**Motivo**: Debug de sabores

---

## 🔧 UTILITÁRIOS (Usar conforme necessário)

### limpar-base.sql
Limpa todos os dados mas mantém estrutura

### limpar-tudo.sql
Remove TUDO (estrutura + dados)

### reset-complete.sql
Reset completo do banco

---

## 📋 ORDEM DE EXECUÇÃO RECOMENDADA

```sql
1. schema.sql                                    -- BASE (OBRIGATÓRIO)
2. empresa-config.sql                            -- Configurações empresa
3. EXECUTAR_adicionar-pagamentos-parciais.sql   -- Sistema pagamentos
4. EXECUTAR_add-status-cancelado.sql            -- Status cancelado
5. EXECUTAR_adicionar-whatsapp-api.sql          -- WhatsApp (opcional)
```

---

## 🚨 IMPORTANTE

O arquivo **schema.sql** atual já está **atualizado e simplificado**:
- ✅ SEM sistema de sabores
- ✅ Tabela `clientes` incluída
- ✅ Campo `tipo_pedido` (COMPRA/VENDA) incluído
- ✅ Funções de estoque simplificadas

Arquivos de **migration** e **fix** são para bancos que já existiam. Para banco novo, use apenas os arquivos da seção "EXECUTAR".

---

## 📞 Dúvidas?

- Para adicionar novos recursos: crie novo arquivo SQL
- Para corrigir erros: use arquivos `fix-*`
- Para dados de teste: crie arquivo separado `dados-teste.sql`
