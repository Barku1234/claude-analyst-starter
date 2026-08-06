---
name: html-deck-templates
description: Templates de presentación en HTML self-contained (16:9), exportables a PDF/PPTX. Cover, agenda, section dividers, content slides, charts, football field, tabla comps, cierre. Cargar cuando el usuario pida /pitch-deck, /teaser (visual), /cim (visual), o cualquier deck.
---

# HTML Deck Templates

Todo deck se genera como **un solo archivo `.html` self-contained** (CSS + JS inline, sin dependencias externas — CSP-friendly). Se abre en Chrome, se imprime a PDF o se convierte a PPTX con `pptx` skill.

Chain de trabajo:
1. Preguntá al usuario: audiencia, propósito, longitud, tone.
2. Generá HTML con este template.
3. Guardá en `decks/[nombre]_[YYYYMMDD].html`.
4. Abrí con `start decks/[nombre].html` (Windows) o `open` (Mac) para preview.
5. Si el usuario quiere PPTX editable, usá skill `pptx` para convertir.

## Base HTML

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>[Deck Title] — [Client]</title>
<style>
:root {
  --primary: #1F4E78;      /* deep navy (change to bank's brand) */
  --accent: #C00000;       /* deep red for highlights */
  --text: #212121;
  --muted: #6E6E6E;
  --bg: #FFFFFF;
  --grid: #E5E5E5;
}
* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Calibri', 'Segoe UI', sans-serif; color: var(--text); background: #f0f0f0; }

.slide {
  width: 1280px; height: 720px;
  background: var(--bg);
  margin: 20px auto;
  padding: 60px 80px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  position: relative;
  page-break-after: always;
  display: flex;
  flex-direction: column;
}

.slide-header {
  border-bottom: 3px solid var(--primary);
  padding-bottom: 12px;
  margin-bottom: 24px;
}
.slide-title { font-size: 28px; font-weight: 700; color: var(--primary); }
.slide-subtitle { font-size: 14px; color: var(--muted); margin-top: 4px; }

.slide-footer {
  position: absolute;
  bottom: 24px;
  left: 80px;
  right: 80px;
  font-size: 10px;
  color: var(--muted);
  display: flex;
  justify-content: space-between;
  border-top: 1px solid var(--grid);
  padding-top: 8px;
}

/* Cover */
.cover { justify-content: center; align-items: flex-start; }
.cover h1 { font-size: 48px; color: var(--primary); font-weight: 700; margin-bottom: 16px; line-height: 1.15; }
.cover .subtitle { font-size: 22px; color: var(--text); margin-bottom: 32px; }
.cover .meta { font-size: 14px; color: var(--muted); margin-top: auto; }

/* Content */
.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 32px; flex: 1; }
.three-col { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 24px; flex: 1; }
.stat-tile { border: 1px solid var(--grid); border-radius: 8px; padding: 20px; }
.stat-tile .value { font-size: 36px; font-weight: 700; color: var(--primary); }
.stat-tile .label { font-size: 12px; color: var(--muted); text-transform: uppercase; margin-top: 4px; }

.bullet-list { list-style: none; padding: 0; }
.bullet-list li { padding: 8px 0 8px 24px; position: relative; font-size: 14px; line-height: 1.5; }
.bullet-list li::before { content: '▸'; color: var(--accent); position: absolute; left: 0; font-weight: bold; }

