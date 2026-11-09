#!/bin/bash
# Genera las 5 subpáginas de estilo. Uso: bash gen.sh "<carpeta del proyecto>"
set -e
cd "$1"
SPRITE=$(sed -n '/<svg width="0"/,/^<\/svg>/p' index.html)

SLUGS=(fine-line black-and-grey neotradicional realismo minitattoos)
TITLES=("Fine line" "Black &amp; grey" "Neotradicional" "Realismo" "Minitattoos")

WAVE='M0 44C50 4 90 4 140 36s90 30 130-2 80-26 130 2 90 30 160-6'

foto(){ # archivo, pie, alt
  echo "      <a class=\"rv\" href=\"img/$1.jpg\" data-cap=\"$2\"><img src=\"img/$1.jpg\" alt=\"$3\" loading=\"lazy\"><span>$2</span></a>"
}

page(){
  local i=$1 slug=${SLUGS[$1]} title=${TITLES[$1]} n="0$(( $1 + 1 ))"
  local others=""
  for j in 0 1 2 3 4; do
    [ $j -eq $i ] && continue
    others+="      <a class=\"card rv\" href=\"${SLUGS[$j]}.html\"><span class=\"n mono\">0$((j+1))</span><h3>${TITLES[$j]}</h3><span class=\"go mono\">Ver fotos</span></a>
"
  done
  cat > "$slug.html" <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${title} en Blanes · Ink Blanes Tattoo Shop</title>
<meta name="description" content="${META}">
<meta property="og:title" content="${title} · Ink Blanes Tattoo Shop">
<meta property="og:description" content="${META}">
<meta property="og:image" content="img/${OG}.jpg">
<meta name="theme-color" content="#0a0a0a">
<link rel="icon" href="img/favicon.png">
<link rel="apple-touch-icon" href="img/favicon.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;700;800;900&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="estilo.css">
</head>
<body>

${SPRITE}

<header class="top">
  <div class="wrap">
    <a class="logo" href="index.html" aria-label="Ink Blanes Tattoo Shop, inicio"><img src="img/logo-blanco.png" alt="Ink Blanes Tattoo Shop" width="1690" height="422"></a>
    <nav class="nav" aria-label="Secciones">
      <a href="index.html#estilos">Estilos</a><a href="index.html#trabajos">Trabajos</a><a href="index.html#artistas">Artistas</a><a href="index.html#estudio">Estudio</a><a href="index.html#visita">Visítanos</a>
    </nav>
    <span class="dark"><a class="btn btn--sm" href="index.html#cita"><span>Pide cita</span></a></span>
  </div>
</header>

<main>
<section class="hero sub dark">
  <canvas id="olas" aria-hidden="true"></canvas>
  <div class="wrap">
    <a class="volver mono" href="index.html#estilos">← Todos los estilos</a>
    <span class="num mono">Estilo ${n} / 05</span>
    <h1 class="h2 in">${title}</h1>
    ${SVG}
    <p class="lead">${LEAD}</p>
    <div class="btns">
      <a class="btn" href="https://wa.me/34656198570?text=${WA}" target="_blank" rel="noopener"><svg><use href="#i-wa"/></svg><span>Quiero uno así</span></a>
      <a class="btn btn--ink" href="#fotos"><span>Ver fotos</span></a>
    </div>
  </div>
</section>

<section class="light">
  <div class="drips"></div>
  <div class="wrap ficha">
    <div class="txt rv">
      <p class="kicker mono">Cómo es</p>
      <h2 class="h2">${H2}</h2>
      <p class="lead">${P1}</p>
      <p class="lead">${P2}</p>
    </div>
    <aside class="caja rv" style="--rd:.12s">
      <h3>Ideal para</h3>
      <ul>
${IDEAL}
      </ul>
      <p class="quien"><span class="mono">Lo tatúa</span><br>${QUIEN}</p>
    </aside>
  </div>
</section>

<section class="dark" id="fotos">
  <div class="drips"></div>
  <div class="wrap">
    <div class="head rv">
      <p class="kicker mono">Fotos</p>
      <h2 class="h2">${title} en piel</h2>
      <p class="lead">Toca cualquier foto para verla en grande y a color.</p>
    </div>
    <div class="galeria">
${FOTOS}
    </div>
    <p class="pocas rv">Los trabajos más recientes, en vídeo, están en <a href="https://www.instagram.com/inkblanestattooshop/" target="_blank" rel="noopener">@inkblanestattooshop</a>.</p>
  </div>
</section>

<section class="light">
  <div class="drips"></div>
  <div class="wrap">
    <div class="head rv">
      <p class="kicker mono">Otros estilos</p>
      <h2 class="h2">Sigue mirando</h2>
    </div>
    <div class="otros">
${others}    </div>
    <div class="cierre rv">
      <a class="btn btn--ink" href="https://wa.me/34656198570?text=${WA}" target="_blank" rel="noopener"><svg><use href="#i-wa"/></svg><span>Pide cita por WhatsApp</span></a>
      <a class="btn" href="index.html#visita"><svg><use href="#i-pin"/></svg><span>Dónde estamos</span></a>
    </div>
  </div>
</section>
</main>

<footer class="end dark">
  <div class="wrap">
    <a href="index.html"><img src="img/logo-blanco.png" alt="Ink Blanes Tattoo Shop" width="1690" height="422" loading="lazy"></a>
    <p>© 2026 Ink Blanes Tattoo Shop · Blanes · <a href="https://www.instagram.com/inkblanestattooshop/" target="_blank" rel="noopener">Instagram</a> · <a href="https://wa.me/34656198570" target="_blank" rel="noopener">WhatsApp</a></p>
  </div>
</footer>

<nav class="dock" aria-label="Accesos rápidos">
  <a href="index.html#cita"><svg><use href="#i-wa"/></svg>Pide cita</a>
  <a href="tel:+34656198570"><svg><use href="#i-tel"/></svg>Llamar</a>
  <a href="index.html#visita"><svg><use href="#i-pin"/></svg>Mapa</a>
</nav>

<dialog id="lupa" aria-label="Foto ampliada">
  <button class="x" type="button" aria-label="Cerrar">✕</button>
  <button class="prev" type="button" aria-label="Foto anterior">←</button>
  <button class="next" type="button" aria-label="Foto siguiente">→</button>
  <figure><img src="" alt=""><p class="mono"></p></figure>
</dialog>

<script src="main.js"></script>
</body>
</html>
EOF
}

