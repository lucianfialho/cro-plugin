---
name: variante-builder
description: Transforma uma hipótese de CRO fechada no código da variante B (JS/CSS) mais a lista de eventos a instrumentar. Cobre as etapas Construir, Configurar e Instrumentar do fluxo de experimentação. Use quando o usuário disser "código da variante", "implementar o teste", "criar variante B".
---

# Variante Builder — código da variante B a partir da hipótese

## Pré-condição

A hipótese precisa estar fechada (com evidência). Se vier com
`⚠️ FALTA EVIDÊNCIA`, avise: "Dá para escrever o código, mas você vai gastar
sprint testando opinião." Pergunte se quer seguir mesmo assim.

## Passo 1 — extrair a mudança

Da hipótese, isole: o **elemento** que muda, a **página** onde muda e o
**segmento** que deve ver a variante.

## Passo 2 — gerar `variante-b.js`

Escreva um arquivo `variante-b.js` no diretório atual. Regras não negociáveis:

- **Anti-flicker:** a mudança acontece antes do primeiro paint, ou a variante
  aparece piscando e contamina o resultado.
- **Idempotente:** rodar duas vezes não duplica elemento.
- **Guard de escopo:** só executa se a URL casar com a página do teste.
- **Falha silenciosa:** se o elemento alvo não existir, sair sem quebrar a
  página — nunca deixe o teste derrubar o site.

Esqueleto:

    (function () {
      if (!/\/checkout/.test(location.pathname)) return;
      var alvo = document.querySelector('[data-test="cep-field"]');
      if (!alvo || alvo.dataset.variantApplied) return;
      alvo.dataset.variantApplied = '1';
      // ... a mudança
      window.dataLayer = window.dataLayer || [];
      window.dataLayer.push({ event: 'experiment_impression',
                              experiment_id: '<id>', variant: 'variant_b' });
    })();

## Passo 3 — gerar `eventos.md`

Liste os eventos necessários para ler o teste, com nome, quando dispara e qual
pergunta cada um responde:

| Evento | Dispara quando | Responde |
|---|---|---|
| `experiment_impression` | variante aplicada | quantos viram de fato |
| `<evento de micro-conversão>` | ... | onde o funil melhorou |
| `<evento de conversão>` | ... | a métrica primária |

Diga qual é a **métrica primária** e por que as outras são secundárias.

## Aviso final obrigatório

> Este código não foi testado no seu site. Rode `pre-flight-check` antes de
> subir. Um erro de implementação não aparece no resultado — ele aparece como
> um resultado que ninguém consegue explicar.
