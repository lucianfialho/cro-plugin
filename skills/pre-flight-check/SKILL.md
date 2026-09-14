---
name: pre-flight-check
description: Checklist dos 8 itens a checar antes de apertar Start num teste A/B (hipótese, controle, audiência, QA, métrica e guardrails, variante, eventos, flickering). Use quando o usuário disser "posso subir o teste", "pre-flight", "checklist antes de subir", "QA do teste".
---

# Pre-flight Check — checklist antes de subir o teste

## Tarefa

Rodar o checklist pré-Start e dar veredito. Não existe "quase pronto": ou pode
subir, ou não pode.

## Checklist — os 8 itens da Taciana (slide 41)

Estes 8 são a estrutura de primeiro nível e os nomes são obrigatórios. As
sub-checagens abaixo de cada um são o detalhamento técnico; elas podem ser
encurtadas se o tempo apertar, os 8 itens não.

- [ ] **1. Hipótese escrita e compartilhada**
  - A hipótese está no template completo, com evidência preenchida?
  - Alguém além de quem escreveu leu e concordou?
- [ ] **2. Controle definido e no ar**
  - O controle é a experiência atual, sem mudança nenhuma?
- [ ] **3. Audiência e segmentação corretas**
  - O filtro de audiência é aplicado ANTES da alocação, nunca depois?
  - Tem outro teste ativo na mesma página?
  - Tem campanha, promoção ou sazonalidade no período?
- [ ] **4. QA aprovado em browsers diferentes**
  - Testado em Chrome, Safari e no mobile real, não só no emulador?
  - Se a página é SPA, a variante sobrevive à navegação client-side?
  - O código falha silenciosamente se o elemento sumir?
- [ ] **5. Métrica primária e guardrails definidos**
  - A métrica primária está declarada por escrito ANTES de subir?
  - Existe pelo menos um guardrail (algo que não pode piorar)?
  - Qual o tamanho de amostra necessário para o efeito mínimo que interessa?
  - Quantos dias isso leva no tráfego atual, e cobre um ciclo semanal completo?
  - O critério de parada está escrito antes de começar?
- [ ] **6. Variante validada em mobile e desktop**
  - A mudança faz sentido nos dois, ou o teste deveria ser só de um?
- [ ] **7. Eventos disparando nas duas versões**
  - Evento de impressão dispara uma vez por usuário, não por pageview?
  - O ID do experimento chega no analytics em ambas as variantes?
- [ ] **8. Flickering e performance verificados**
  - A variante renderiza sem flicker (mudança antes do primeiro paint)?
  - A variante não degradou o tempo de carregamento?

## Regras

- Item que o usuário não souber responder conta como **não checado**. "Acho que
  sim" é não.
- Não estime tamanho de amostra sem taxa de conversão base e efeito mínimo.
  Peça os dois. Se não tiver, diga que o teste não tem critério de parada.

## Veredito

    ## Pre-flight
    ✅ Checados: X/8
    ⚠️ Não checados: [lista, pelo nome do item da Taciana]

    ## Veredito
    🟢 PODE SUBIR   ou   🔴 NÃO SUBA — [o item bloqueante]

Os itens **1, 5 e 7** (hipótese escrita, métrica primária e guardrails, eventos
disparando) não checados forçam 🔴 — sem eles o teste não produz leitura. Os
demais não checados geram 🟡 com ressalva explícita.

Feche sempre com a frase dela: **"Só então: START. Um erro de implementação não
aparece no resultado — ele aparece como um resultado que ninguém consegue
explicar."**