ELCHEF='<a href="https://www.instagram.com/elchef_tattoo/" target="_blank" rel="noopener">@elchef_tattoo</a>'
PALACIO='<a href="https://www.instagram.com/palacioartist/" target="_blank" rel="noopener">@palacioartist</a>'
li(){ for x in "$@"; do echo "        <li>$x</li>"; done; }

# ---------- 01 Fine line ----------
META="Tatuajes fine line en Blanes: trazo fino y limpio para piezas delicadas, lettering y minimalismo. Mira las fotos y pide cita en Ink Blanes."
OG=tattoo-estrella
WA="Hola%20Ink%20Blanes%2C%20quiero%20pedir%20cita%20para%20un%20tatuaje%20fine%20line."
SVG="<svg class=\"muestra\" viewBox=\"0 0 560 70\" preserveAspectRatio=\"none\" aria-hidden=\"true\"><path d=\"$WAVE\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\" vector-effect=\"non-scaling-stroke\"/></svg>"
LEAD="Trazo fino y limpio, sin relleno que estorbe. Lo justo para que el dibujo respire."
H2="Una sola línea, bien puesta"
P1="El fine line se trabaja con agujas muy finas y un trazo preciso. No hay sombra donde esconderse: cada línea se ve, así que el pulso y la paciencia lo son todo."
P2="Funciona especialmente bien en piezas pequeñas y medianas —flores, lettering, siluetas, símbolos—. Bien cuidado, envejece limpio y discreto."
IDEAL=$(li "Lettering y frases" "Flores y botánica" "Siluetas y símbolos" "Un primer tatuaje")
QUIEN=$ELCHEF
FOTOS=$(
foto tattoo-flor-proceso "Flor · en proceso" "Flor en fine line durante la sesión de tatuaje"
foto tattoo-estrella "Estrella de mar" "Estrella de mar en fine line sobre el hombro"
foto tattoo-tiburon "Tiburón" "Tiburón con estrellas en fine line sobre la cadera"
)
page 0

