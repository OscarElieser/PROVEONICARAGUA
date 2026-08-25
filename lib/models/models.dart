// ==============================================================================
// PROVEO NICARAGUA - Capa de Modelos de Dominio (lib/models/models.dart)
// ¿Qué hace?: Define las entidades y estructuras de datos fundamentales para usuarios, proveedores, productos y cotizaciones.
// ¿Por qué se utiliza?: Asegura tipado fuerte, inmutabilidad y coherencia en toda la lógica de negocio de la aplicación.
// ==============================================================================

/// Enumerador que define los roles de usuario permitidos dentro de la plataforma PROVEO.
///
/// Cada rol otorga permisos, vistas y funcionalidades diferenciadas en el sistema.
enum UserRole {
  /// Emprendedor o comprador que busca insumos, compara y solicita cotizaciones.
  entrepreneur,

  /// Empresa proveedora que publica catálogo, responde cotizaciones y atiende clientes.
  provider,

  /// Administrador general con acceso al panel de control, métricas y gestión de catálogos.
  admin,

  /// Perfil auditor para revisión de cumplimiento, métricas de calidad y contratos.
  auditor,
}

/// Modelo inmutable que representa la identidad del usuario autenticado en la sesión actual.
class AuthUser {
  /// Identificador único del usuario (UID proveniente de Firebase Authentication).
  final String id;

  /// Nombre completo o razón social del usuario registrado.
  final String name;

  /// Dirección de correo electrónico asociada a la cuenta.
  final String email;

  /// Rol asignado que determina los privilegios de navegación y permisos de la UI.
  final UserRole role;

  /// Constructor constante para optimizar la memoria y garantizar la inmutabilidad de la sesión.
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

/// Modelo que encapsula los datos comerciales, reputación y métricas de una empresa proveedora.
class ProviderModel {
  /// Identificador único del proveedor en la base de datos Firestore.
  final String id;

  /// Nombre comercial de la empresa proveedora (ej: "Plásticos de Nicaragua").
  final String name;

  /// Ubicación geográfica de la sucursal o matriz (ej: "Managua, Pista Jean Paul Genie").
  final String location;

  /// Categoría industrial a la que pertenece (ej: "Empaque y Embalaje").
  final String category;

  /// Resumen del perfil comercial, servicios y capacidades técnicas.
  final String description;

  /// URL o recurso del logo corporativo de la empresa.
  final String logo;

  /// Calificación promedio otorgada por compradores (rango 0.0 a 5.0).
  final double rating;

  /// Cantidad total de reseñas y valoraciones recibidas.
  final int reviews;

  /// Años de experiencia comprobada operando en el mercado nicaragüense.
  final int years;

  /// Promedio de tiempo que tarda en contestar cotizaciones (ej: "< 2 horas").
  final String responseTime;

  /// Indica si el proveedor tiene membresía destacada / verificada por Proveo.
  final bool featured;

  /// Constructor con parámetros nombrados para inicializar los datos del proveedor.
  ProviderModel({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.description,
    required this.logo,
    required this.rating,
    required this.reviews,
    required this.years,
    required this.responseTime,
    this.featured = false,
  });
}

/// Modelo que representa un producto o insumo al por mayor disponible en el catálogo B2B.
class ProductModel {
  /// Identificador único del producto en el catálogo.
  final String id;

  /// Nombre descriptivo del producto (ej: "Cajas de Cartón Corrugado").
  final String name;

  /// Código o modelo comercial del fabricante (ej: "MOD-C40").
  final String model;

  /// Ficha técnica y detalles del producto.
  final String description;

  /// Nombre de la empresa proveedora que comercializa este artículo.
  final String provider;

  /// Rubro o categoría a la que pertenece el producto.
  final String category;

  /// Estado de stock o disponibilidad (ej: "Disponible", "Bajo Pedido").
  final String availability;

  /// Símbolo monetario (por defecto Córdobas nicaragüenses C$).
  final String currency;

  /// Precio base unitario o costo mínimo por volumen.
  final double price;

  /// Precio máximo en caso de escalas de precios o rango de personalización.
  final double? maxPrice;

  /// Cantidad Mínima de Pedido (Minimum Order Quantity - MOQ).
  final int moq;

  /// Unidad de medida comercial (ej: "unidad", "millar", "caja", "galón").
  final String unit;

  /// Lista de características técnicas destacadas del producto.
  final List<String> characteristics;

  /// URL o path de la imagen fotográfica del producto.
  final String imageUrl;

  /// Porcentaje de descuento promocional aplicado al precio base.
  final double discount;

  /// Bandera visual para etiquetar productos recién incorporados al catálogo.
  final bool isNew;

  /// Constructor constante con valores predeterminados para facilitar instanciación limpia.
  const ProductModel({
    required this.id,
    required this.name,
    this.model = '',
    required this.description,
    required this.provider,
    required this.category,
    this.availability = 'Disponible',
    this.currency = 'C\$',
    required this.price,
    this.maxPrice,
    this.moq = 1,
    this.unit = 'unidad',
    this.characteristics = const [],
    this.imageUrl = '',
    this.discount = 0,
    this.isNew = false,
  });

  /// Getter computado que genera el texto formateado de precio (rango o precio fijo con su unidad).
  String get priceDisplay {
    // Formatea el precio base con dos decimales estándar
    final base = '$currency ${price.toStringAsFixed(2)}';
    
    // Si existe un precio tope, presenta un rango de precios claro al comprador
    if (maxPrice != null) {
      return '$base - $currency ${maxPrice!.toStringAsFixed(2)} / $unit';
    }
    
    // Si es precio fijo unitario, concatena la moneda y la unidad de medida
    return '$base / $unit';
  }
}

/// Modelo que representa una oferta o cotización generada en respuesta a un requerimiento de compra.
class QuotationModel {
  /// Nombre del proveedor que emite la oferta.
  final String provider;

  /// Monto total cotizado para el pedido solicitado.
  final double price;

  /// Plazo estimado de entrega en días hábiles.
  final int deliveryDays;

  /// Reputación del proveedor que oferta (0.0 a 5.0).
  final double rating;

  /// Distancia estimada en kilómetros hasta el destino de entrega del comprador.
  final double distance;

  /// Estado actual del flujo de cotización (ej: "Recibida", "Aceptada", "Rechazada").
  final String status;

  /// Constructor con parámetros requeridos y estado inicial por defecto.
  QuotationModel({
    required this.provider,
    required this.price,
    required this.deliveryDays,
    required this.rating,
    required this.distance,
    this.status = 'Recibida',
  });
}

