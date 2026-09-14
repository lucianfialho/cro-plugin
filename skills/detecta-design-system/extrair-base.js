// Parte 1 de 2 — helpers de medição.
// Concatene com extrair-tokens.js antes de rodar:
//   agent-browser eval "$(cat extrair-base.js extrair-tokens.js)"
globalThis.DDS = (() => {
  const px = (v) => {
    const n = parseFloat(v);
    return Number.isFinite(n) ? n : null;
  };

  // rgb()/rgba() -> hex. Alpha 0 vira "transparent" (não é cor de design).
  const toHex = (c) => {
    if (!c) return null;
    const m = c.match(/rgba?\(([^)]+)\)/);
    if (!m) return c;
    const p = m[1].split(/[,\s/]+/).filter(Boolean).map(Number);
    const [r, g, b] = p;
    const a = p.length > 3 ? p[3] : 1;
    if (a === 0) return "transparent";
    const h = (x) => Math.round(x).toString(16).padStart(2, "0");
    return "#" + h(r) + h(g) + h(b) + (a < 1 ? h(a * 255) : "");
  };

  const bump = (map, k) => { if (k) map.set(k, (map.get(k) || 0) + 1); };

  const topN = (map, n) =>
    [...map.entries()]
      .filter(([k]) => k && k !== "null" && k !== "transparent")
      .sort((a, b) => b[1] - a[1])
      .slice(0, n)
      .map(([value, count]) => ({ value, count }));

  const area = (el) => {
    const r = el.getBoundingClientRect();
    return r.width * r.height;
  };

  // Só elementos que ocupam espaço e estão visíveis. display:none já sai daqui.
  const visiveis = () =>
    [...document.querySelectorAll("body *")].filter((el) => {
      const r = el.getBoundingClientRect();
      return r.width > 0 && r.height > 0 && getComputedStyle(el).visibility !== "hidden";
    });

  // Variáveis CSS declaradas pelo próprio site. Folha cross-origin lança — ignora.
  const cssVars = () => {
    const vars = {};
    for (const sheet of document.styleSheets) {
      let rules;
      try { rules = sheet.cssRules; } catch (e) { continue; }
      if (!rules) continue;
      for (const rule of rules) {
        if (!rule.style || !rule.selectorText) continue;
        if (!/^(:root|html|body|\[data-theme|\.theme)/.test(rule.selectorText)) continue;
        for (const prop of rule.style) {
          if (!prop.startsWith("--")) continue;
          const v = rule.style.getPropertyValue(prop).trim();
          if (v && v.length < 80) vars[prop] = v;
        }
      }
    }
    return vars;
  };

  const styleOf = (el) => {
    const s = getComputedStyle(el);
    return {
      backgroundColor: toHex(s.backgroundColor),
      textColor: toHex(s.color),
      borderRadius: s.borderTopLeftRadius,
      padding: `${s.paddingTop} ${s.paddingRight} ${s.paddingBottom} ${s.paddingLeft}`,
      fontFamily: s.fontFamily.split(",")[0].replace(/["']/g, "").trim(),
      fontSize: s.fontSize,
      fontWeight: s.fontWeight,
      letterSpacing: s.letterSpacing,
      textTransform: s.textTransform,
      border: s.borderTopWidth === "0px"
        ? "none"
        : `${s.borderTopWidth} ${s.borderTopStyle} ${toHex(s.borderTopColor)}`,
      boxShadow: s.boxShadow === "none" ? "none" : s.boxShadow,
    };
  };

  // Assinatura dominante: o estilo que mais se repete entre os candidatos.
  // Devolve a contagem junto — é ela que vira o nível de confiança no DESIGN.md.
  const dominant = (nodes) => {
    const sig = new Map();
    for (const el of nodes) {
      const st = styleOf(el);
      const k = JSON.stringify(st);
      const cur = sig.get(k) || { style: st, count: 0, samples: [] };
      cur.count++;
      if (cur.samples.length < 2) {
        cur.samples.push((el.textContent || "").trim().slice(0, 40) || el.tagName.toLowerCase());
      }
      sig.set(k, cur);
    }
    const ranked = [...sig.values()].sort((a, b) => b.count - a.count);
    return ranked.length ? ranked[0] : null;
  };

  const botoes = (els) =>
    els.filter((el) => {
      const t = el.tagName.toLowerCase();
      if (t === "button") return true;
      if (t === "input" && /submit|button/i.test(el.type)) return true;
      if (el.getAttribute("role") === "button") return true;
      if (t === "a" && /btn|button|cta|comprar|adicionar/i.test(el.className + " " + el.id)) return true;
      return false;
    }).filter((el) => {
      const b = toHex(getComputedStyle(el).backgroundColor);
      return b && b !== "transparent" && area(el) > 400;
    });

  const campos = (els) =>
    els.filter((el) =>
      ["input", "textarea", "select"].includes(el.tagName.toLowerCase()) &&
      !/submit|button|hidden|checkbox|radio/i.test(el.type || ""));

  // Card = caixa com moldura (sombra, borda ou fundo+raio), tamanho de card
  // e conteúdo interno — nem átomo solto, nem seção inteira da página.
  const cards = (els) =>
    els.filter((el) => {
      const s = getComputedStyle(el);
      const r = el.getBoundingClientRect();
      const temMoldura = s.boxShadow !== "none" || px(s.borderTopWidth) > 0 ||
        (toHex(s.backgroundColor) !== "transparent" && px(s.borderTopLeftRadius) > 2);
      const filhos = el.querySelectorAll("*").length;
      return temMoldura && r.width > 120 && r.height > 120 && filhos >= 2 && filhos < 60;
    });

  return { px, toHex, bump, topN, area, visiveis, cssVars, styleOf, dominant, botoes, campos, cards };
})();