# ---------- 02 Black & grey ----------
META="Tatuajes black and grey en Blanes: sombras en negro diluido, volumen y profundidad sin color. Mira las fotos y pide cita en Ink Blanes."
OG=tattoo-dragon
WA="Hola%20Ink%20Blanes%2C%20quiero%20pedir%20cita%20para%20un%20tatuaje%20black%20and%20grey."
SVG='<svg class="muestra" viewBox="0 0 560 70" preserveAspectRatio="none" aria-hidden="true"><defs><linearGradient id="gw"><stop offset="0" stop-color="currentColor"/><stop offset="1" stop-color="currentColor" stop-opacity="0"/></linearGradient></defs><rect width="560" height="70" fill="url(#gw)"/></svg>'
LEAD="Negro diluido en mil grises. Volumen, profundidad y contraste sin una sola gota de color."
H2="Todo lo que cabe entre el negro y la piel"
P1="Se tatúa solo con tinta negra, rebajada en distintos tonos para construir luces y sombras. El resultado es atemporal: combina con todo y aguanta muy bien el paso de los años."
P2="Es el terreno natural de las piezas grandes —mangas, costados, espalda— y de los motivos con mucha textura: dragones, máscaras, animales o escenas completas."
IDEAL=$(li "Mangas y medias mangas" "Motivos japoneses" "Animales y naturaleza" "Piezas grandes con mucho detalle")
QUIEN=$ELCHEF
FOTOS=$(
foto tattoo-dragon "Dragón" "Dragón oriental en black and grey en el costado"
foto tattoo-hannya "Hannya" "Máscara hannya en black and grey en la mano"
foto tattoo-samurai "Media manga" "Media manga en black and grey"
foto tattoo-tortuga "Tortuga" "Tortuga marina en black and grey en el antebrazo"
foto tattoo-koi "Koi" "Carpa koi en black and grey en el hombro"
foto tattoo-espada "Espada" "Espada ornamental en el antebrazo"
foto tattoo-hannya-2 "Hannya · mano" "Máscara hannya en la mano, vista completa del brazo"
)
page 1

# ---------- 03 Neotradicional ----------
META="Tatuajes neotradicionales en Blanes: línea potente, composición clásica y motivos con carácter. Mira las fotos y pide cita en Ink Blanes."
OG=tattoo-cangrejo
WA="Hola%20Ink%20Blanes%2C%20quiero%20pedir%20cita%20para%20un%20tatuaje%20neotradicional."
SVG="<svg class=\"muestra\" viewBox=\"0 0 560 70\" preserveAspectRatio=\"none\" aria-hidden=\"true\"><path d=\"$WAVE\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"10\" stroke-linecap=\"round\" vector-effect=\"non-scaling-stroke\"/></svg>"
LEAD="La fuerza del tatuaje clásico, con más detalle, más profundidad y más imaginación."
H2="Línea gruesa, ideas propias"
P1="Hereda la línea potente y la composición rotunda del tradicional, pero suma degradados, volumen y un repertorio de motivos mucho más libre: animales, objetos, rostros, ornamentos."
P2="Son tatuajes que se leen de lejos y se disfrutan de cerca. Pueden ir solo en negro o con toques de color para marcar los acentos."
IDEAL=$(li "Animales con carácter" "Dagas, espadas y ornamentos" "Piezas con toques de color" "Diseños que se leen de lejos")
QUIEN=$PALACIO
FOTOS=$(
foto tattoo-cangrejo "Cangrejo" "Cangrejo neotradicional con toques de rojo"
foto tattoo-espada "Espada" "Espada ornamental en el antebrazo"
foto tattoo-hannya "Hannya" "Máscara hannya en la mano"
foto tattoo-koi "Koi" "Carpa koi en el hombro"
)
page 2

