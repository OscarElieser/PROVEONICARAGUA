# 🎨 Manual de Identidad Visual y Diseño Gráfico — PROVEO Nicaragua
> **Entregables Oficiales de Diseño Gráfico — Categoría Aficionado (Hackathon Nicaragua 2026)**

---

## 📌 Índice del Manual
1. [ADN de la Marca (Concepto, Misión, Visión y Atributos)](#1-adn-de-la-marca)
2. [Identificador Gráfico (Construcción y Geometría del Logotipo)](#2-identificador-gráfico)
3. [Paleta Cromática Oficial y Pruebas de Contraste](#3-paleta-cromática-oficial-y-pruebas-de-contraste)
4. [Tipografía y Jerarquía Visual](#4-tipografía-y-jerarquía-visual)
5. [Valores de Marca y Moodboard Conceptual](#5-valores-de-marca-y-moodboard-conceptual)
6. [Reglas de Identidad y Usos Permitidos / No Permitidos](#6-reglas-de-identidad-y-usos)
7. [Wireframes, Mockups y Experiencia de Usuario (UX)](#7-wireframes-mockups-y-experiencia-de-usuario-ux)

---

## 1. ADN de la Marca

- **Nombre:** **PROVEO**
- **Eslogan Institucional:** *"Conectamos confianza. Impulsamos negocios."*
- **Concepto Central:** El puente inteligente que une a la oferta y la demanda productiva en Nicaragua, transformando la incertidumbre en decisiones fundamentadas mediante tecnología y transparencia.
- **Atributos de Marca:**
  - **Confiable:** Todo proveedor pasa por criterios de evaluación y validación.
  - **Transparente:** Precios claros, tiempos definidos y reputación abierta.
  - **Estratégico:** Asiste a las empresas con analítica comparativa para optimizar sus costos.
  - **Dinámico e Innovador:** Experiencia digital fluida, accesible y moderna.

---

## 2. Identificador Gráfico

### Conceptualización del Logotipo
El isotipo de PROVEO se compone de una red de nodos interconectados que forman un arco o puente ascendente. 
- Los **nodos** representan a los emprendedores, las MIPYMES y los proveedores.
- Las **líneas conectoras** simbolizan las transacciones, la comunicación y los acuerdos comerciales.
- El conjunto proyecta un apretón de manos geométrico y abstracto, reflejando el apretón de manos tradicional de los negocios pero potenciado por la tecnología digital.

### Archivos Vectoriales Oficiales Disponibles:
- `assets/logo/logo1.svg`: Versión completa horizontal con isotipo y wordmark PROVEO.
- `assets/logo/logo2.svg`: Isotipo aislado para favicon, avatares y aplicaciones en apps móviles.
- `assets/logo/logo3.svg`: Versión monocromática para sellos y documentos oficiales.

---

## 3. Paleta Cromática Oficial y Pruebas de Contraste

| Color | Nombre | Código HEX | Código RGB | Significado y Justificación Psicológica | Ratio de Contraste WCAG |
| :---: | :--- | :---: | :---: | :--- | :---: |
| <div style="background:#002049;width:30px;height:30px;border-radius:6px;"></div> | **Navy Corporativo** (Primario) | `#002049` | `rgb(0, 32, 73)` | Representa solidez institucional, autoridad, seriedad financiera y seguridad en las transacciones B2B. | **15.8:1** sobre blanco (Pasa AAA) |
| <div style="background:#00A86B;width:30px;height:30px;border-radius:6px;"></div> | **Trust Green** (Secundario) | `#00A86B` | `rgb(0, 168, 107)` | Transmite verificación aprobada, crecimiento económico, sostenibilidad y cierre exitoso de cotizaciones. | **3.8:1** sobre fondo oscuro / **4.5:1** para acentos (Pasa AA) |
| <div style="background:#F4F7FB;width:30px;height:30px;border-radius:6px;border:1px solid #ccc;"></div> | **Pale Blue** (Fondo Neutro) | `#F4F7FB` | `rgb(244, 247, 251)` | Brinda frescura, amplitud visual y descanso ocular en interfaces con gran densidad de datos. | **14.2:1** con texto Navy (Pasa AAA) |
| <div style="background:#FFFFFF;width:30px;height:30px;border-radius:6px;border:1px solid #ccc;"></div> | **Surface White** | `#FFFFFF` | `rgb(255, 255, 255)` | Pureza, orden y contraste para tarjetas de productos y perfiles. | **21:1** estándar |
| <div style="background:#E2E8F0;width:30px;height:30px;border-radius:6px;"></div> | **Border Gray** | `#E2E8F0` | `rgb(226, 232, 240)` | Delimitador sutil para formularios, tablas y separadores. | Neutro funcional |
| <div style="background:#F59E0B;width:30px;height:30px;border-radius:6px;"></div> | **Warning Gold** | `#F59E0B` | `rgb(245, 158, 11)` | Sistema de estrellas de reputación y avisos de atención comercial. | Pasa AA para elementos gráficos |

---

## 4. Tipografía y Jerarquía Visual

### Familia Tipográfica Oficial: **Montserrat** (Google Fonts)
Se seleccionó **Montserrat** por su naturaleza geométrica inspirada en la señalética urbana del siglo XX, aportando una presencia contemporánea, legible y de alta legibilidad en pantallas digitales de cualquier resolución.

### Jerarquía y Escala de Aplicación:

```text
01 — TÍTULO
Montserrat SemiBold — 36 pt (Line Height: 1.15, Letter Spacing: -0.5)
Uso: "Encuentra proveedores de confianza para hacer crecer tu negocio"

02 — SUBTÍTULO
Montserrat Medium — 20 pt (Line Height: 1.30, Letter Spacing: -0.2)
Uso: "PROVEO es el puente inteligente que conecta emprendedores y empresas..."

03 — CUERPO
Montserrat Regular — 12 pt (Line Height: 1.40, Letter Spacing: 0)
Uso: "Una forma más clara de elegir tus proveedores."
```

### Justificación de Elección Tipográfica:
1. **Legibilidad Óptima en Dispositivos:** Los grosores diferenciados (`w600` para títulos, `w500` para subtítulos y `w400` para cuerpo) garantizan jerarquía inmediata sin necesidad de saturar con colores adicionales.
2. **Compatibilidad Web y Móvil:** Soporte universal sin problemas de carga mediante Google Fonts CDN y renderizado acelerado en Flutter.

---

## 5. Valores de Marca y Moodboard Conceptual

### Los 5 Valores Fundamentales:
1. **Confianza Comprobada:** Evaluaciones reales, empresas registradas e insignias verificadas.
2. **Eficiencia Comercial:** Cotizaciones en horas, no en semanas; comparación automatizada.
3. **Transparencia Total:** Claridad en precios, cantidades mínimas (MOQ) y condiciones de entrega.
4. **Impulso Local:** Fomento de encadenamientos productivos entre MIPYMES nicaragüenses.
5. **Innovación con Propósito:** Inteligencia artificial aplicada para resolver problemas reales de negocio.

### Moodboard Visual (12 Referencias y Prompts de Inspiración)

| # | Concepto Visual | Tipo de Fuente | Prompt de Generación / Referencia Visual |
| :-: | :--- | :--- | :--- |
| **1** | Apretón de manos profesional | Fotografía web | Dos empresarios cerrando un acuerdo comercial en un entorno industrial limpio y moderno. |
| **2** | Red de nodos inteligentes | IA Generada | `Isometric 3D network nodes glowing with navy and emerald green colors, representing supply chain connectivity, modern minimalist corporate style --ar 16:9` |
| **3** | Almacén y logística organizada | Fotografía web | Bodega de empaques con cajas ordenadas, códigos QR y estándares de calidad. |
| **4** | Emprendedor en su taller | IA Generada | `Young Nicaraguan entrepreneur reviewing product samples with a tablet in a bright artisanal packaging studio, realistic photography, soft natural lighting --ar 4:3` |
| **5** | Interfaz de dashboard limpia | Diseño UI | Gráficos de barras, tarjetas con bordes redondeados (18px) y microinteracciones de cotización. |
| **6** | Insignia de verificación | Vectorial | Sello circular verde esmeralda con check blanco y tipografía Montserrat. |
| **7** | Mapa satelital interactivo | Vectorial/UI | Pin de ubicación corporativa sobre mapa limpio con rutas trazadas a Managua y Masaya. |
| **8** | Comparador de precios B2B | Diseño UI | Tarjetas con matrices de cotejo, tiempos de entrega y estrellas de calificación doradas. |
| **9** | Ficha técnica de producto | Diseño UI | Envase con etiqueta técnica, especificación de MOQ, unidad de medida y precio por millar. |
| **10** | Burbuja de chat corporativo | Diseño UI | Canal de mensajería seguro entre proveedor y comprador con estados de lectura y confirmación. |
| **11** | Gráfico de satisfacción 98% | Vectorial | Medidor circular con degradado azul marino y verde confianza. |
| **12** | Tipografía geométrica en gran formato | Tipografía | Caracteres de Montserrat en SemiBold y Medium sobre fondo limpio `Pale Blue`. |

---

## 6. Reglas de Identidad y Usos

### Área de Protección (Zona Segura):
El área de reserva alrededor del logotipo debe ser igual a la altura de la letra **"P"** del wordmark (`1X`). Ningún elemento gráfico, texto o borde debe invadir este espacio.

### Medidas Mínimas:
- **Digital:** Altura mínima de `28 px` para asegurar legibilidad del texto en smartphones.
- **Impreso:** Altura mínima de `15 mm`.

### Variaciones Permitidas:
1. **Versión Principal (Full Color):** Isotipo verde/azul sobre fondo blanco o fondos claros (`#F4F7FB`).
2. **Versión Negativa (Invertida):** Logotipo completamente blanco para fondos oscuros (`Navy #002049`).
3. **Versión Escala de Grises:** Isotipo y texto en tonalidades de gris para impresión monocromática y facturas.

### Usos No Permitidos (Prohibiciones):
- ❌ **No distorsionar las proporciones:** No estirar ni comprimir horizontal o verticalmente.
- ❌ **No cambiar los colores corporativos:** No aplicar colores fuera de la paleta oficial (ej: rojo brillante, amarillo neón).
- ❌ **No alterar la tipografía del logotipo:** No sustituir la tipografía Montserrat por otras fuentes.
- ❌ **No aplicar sombras difusas ni efectos 3D excesivos:** Mantener estética flat moderna.

---

## 7. Wireframes, Mockups y Experiencia de Usuario (UX)

### Relación de Aspecto y Responsive Design:
- **Modo Escritorio / Laptop:** Diseñado con contenedor centrado a `1180 px` en relación de aspecto estándar `16:9`.
- **Modo Tablet y Móvil:** Diseño fluido con navegación adaptativa (drawer lateral y app bar minimalista).

### Estructura de Wireframes en la Solución:
1. **Wireframe 1 - Landing Page:** Header superior -> Hero banner con buscador -> Barra de métricas -> Explicación en 4 pasos -> Proveedores destacados -> Footer B2B.
2. **Wireframe 2 - Directorio y Búsqueda:** Panel izquierdo de filtros (250px) + grilla de resultados con tarjetas empresariales (avatar, rating, tiempo de respuesta, botón de perfil y cotizar).
3. **Wireframe 3 - Perfil de Proveedor:** Cabecera con datos de contacto -> Pestañas de información y catálogo interactivo -> Mapa de geolocalización interactivo.
4. **Wireframe 4 - Wizard de Cotización:** Progresión por pasos (1. Detalles -> 2. Proveedores seleccionados -> 3. Matriz de cotizaciones recibidas).

---

© 2026 PROVEO Nicaragua — Manual de Identidad y Sistema de Diseño.
