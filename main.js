(() => {
  const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* --- goteo: se genera según el ancho --- */
  let seed = 7;
  const rnd = () => (seed = (seed * 16807) % 2147483647) / 2147483647;
  function drips() {
    document.querySelectorAll('.drips').forEach((el, k) => {
      seed = 11 + k * 97;
      const W = el.offsetWidth; let x = 20 + rnd() * 60, html = '<div><b></b>', drops = '';
      while (x < W - 20) {
        const w = 12 + rnd() * 22 | 0, h = 26 + Math.pow(rnd(), 2.2) * 110 | 0;
        if (h > 70 && rnd() > .45) drops += `<i style="left:${x | 0}px;top:${h}px;--w:${w}px;--gd:${(2.5 + rnd() * 6).toFixed(1)}s"></i>`;
        html += `<span style="left:${x | 0}px;--w:${w}px;--h:${h}px;--d:${(rnd() * .7).toFixed(2)}s"></span>`;
        x += w + 26 + rnd() * 130;
      }
      el.innerHTML = html + '</div>' + drops;
    });
  }
  drips();
  let rw = innerWidth, rt;
  addEventListener('resize', () => { if (innerWidth === rw) return; rw = innerWidth; clearTimeout(rt); rt = setTimeout(() => { drips(); buildNeedle(); }, 200); });

  /* --- aparecer al entrar --- */
  const io = new IntersectionObserver(es => es.forEach(e => { if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); } }), { threshold: .14, rootMargin: '0px 0px -6% 0px' });
  document.querySelectorAll('.rv,.drips').forEach(el => io.observe(el));
  // las gotas solo caen mientras su goteo está en pantalla
  const live = new IntersectionObserver(es => es.forEach(e => e.target.classList.toggle('live', e.isIntersecting)));
  document.querySelectorAll('.drips').forEach(el => live.observe(el));

  /* --- hero: líneas de tinta como las del logotipo --- */
  const cv = document.getElementById('olas'), cx = cv.getContext('2d');
  let cw, ch, dpr, mx = -9999, my = -9999, vis = true, t0 = -100;
  function size() { dpr = Math.min(devicePixelRatio || 1, 2); cw = cv.clientWidth; ch = cv.clientHeight; cv.width = cw * dpr; cv.height = ch * dpr; }
  function draw(ms) {
    if (vis && !reduce) requestAnimationFrame(draw);
    if (ms - t0 < 32) return; t0 = ms;   // ~30 fps: el movimiento es lento
    const t = ms / 1000;
    cx.setTransform(dpr, 0, 0, dpr, 0, 0); cx.clearRect(0, 0, cw, ch);
    const N = cw < 700 ? 9 : 13, step = cw < 700 ? 14 : 10;
    for (let i = 0; i < N; i++) {
      const p = i / (N - 1);
      cx.beginPath();
      for (let x = -20; x <= cw + 20; x += step) {
        const u = x / cw;
        // curva en S que cruza de arriba-derecha a abajo-izquierda, como el icono
        let y = ch * (.08 + p * .5) + Math.sin(u * 5.2 - t * .35 + p * 1.7) * ch * .11 + Math.sin(u * 2.1 + t * .22 + p * 3) * ch * .09 + (u - .5) * -ch * .5;
        const dx = x - mx, dy = y - my, d2 = dx * dx + dy * dy;
        y += (dy < 0 ? -1 : 1) * 46 * Math.exp(-d2 / 26000);
        x === -20 ? cx.moveTo(x, y) : cx.lineTo(x, y);
      }
      cx.lineWidth = 1 + (1 - Math.abs(p - .5) * 2) * (cw < 700 ? 7 : 13);
      cx.strokeStyle = `rgba(255,255,255,${.05 + (1 - Math.abs(p - .5) * 2) * .09})`;
      cx.stroke();
    }
  }
  size(); requestAnimationFrame(draw);
  addEventListener('resize', () => { size(); if (reduce) { t0 = -100; draw(performance.now()); } });
  cv.parentElement.addEventListener('pointermove', e => { const r = cv.getBoundingClientRect(); mx = e.clientX - r.left; my = e.clientY - r.top; });
  cv.parentElement.addEventListener('pointerleave', () => { mx = my = -9999; });
  new IntersectionObserver(([e]) => { const was = vis; vis = e.isIntersecting; if (vis && !was && !reduce) requestAnimationFrame(draw); }).observe(cv);

  /* --- proceso: la línea se tatúa al hacer scroll --- */
  const steps = document.getElementById('steps'), svg = steps && steps.querySelector('.needle');
  const ghost = svg && svg.querySelector('.ghost'), line = svg && svg.querySelector('.line'), tip = svg && svg.querySelector('circle');
  let len = 0;
  function buildNeedle() {
    if (!svg) return;
    const w = svg.clientWidth, h = steps.offsetHeight, mid = w * .42, amp = w * .3;
    let d = `M${mid} 0`;
    const seg = 150, n = Math.max(2, Math.round(h / seg)), sh = h / n;
    for (let i = 0; i < n; i++) { const s = i % 2 ? -1 : 1, y = i * sh; d += ` C${mid + amp * s} ${y + sh * .3} ${mid + amp * s} ${y + sh * .7} ${mid} ${y + sh}`; }
    svg.setAttribute('viewBox', `0 0 ${w} ${h}`);
    ghost.setAttribute('d', d); line.setAttribute('d', d);
    len = line.getTotalLength(); line.style.strokeDasharray = len; needle();
  }
  function needle() {
    if (!len) return;
    const r = steps.getBoundingClientRect();
    const p = reduce ? 1 : Math.min(1, Math.max(0, (innerHeight * .62 - r.top) / r.height));
    line.style.strokeDashoffset = len * (1 - p);
    const pt = line.getPointAtLength(len * p); tip.setAttribute('cx', pt.x); tip.setAttribute('cy', pt.y);
  }
  buildNeedle();
  addEventListener('scroll', needle, { passive: true });
  addEventListener('load', buildNeedle);
  if (document.fonts) document.fonts.ready.then(buildNeedle);

  /* --- abierto / cerrado (hora de Blanes) --- */
  const H = { 0: [11, 17], 1: [10, 22], 2: [10, 22], 3: [10, 22], 4: [10, 22], 5: [10, 22], 6: [10, 22] };
  const dias = ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'];
  try {
    const parts = new Intl.DateTimeFormat('en-GB', { timeZone: 'Europe/Madrid', weekday: 'short', hour: '2-digit', minute: '2-digit', hour12: false }).formatToParts(new Date());
    const get = k => parts.find(p => p.type === k).value;
    const d = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].indexOf(get('weekday'));
    const now = (+get('hour') % 24) + +get('minute') / 60;
    const el = document.getElementById('estado'), tx = el.querySelector('span');
    const row = document.querySelector(`#horario tr[data-d="${d}"]`); if (row) row.classList.add('hoy');
    const [a, b] = H[d];
    if (now >= a && now < b) { el.classList.add('abierto'); tx.textContent = `Abierto ahora · hasta las ${b}:00`; }
    else {
      el.classList.add('cerrado');
      const nd = now < a ? d : (d + 1) % 7;
      tx.textContent = `Cerrado · abrimos ${now < a ? 'hoy' : 'el ' + dias[nd]} a las ${H[nd][0]}:00`;
    }
  } catch (e) {}

  /* --- formulario → WhatsApp --- */
  const idea = document.getElementById('idea');
  if (idea) idea.addEventListener('submit', e => {
    e.preventDefault();
    const f = new FormData(e.target), l = ['Hola Ink Blanes, quiero pedir cita para un tatuaje.'];
    if (f.get('estilo')) l.push('Estilo: ' + f.get('estilo'));
    if (f.get('tam')) l.push('Tamaño: ' + f.get('tam'));
    const t = (f.get('txt') || '').trim(); if (t) l.push('Idea: ' + t);
    window.open('https://wa.me/34656198570?text=' + encodeURIComponent(l.join('\n')), '_blank', 'noopener');
  });

  /* --- subpáginas: ampliar foto --- */
  const lb = document.getElementById('lupa');
  if (lb && lb.showModal) {
    const links = [...document.querySelectorAll('.galeria a')], im = lb.querySelector('img'), cap = lb.querySelector('p');
    let cur = 0;
    const show = i => { cur = (i + links.length) % links.length; const a = links[cur]; im.src = a.getAttribute('href'); im.alt = a.querySelector('img').alt; cap.textContent = `${a.dataset.cap} · ${cur + 1}/${links.length}`; };
    links.forEach((a, i) => a.addEventListener('click', e => { e.preventDefault(); show(i); lb.showModal(); }));
    lb.querySelector('.x').addEventListener('click', () => lb.close());
    lb.querySelector('.prev').addEventListener('click', () => show(cur - 1));
    lb.querySelector('.next').addEventListener('click', () => show(cur + 1));
    lb.addEventListener('click', e => { if (e.target === lb) lb.close(); });
    lb.addEventListener('keydown', e => { if (e.key === 'ArrowLeft') show(cur - 1); if (e.key === 'ArrowRight') show(cur + 1); });
  }
})();
