# PROVEO Premium

PROVEO conecta emprendedores, MIPYMES y proveedores confiables. La experiencia se centra en reducir la incertidumbre: buscar, comparar, cotizar, conversar y decidir con reputación verificable.

## Tecnología

- Flutter + Dart + Material 3
- Layout responsive para móvil, tablet, Web y escritorio
- Firebase Core y Analytics preparados mediante `FirebaseService`
- MockData para ejecutar la demo sin backend
- Motor de recomendaciones explicable basado en reglas

## Ejecutar

```bash
flutter pub get
flutter run
flutter run -d chrome
```

Validación y builds:

```bash
flutter analyze
flutter test
flutter build web
flutter build apk --release
flutter build windows --release
```

## Recorrido de demo

1. En Home, busca `empaque plástico` o abre `PROVEO Match`.
2. Revisa PlastiPack Nicaragua, Evanplast S.A. e Innoplast.
3. Abre el perfil de un proveedor, catálogo y solicitud de cotización.
4. Revisa las propuestas en Cotizaciones y abre el Comparador.
5. Continúa por Chat y Círculo Dorado.

## Usuarios demo

El repositorio incluye `MockAuthRepository`; no almacena contraseñas.

| Rol | Correo |
| --- | --- |
| Emprendedor | `emprendedor@demo.proveo` |
| Proveedor | `proveedor@demo.proveo` |
| Administrador | `admin@demo.proveo` |
| Auditor, solo lectura | `auditor@demo.proveo` |

La contraseña demo puede ser cualquier valor mientras la experiencia siga en modo mock.

## Arquitectura

```text
lib/
  core/                  tema, colores y widgets reutilizables
  data/                  datos de demostración
  models/                modelos y roles compartidos
  screens/               superficies responsive de producto
  services/
    auth/                contrato de autenticación y mock
    ai/                  recomendaciones explicables por reglas
    firebase/            inicialización Firebase y Analytics
  main.dart
```

Las pantallas dependen de contratos y modelos, no de credenciales. `AuthRepository` puede recibir una implementación Firebase Auth y `AIRecommendationService` puede sustituirse por un adaptador para Gemini u OpenAI sin cambiar la navegación.

## Firebase

La configuración Web vive en `lib/firebase_options.dart` y la inicialización está centralizada en `lib/services/firebase/firebase_service.dart`. Para habilitar plataformas nativas:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
flutter pub get
```

Después se pueden añadir Auth, Firestore, Storage, FCM y Crashlytics siguiendo el mismo patrón de repositorios. La demo captura la ausencia de opciones nativas y continúa con MockData.

### Google Authentication

1. En Firebase Console, activa `Authentication > Sign-in method > Google`.
2. Ejecuta `flutterfire configure` y selecciona Web, Android, iOS y Windows según corresponda.
3. En Android agrega el `google-services.json` generado; en iOS agrega `GoogleService-Info.plist` y el esquema URL indicado por Firebase.
4. La implementación está en `lib/services/auth/firebase_auth_repository.dart`. En Web usa `signInWithPopup`; en móvil usa `google_sign_in`.

La cuenta de servicio de Firebase Admin **no se usa en Flutter**. Debe permanecer únicamente en un backend seguro o en Secret Manager.

### Firestore

`FirestoreProviderRepository` lee y guarda proveedores en la colección `providers`. Las reglas iniciales están en `firestore.rules`; publícalas con:

```bash
firebase deploy --only firestore:rules
```

Al iniciar la demo, PROVEO crea una sesión anónima temporal y carga proveedores, productos, cotizaciones y categorías demo únicamente si esas colecciones están vacías. En Firebase Console activa `Authentication > Sign-in method > Anonymous` y reinicia la app. La carga no sobrescribe documentos existentes.

### Gemini

`GeminiRecommendationService` usa reglas como fallback y solo llama a Gemini cuando recibe una clave en tiempo de ejecución:

```bash
flutter run --dart-define=GEMINI_API_KEY=TU_CLAVE_LOCAL
flutter build web --dart-define=GEMINI_API_KEY=TU_CLAVE_LOCAL
```

No escribas la clave en Dart, Git, assets ni `firebase_options.dart`. Para producción, mueve la llamada de Gemini a Cloud Functions o Cloud Run y entrega al cliente únicamente el resultado.

## MockData e IA

Los proveedores de Nicaragua y las cotizaciones están en `lib/data/mock_data.dart`. El motor inicial usa pesos configurables para reputación, respuesta, distancia y experiencia. No contiene claves API. Las futuras claves deben gestionarse mediante configuración segura o variables de entorno.

## Logo y diseño

`ProveoLogo` encapsula `assets/logo/proveo_logo.png`, por lo que el asset oficial puede reemplazarse sin modificar pantallas. La paleta PROVEO está centralizada en `lib/core/theme/app_colors.dart` y el tema Material 3 en `lib/core/theme/app_theme.dart`.
