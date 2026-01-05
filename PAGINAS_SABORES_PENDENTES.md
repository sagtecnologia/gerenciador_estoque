# 🚨 PÁGINAS COM REFERÊNCIAS A SABORES - CORREÇÃO NECESSÁRIA

## ⚠️ PÁGINAS QUE PRECISAM SER ATUALIZADAS

### 1. **pages/produtos.html** ❌ Tem sabores
- Remover campos de cadastro de sabores
- Remover lista/gerenciamento de sabores
- Simplificar para apenas dados básicos do produto

### 2. **pages/estoque-novo.html** ❌ Tem sabores  
- Remover seleção de sabores
- Trabalhar apenas com produtos diretos

### 3. **pages/vendas.html** ❌ Tem sabores
- Remover seleção de sabores ao adicionar itens
- Mostrar apenas produto e quantidade

### 4. **pages/venda-detalhe.html** ❌ Tem sabores
- Remover exibição de sabores nos itens da venda
- Mostrar apenas produto

### 5. **pages/pedidos.html** ❌ Tem sabores
- Remover seleção de sabores ao adicionar itens
- Simplificar para produto + quantidade

### 6. **pages/pedido-detalhe.html** ❌ Tem sabores
- Remover exibição de sabores nos itens do pedido

### 7. **pages/analise.html** ❌ MUITOS sabores
- ❌ Remover filtro "Sabor"
- ❌ Remover tab "Por Sabor"
- ❌ Remover função `carregarSaboresFiltro()`
- ❌ Remover função `renderPorSabor()`
- ❌ Remover gráfico "Top 10 Sabores"
- Manter apenas: Por Marca, Por Produto, Por Cliente

### 8. **pages/analise-lucros.html** ❌ MUITOS sabores
- ❌ Remover filtro "Sabor"
- ❌ Remover tab "Por Sabor"
- ❌ Remover função `carregarSaboresFiltro()`
- ❌ Remover função `renderPorSabor()`
- Manter apenas: Por Marca, Por Produto, Por Cliente

---

## 🛠️ COMO PROCEDER

### Opção 1: Correção Manual (Recomendado)
Vou criar versões corrigidas das páginas principais. Você escolhe quais atualizar.

### Opção 2: Remover Páginas de Análise
Se as análises detalhadas não são essenciais agora, posso comentar/remover essas páginas temporariamente.

### Opção 3: Manter e Avisar
Deixar as páginas como estão e apenas adicionar avisos de que a funcionalidade de sabores foi descontinuada.

---

## 📊 PRIORIDADE DE CORREÇÃO

### 🔴 CRÍTICO (Sistema não funciona sem):
1. **pages/produtos.html** - Cadastro de produtos
2. **pages/vendas.html** - Registro de vendas
3. **pages/pedidos.html** - Pedidos de compra

### 🟡 IMPORTANTE (Sistema funciona, mas com erros):
4. **pages/venda-detalhe.html**
5. **pages/pedido-detalhe.html**
6. **pages/estoque-novo.html**

### 🟢 BAIXA PRIORIDADE (Pode ter bugs, mas não impedem uso):
7. **pages/analise.html**
8. **pages/analise-lucros.html**

---

## ❓ COMO VOCÊ QUER PROCEDER?

**A)** Corrigir TUDO agora (pode demorar, muitas mudanças)  
**B)** Corrigir apenas as páginas CRÍTICAS (produtos, vendas, pedidos)  
**C)** Corrigir uma página por vez conforme você testar  
**D)** Criar um branch/versão separada simplificada

---

## 💡 SUGESTÃO

Como são muitas mudanças, recomendo:
1. ✅ Commitar o que já fizemos (schema, config, produtos.js)
2. ✅ Testar o sistema básico
3. ✅ Ir corrigindo página por página conforme usar

Isso evita fazer mudanças massivas que podem introduzir bugs.

**O que você prefere?**
