import { enableFirebaseTelemetry } from '@genkit-ai/firebase';
import { gemini15Flash, googleAI } from '@genkit-ai/googleai';
import { genkit, z } from 'genkit';

import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Configura las credenciales de Google Application Credentials para telemetría
process.env.GOOGLE_APPLICATION_CREDENTIALS = process.env.GOOGLE_APPLICATION_CREDENTIALS || path.join(__dirname, 'proveo-service-account.json');
process.env.GCLOUD_PROJECT = process.env.GCLOUD_PROJECT || 'proveonicaragua-43264';

// Habilita la telemetría y observabilidad de Firebase
try {
  enableFirebaseTelemetry();
} catch (e) {
  console.warn('⚠️ No se pudo inicializar telemetría:', e.message);
}

// Configuración de Genkit con Google AI
const ai = genkit({
  plugins: [
    googleAI({
      apiKey: process.env.GEMINI_API_KEY,
    }),
  ],
  model: gemini15Flash,
});

/**
 * Flow 1: Recomendación inteligente de proveedores B2B para PROVEO Match
 */
export const proveoMatchFlow = ai.defineFlow(
  {
    name: 'proveoMatchFlow',
    inputSchema: z.object({
      producto: z.string().describe('Producto o servicio buscado por el emprendedor'),
      departamento: z.string().describe('Ubicación en Nicaragua (ej. Managua, Masaya, León)'),
      prioridad: z.string().describe('Prioridad: Precio, Calidad, Rapidez o Cercanía'),
    }),
    outputSchema: z.object({
      recomendacion: z.string(),
      consejoB2B: z.string(),
    }),
  },
  async ({ producto, departamento, prioridad }) => {
    const prompt = `Eres el Asesor Inteligente B2B de PROVEO Nicaragua.
Un emprendedor busca: "${producto}" en "${departamento}", priorizando "${prioridad}".

Genera:
1. Una recomendación clara de qué tipo de proveedor buscar y qué especificaciones técnicas pedir.
2. Un consejo clave de negociación B2B en Nicaragua para este rubro.

Responde de forma concisa y profesional.`;

    const { text } = await ai.generate(prompt);
    return {
      recomendacion: text,
      consejoB2B: `Para ${producto} en ${departamento}, solicita siempre muestras previas y tiempos de entrega garantizados por escrito.`,
    };
  }
);

/**
 * Flow 2: Asistente general de PROVEO
 */
export const chatAsistenteFlow = ai.defineFlow(
  {
    name: 'chatAsistenteFlow',
    inputSchema: z.string(),
    outputSchema: z.string(),
  },
  async (pregunta) => {
    const { text } = await ai.generate({
      prompt: `Eres PROVEO Bot, el asistente de compras y proveedores B2B de Nicaragua. Responde amablemente en español: ${pregunta}`,
    });
    return text;
  }
);

console.log('✅ Genkit PROVEO flows configurados exitosamente.');