# ---------- 04 Realismo ----------
META="Tatuajes realistas en Blanes: retratos, mascotas y animales con todo el detalle. Mira las fotos y pide cita en Ink Blanes."
OG=tattoo-leon
WA="Hola%20Ink%20Blanes%2C%20quiero%20pedir%20cita%20para%20un%20tatuaje%20realista."
SVG='<svg class="muestra" viewBox="0 0 560 70" preserveAspectRatio="none" aria-hidden="true"><defs><pattern id="pt" width="7" height="7" patternUnits="userSpaceOnUse"><circle cx="3.5" cy="3.5" r="1.5" fill="currentColor"/></pattern><linearGradient id="gm"><stop offset="0" stop-color="#000"/><stop offset="1" stop-color="#fff"/></linearGradient><mask id="mk"><rect width="560" height="70" fill="url(#gm)"/></mask></defs><rect width="560" height="70" fill="url(#pt)"/><rect width="560" height="70" fill="currentColor" mask="url(#mk)" opacity=".85"/></svg>'
LEAD="Retratos, animales y texturas con tanto detalle que parecen salir de la piel."
H2="Aquí manda la luz"
P1="En el realismo la línea casi desaparece. Se trabaja por capas de sombra hasta conseguir pelo, piel, mirada y volumen como en una fotografía."
P2="Necesita una buena referencia y un tamaño suficiente para que el detalle respire. Tráenos la foto y te decimos cómo encajarla."
IDEAL=$(li "Retratos" "Mascotas" "Fauna salvaje" "Antebrazo, muslo o espalda")
QUIEN=$PALACIO
FOTOS=$(
foto tattoo-leon "León" "León rugiendo y cachorro, realismo en el antebrazo"
foto tattoo-retrato-perro "Retrato de mascota" "Retrato realista de un perro con su huella"
foto tattoo-tortuga "Tortuga" "Tortuga marina realista en el antebrazo"
)
page 3

# ---------- 05 Minitattoos ----------
META="Minitattoos en Blanes: tatuajes pequeños, rápidos y con significado. Mira las fotos y pide cita en Ink Blanes."
OG=tattoo-estrella
WA="Hola%20Ink%20Blanes%2C%20quiero%20pedir%20cita%20para%20un%20minitattoo."
SVG='<svg class="muestra" viewBox="0 0 560 70" aria-hidden="true" preserveAspectRatio="xMinYMid meet"><g fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"><path d="m40 10 6.500 14 15.500 1.800-11.500 10.600 3.100 15.200L40 44l-13.600 7.600 3.100-15.200L18 25.800 33.500 24Z"/><path d="m110 24 3.700 8 8.800 1-6.500 6 1.800 8.600L110 43.300l-7.700 4.300 1.800-8.600-6.500-6 8.800-1Z"/><path d="m160 14 2.300 5 5.500.6-4.100 3.800 1.100 5.400-4.800-2.700-4.800 2.700 1.100-5.400-4.100-3.800 5.500-.6Z"/></g></svg>'
LEAD="Pequeños, rápidos y con mucho significado. Los que empiezan siendo uno y acaban siendo colección."
H2="Poco espacio, mucha intención"
P1="Piezas de pocos centímetros, normalmente en línea fina y tinta negra, que se resuelven en una sesión corta."
P2="Perfectos para estrenarse, para hacerse algo a juego con alguien o para ir llenando huecos entre piezas más grandes."
IDEAL=$(li "Un primer tatuaje" "Tatuajes a juego" "Símbolos, iniciales y fechas" "Rellenar huecos")
QUIEN="$ELCHEF · $PALACIO"
FOTOS=$(
foto tattoo-estrella "Estrella de mar" "Minitattoo de estrella de mar en el hombro"
foto tattoo-estrella-pierna "Estrella" "Minitattoo de estrella en la pierna"
foto tattoo-tiburon "Tiburón" "Minitattoo de tiburón con estrellas"
)
page 4
ls -la *.html
