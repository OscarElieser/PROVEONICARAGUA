// ==============================================================================
// PROVEO NICARAGUA - Servidor de Flujos de IA con Firebase Genkit (genkit-proveo.mjs)
// ¿Qué hace?: Define los flujos de IA generativa con Gemini 1.5 Flash para matching de proveedores y chat B2B.
// ¿Por qué se utiliza?: Proporciona una arquitectura serverless escalable y tipada para la lógica de IA de Proveo.
// ==============================================================================

// Importa el módulo de observabilidad y métricas de Firebase para rastrear ejecuciones de IA
import { enableFirebaseTelemetry } from '@genkit-ai/firebase';

// Importa el plugin oficial de Google AI y el modelo de lenguaje optimizado Gemini 1.5 Flash
import { gemini15Flash, googleAI } from '@genkit-ai/googleai';

// Importa la instancia principal de Genkit y la librería Zod para validación estricta de esquemas
import { genkit, z } from 'genkit';

// Módulo nativo de Node.js para manejo de rutas de archivos en el sistema operativo
import path from 'path';

// Utilidad para convertir URLs de módulos ES a rutas de sistema de archivos estándar
import { fileURLToPath } from 'url';

// Obtiene la ruta absoluta del archivo actual para resolver dependencias locales
const __filename = fileURLToPath(import.meta.url);

// Obtiene el directorio padre donde reside el script
const __dirname = path.dirname(__filename);

// Configura la variable de entorno con la llave de cuenta de servicio de Google Cloud para autenticación de telemetría
process.env.GOOGLE_APPLICATION_CREDENTIALS = process.env.GOOGLE_APPLICATION_CREDENTIALS || path.join(__dirname, 'proveo-service-account.json');

// Establece el ID de proyecto de Google Cloud / Firebase por defecto si no está predefinido
process.env.GCLOUD_PROJECT = process.env.GCLOUD_PROJECT || 'proveonicaragua-43264';

// Bloque de inicialización segura de telemetría en Firebase Cloud Logging / Monitoring
try {
  // Activa el registro automático de trazas, costos de tokens y latencias de los modelos
  enableFirebaseTelemetry();
} catch (e) {
  // Captura fallos de credenciales sin detener la ejecución del servidor
  console.warn('⚠️ No se pudo inicializar telemetría:', e.message);
}

// Inicializa el núcleo de Genkit con los plugins y modelo predeterminado
const ai = genkit({
  plugins: [
    // Registra el proveedor de Google AI inyectando la clave de API desde variables de entorno
    googleAI({
      apiKey: process.env.GEMINI_API_KEY,
    }),
  ],
  // Define Gemini 1.5 Flash como modelo base por su balance óptimo de velocidad y costo
  model: gemini15Flash,
});

// ==============================================================================
// FLUJO 1: Recomendación Inteligente de Proveedores B2B (PROVEO Match)
// ¿Qué hace?: Analiza el requerimiento de compra, departamento y prioridad de un emprendedor.
// ¿Por qué se utiliza?: Asesora técnicamente al comprador antes de enviar solicitudes de cotización.
// ==============================================================================
export const proveoMatchFlow = ai.defineFlow(
  {
    // Identificador único del flujo para invocación remota o vía CLI de Genkit
    name: 'proveoMatchFlow',
    
    // Esquema de validación de entrada con Zod
    inputSchema: z.object({
      // Requerimiento comercial buscado (ej: "Bolsas biodegradables kraft")
      producto: z.string().describe('Producto o servicio buscado por el emprendedor'),
      // Ubicación geográfica del comprador en Nicaragua (ej: "Managua", "León")
      departamento: z.string().describe('Ubicación en Nicaragua (ej. Managua, Masaya, León)'),
      // Criterio de decisión prioritario del negocio (Precio, Calidad, Rapidez o Cercanía)
      prioridad: z.string().describe('Prioridad: Precio, Calidad, Rapidez o Cercanía'),
    }),

    // Esquema de datos estructurados de salida devueltos a la aplicación Flutter
    outputSchema: z.object({
      // Sugerencia técnica elaborada por la IA
      recomendacion: z.string(),
      // Tip o consejo estratégico contextualizado para el mercado nicaragüense
      consejoB2B: z.string(),
    }),
  },
  // Función ejecutora asíncrona del flujo
  async ({ producto, departamento, prioridad }) => {
    // Construye un prompt contextualizado con rol de experto en comercio B2B en Nicaragua
    const prompt = `Eres el Asesor Inteligente B2B de PROVEO Nicaragua.
Un emprendedor busca: "${producto}" en "${departamento}", priorizando "${prioridad}".

Genera:
1. Una recomendación clara de qué tipo de proveedor buscar y qué especificaciones técnicas pedir.
2. Un consejo clave de negociación B2B en Nicaragua para este rubro.

Responde de forma concisa y profesional.`;

    // Ejecuta la inferencia con el modelo Gemini
    const { text } = await ai.generate(prompt);

    // Retorna la respuesta estructurada acorde a outputSchema
    return {
      recomendacion: text,
      consejoB2B: `Para ${producto} en ${departamento}, solicita siempre muestras previas y tiempos de entrega garantizados por escrito.`,
    };
  }
);

// ==============================================================================
// FLUJO 2: Asistente Virtual y Preguntas Frecuentes B2B de PROVEO
// ¿Qué hace?: Atiende consultas generales de compradores y proveedores en lenguaje natural.
// ¿Por qué se utiliza?: Resuelve dudas rápidas sobre compras al por mayor y logística local.
// ==============================================================================
export const chatAsistenteFlow = ai.defineFlow(
  {
    // Nombre del flujo
    name: 'chatAsistenteFlow',
    // Entrada: Texto simple de la pregunta del usuario
    inputSchema: z.string(),
    // Salida: Respuesta procesada por la IA
    outputSchema: z.string(),
  },
  // Función ejecutora
  async (pregunta) => {
    // Genera respuesta con tono cordial y especializado en comercio nicaragüense
    const { text } = await ai.generate({
      prompt: `Eres PROVEO Bot, el asistente de compras y proveedores B2B de Nicaragua. Responde amablemente en español: ${pregunta}`,
    });
    // Devuelve el texto generado
    return text;
  }
);

// Mensaje de confirmación en consola al levantar los flujos de Genkit
console.log('✅ Genkit PROVEO flows configurados exitosamente.');

