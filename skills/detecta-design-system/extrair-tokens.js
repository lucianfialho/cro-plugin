// Parte 2 de 2 — a medição. Precisa de extrair-base.js carregado antes:
//   agent-browser eval "$(cat extrair-base.js extrair-tokens.js)"
(() => {
  const D = globalThis.DDS;
  if (!D) throw new Error("extrair-base.js não foi carregado — concatene os dois arquivos");

  const out = { url: location.href, title: document.title };

  // ---------- 1. o que o site declara ----------
  out.cssVars = D.cssVars();
  out.cssVarsLidas = Object.keys(out.cssVars).length > 0;

  // ---------- 2. o que o site renderiza ----------
  const els = D.visiveis();
  out.elementosVisiveis = els.length;

  const bg = new Map(), fg = new Map(), fam = new Map(), size = new Map(),
        weight = new Map(), radius = new Map(), pad = new Map(), gap = new Map();
  const bgArea = new Map();   // fundo ponderado por área pintada
  const niveis = new Map();   // assinatura tipográfica completa

  for (const el of els) {
    const s = getComputedStyle(el);

    const b = D.toHex(s.backgroundColor);
    if (b && b !== "transparent") {
      D.bump(bg, b);
      bgArea.set(b, (bgArea.get(b) || 0) + D.area(el));
    }

    // Só conta cor/fonte de nó que tem texto próprio — herança inflaria tudo.
    const temTextoProprio = [...el.childNodes].some((n) => n.nodeType === 3 && n.textContent.trim());
    if (temTextoProprio && (el.textContent || "").trim().length > 1) {
      const familia = s.fontFamily.split(",")[0].replace(/["']/g, "").trim();
      D.bump(fg, D.toHex(s.color));
      D.bump(fam, familia);
      D.bump(size, s.fontSize);
      D.bump(weight, s.fontWeight);
      D.bump(niveis, [familia, s.fontSize, s.fontWeight, s.lineHeight, s.letterSpacing].join("|"));
    }

    for (const r of [s.borderTopLeftRadius, s.borderTopRightRadius]) {
      const n = D.px(r);
      if (n && n > 0) D.bump(radius, n >= 500 ? "9999px" : Math.round(n) + "px");
    }
    for (const p of [s.paddingTop, s.paddingBottom, s.paddingLeft, s.paddingRight]) {
      const n = D.px(p);
      if (n && n > 0 && n <= 160) D.bump(pad, Math.round(n) + "px");
    }
    const g = D.px(s.gap);
    if (g && g > 0 && g <= 160) D.bump(gap, Math.round(g) + "px");
  }

  out.cores = {
    fundo: D.topN(bg, 10),
    fundoPorArea: [...bgArea.entries()]
      .filter(([k]) => k !== "transparent")
      .sort((a, b) => b[1] - a[1])
      .slice(0, 8)
      .map(([value, a]) => ({ value, areaPx2: Math.round(a) })),
    texto: D.topN(fg, 8),
  };

  out.tipografia = {
    familias: D.topN(fam, 6),
    tamanhos: D.topN(size, 12),
    pesos: D.topN(weight, 6),
    niveis: D.topN(niveis, 14).map(({ value, count }) => {
      const [fontFamily, fontSize, fontWeight, lineHeight, letterSpacing] = value.split("|");
      return { fontFamily, fontSize, fontWeight, lineHeight, letterSpacing, count };
    }),
  };

  out.rounded = D.topN(radius, 8);
  out.spacing = { padding: D.topN(pad, 12), gap: D.topN(gap, 8) };

  // ---------- 3. componentes recorrentes ----------
  const botoes = D.botoes(els), campos = D.campos(els), cards = D.cards(els);
  out.componentes = {
    "button-primary": { candidatos: botoes.length, dominante: D.dominant(botoes) },
    "input": { candidatos: campos.length, dominante: D.dominant(campos) },
    "card": { candidatos: cards.length, dominante: D.dominant(cards) },
  };

  // ---------- 4. a página ----------
  const body = getComputedStyle(document.body);
  out.pagina = {
    backgroundColor: D.toHex(body.backgroundColor),
    color: D.toHex(body.color),
    fontFamily: body.fontFamily,
    fontSize: body.fontSize,
    viewport: innerWidth + "x" + innerHeight,
  };
  out.fontes = [...document.querySelectorAll('link[rel="stylesheet"], link[rel="preconnect"]')]
    .map((l) => l.href)
    .filter((h) => /font/i.test(h))
    .slice(0, 8);

  return out;
})()