table { width: 100%; border-collapse: collapse; font-size: 12px; }
th { background: var(--primary); color: white; padding: 8px; text-align: left; font-weight: 600; }
td { padding: 6px 8px; border-bottom: 1px solid var(--grid); }
tr:hover td { background: #F9F9F9; }
tr.total td { border-top: 2px solid var(--primary); font-weight: 700; }

/* Section divider */
.divider { justify-content: center; align-items: center; background: var(--primary); color: white; }
.divider .num { font-size: 96px; font-weight: 300; opacity: 0.3; }
.divider .title { font-size: 40px; font-weight: 700; }

/* Print */
@media print {
  body { background: white; }
  .slide { margin: 0; box-shadow: none; page-break-after: always; }
}
</style>
</head>
<body>

<!-- Cover slide -->
<section class="slide cover">
  <div style="width: 60px; height: 4px; background: var(--accent); margin-bottom: 16px;"></div>
  <h1>[Project Title]</h1>
  <div class="subtitle">[Subtitle — audience-appropriate description]</div>
  <div class="meta">
    <div>[Client Name]</div>
    <div>[Date, e.g. August 2026]</div>
    <div>Strictly Confidential</div>
  </div>
</section>

<!-- Agenda -->
<section class="slide">
  <div class="slide-header">
    <div class="slide-title">Agenda</div>
  </div>
  <ol style="font-size: 20px; padding-left: 32px; line-height: 2;">
    <li>Executive Summary</li>
    <li>Market Context</li>
    <li>Company Overview</li>
    <li>Financial Analysis</li>
    <li>Valuation</li>
    <li>Recommendation</li>
    <li>Appendix</li>
  </ol>
  <div class="slide-footer">
    <span>Strictly Confidential | [Banco]</span>
    <span>2</span>
  </div>
</section>

<!-- Section divider -->
<section class="slide divider">
  <div class="num">01</div>
  <div class="title">Executive Summary</div>
</section>

<!-- Content slide with bullets -->
<section class="slide">
  <div class="slide-header">
    <div class="slide-title">Key Investment Highlights</div>
    <div class="slide-subtitle">Five pillars support the investment thesis</div>
  </div>
  <div class="two-col" style="flex: 1;">
    <div>
      <ul class="bullet-list">
        <li><strong>Market Leader</strong> — #1 position in [category] with 35% share</li>
        <li><strong>Structural Growth</strong> — TAM expanding at 12% CAGR through 2030</li>
        <li><strong>Margin Expansion</strong> — 300bps EBITDA margin uplift by 2028</li>
        <li><strong>Cash Generative</strong> — 65% FCF conversion, self-funding growth</li>
        <li><strong>Optionality</strong> — Adjacencies represent $500M revenue opportunity</li>
      </ul>
    </div>
    <div class="three-col" style="grid-template-columns: 1fr; align-content: start;">
      <div class="stat-tile">
        <div class="value">$1.2Bn</div>
        <div class="label">Revenue LTM</div>
      </div>
      <div class="stat-tile">
        <div class="value">28%</div>
        <div class="label">EBITDA Margin</div>
      </div>
      <div class="stat-tile">
        <div class="value">18%</div>
        <div class="label">Revenue CAGR '23-'25</div>
      </div>
    </div>
  </div>
  <div class="slide-footer">
    <span>Strictly Confidential | [Banco]</span>
    <span>4</span>
  </div>
</section>

<!-- Table slide (comps example) -->
<section class="slide">
  <div class="slide-header">
    <div class="slide-title">Trading Comparables</div>
    <div class="slide-subtitle">Selected peers — median EV/EBITDA of 13.5x supports valuation range</div>
  </div>
  <table>
    <thead>
      <tr>
        <th>Company</th>
        <th>Ticker</th>
        <th>Mkt Cap ($M)</th>
        <th>EV ($M)</th>
        <th>Rev '26E ($M)</th>
        <th>EBITDA '26E ($M)</th>
        <th>EV / Rev</th>
        <th>EV / EBITDA</th>
      </tr>
    </thead>
    <tbody>
      <tr><td>Peer A</td><td>PEER-A</td><td>5,200</td><td>5,800</td><td>1,100</td><td>320</td><td>5.3x</td><td>18.1x</td></tr>
      <tr><td>Peer B</td><td>PEER-B</td><td>3,400</td><td>3,900</td><td>780</td><td>230</td><td>5.0x</td><td>17.0x</td></tr>
      <tr><td>Peer C</td><td>PEER-C</td><td>2,100</td><td>2,300</td><td>520</td><td>140</td><td>4.4x</td><td>16.4x</td></tr>
      <tr class="total"><td colspan="6">Median</td><td>5.0x</td><td>17.0x</td></tr>
      <tr class="total"><td colspan="6">Mean</td><td>4.9x</td><td>17.2x</td></tr>
    </tbody>
  </table>
  <div style="margin-top: 16px; font-size: 10px; color: var(--muted);">
    Source: Capital IQ, as of [DD-MMM-YYYY]. Team analysis.
  </div>
  <div class="slide-footer">
    <span>Strictly Confidential | [Banco]</span>
    <span>12</span>
  </div>
</section>

</body>
</html>
```

## Slide types disponibles

1. **Cover** (`class="slide cover"`)
2. **Agenda** — lista numerada
3. **Section divider** (`class="slide divider"`) — con número grande
4. **Content — bullets + stat tiles** (`.two-col` con `.bullet-list` + `.stat-tile`s)
5. **Content — table** (comps, precedent transactions)
6. **Chart** — usar Chart.js inline si dinamismo requerido; SVG estático si es print (mejor calidad print)
7. **Football field** — barras horizontales con rangos, dot para target
8. **Team slide** — grid de mgmt bios
9. **Closing / thank you** — cover invertida

## Reglas de diseño

- **1 slide = 1 idea**. Si tenés 2 conclusiones, son 2 slides.
- **Título con conclusión** (`Revenue grew 23% CAGR '23-'25`), no descripción (`Revenue trend`).
- **≤ 6 bullets por slide**. Si necesitás más, dividí.
- **≤ 20 words por bullet**. Si necesitás más, es prosa — considerá appendix o cortá.
- **Colors**: primario del banco (leé `memory/user_role.md`), accent para highlights, gris para muted. NO usar más de 3 colores por deck.
- **Charts**: 1 chart por slide, con conclusión en el título del chart.
- **Fuentes en cada tabla/chart**, footer en cada slide.

## Export a PPTX

Si el usuario necesita PPTX editable (para editar en el banco), usá skill `pptx`:
- Convertir cada `<section class="slide">` a slide de PPTX
- Preservar layout, colores, fuentes
- Charts van como imagen embed (o Chart nativo si es tabular)

## Print a PDF

Chrome: `Ctrl+P` → destination `Save as PDF` → margins `None` → scale `100%` → paper size `A4 Landscape` o `Letter Landscape` → save.

O programáticamente con headless Chrome:
```bash
"C:\Program Files\Google\Chrome\Application\chrome.exe" --headless --disable-gpu --print-to-pdf="decks/output.pdf" --print-to-pdf-no-header decks/input.html
```
