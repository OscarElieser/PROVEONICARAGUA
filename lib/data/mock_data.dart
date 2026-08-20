import '../models/models.dart';

class MockData {
  static final providers = <ProviderModel>[
    ProviderModel(
      id: 'p1', name: 'PlastiPack Nicaragua', location: 'Managua, Nicaragua',
      category: 'Empaques', logo: 'PP', rating: 4.8, reviews: 128, years: 16,
      responseTime: '2 horas', featured: true,
      description: 'Fabricación de envases y empaques plásticos de alta calidad para empresas. Más de 16 años liderando el sector industrial en Nicaragua con certificaciones nacionales e internacionales.',
    ),
    ProviderModel(
      id: 'p2', name: 'Evanplast S.A.', location: 'Masaya, Nicaragua',
      category: 'Empaques', logo: 'EV', rating: 4.6, reviews: 89, years: 12,
      responseTime: '3 horas', featured: true,
      description: 'Soluciones de empaque plástico para industrias y comercios. Especialistas en producción a gran escala con control de calidad ISO y entregas puntuales en toda Nicaragua.',
    ),
    ProviderModel(
      id: 'p3', name: 'Innoplast', location: 'León, Nicaragua',
      category: 'Empaques', logo: 'IN', rating: 4.5, reviews: 64, years: 9,
      responseTime: '3 horas', featured: false,
      description: 'Innovación en empaques plásticos sostenibles y personalizados. Pioneros en materiales biodegradables y eco-friendly para el sector empresarial nicaragüense.',
    ),
    ProviderModel(
      id: 'p4', name: 'Pack Solutions', location: 'Managua, Nicaragua',
      category: 'Empaques', logo: 'PS', rating: 4.4, reviews: 71, years: 10,
      responseTime: '5 horas', featured: false,
      description: 'Empaques personalizados para alimentos, comercio y manufactura. Ofrecemos diseño, producción y entrega de soluciones de empaque a medida del cliente.',
    ),
    ProviderModel(
      id: 'p5', name: 'AgroTech Nicaragua', location: 'Chinandega, Nicaragua',
      category: 'Materia Prima', logo: 'AT', rating: 4.7, reviews: 112, years: 14,
      responseTime: '4 horas', featured: true,
      description: 'Proveedor de materias primas agrícolas e industriales. Suministramos insumos para la agroindustria, manufactura y exportación con estándares de calidad internacionales.',
    ),
    ProviderModel(
      id: 'p6', name: 'CacaoNica Export', location: 'Matagalpa, Nicaragua',
      category: 'Materia Prima', logo: 'CN', rating: 4.9, reviews: 204, years: 20,
      responseTime: '6 horas', featured: true,
      description: 'Exportación y comercialización de cacao fino de aroma certificado. Producto orgánico de las mejores fincas del norte de Nicaragua con trazabilidad completa.',
    ),
    ProviderModel(
      id: 'p7', name: 'LogisNica S.A.', location: 'Managua, Nicaragua',
      category: 'Logística', logo: 'LN', rating: 4.3, reviews: 45, years: 7,
      responseTime: '2 horas', featured: false,
      description: 'Servicios de logística y transporte de mercancía a nivel nacional. Gestión de cadena de suministro, almacenamiento y distribución last-mile para empresas de todos los tamaños.',
    ),
    ProviderModel(
      id: 'p8', name: 'TechSolutions NI', location: 'Managua, Nicaragua',
      category: 'Tecnología', logo: 'TS', rating: 4.6, reviews: 58, years: 8,
      responseTime: '1 hora', featured: false,
      description: 'Soluciones tecnológicas B2B: hardware, software y servicios de TI para empresas. Implementación de ERP, sistemas de gestión y soporte técnico empresarial.',
    ),
    ProviderModel(
      id: 'p9', name: 'Imprenta Digital Pro', location: 'Granada, Nicaragua',
      category: 'Etiquetas', logo: 'ID', rating: 4.4, reviews: 37, years: 6,
      responseTime: '4 horas', featured: false,
      description: 'Impresión digital de etiquetas, empaques y material POP para marcas. Tecnología de última generación para tirajes desde 100 unidades con acabados premium.',
    ),
    ProviderModel(
      id: 'p10', name: 'QuímiTech Industrial', location: 'Tipitapa, Nicaragua',
      category: 'Materia Prima', logo: 'QT', rating: 4.5, reviews: 93, years: 11,
      responseTime: '5 horas', featured: false,
      description: 'Distribución de químicos industriales, aditivos y materias primas para manufactura. Certificados INSHT y con manejo especializado de materiales peligrosos.',
    ),
    ProviderModel(
      id: 'p11', name: 'FrioNic Refrigeración', location: 'Managua, Nicaragua',
      category: 'Logística', logo: 'FR', rating: 4.2, reviews: 29, years: 5,
      responseTime: '3 horas', featured: false,
      description: 'Transporte refrigerado y cadena de frío para alimentos y farmacéuticos. Flota moderna con monitoreo GPS y temperatura controlada en tiempo real.',
    ),
    ProviderModel(
      id: 'p12', name: 'Carpintería Artesana', location: 'Masaya, Nicaragua',
      category: 'Manufactura', logo: 'CA', rating: 4.8, reviews: 156, years: 25,
      responseTime: '8 horas', featured: false,
      description: 'Muebles y soluciones en madera para empresas y retail. Especialistas en producción por lotes, packaging de madera y mobiliario corporativo personalizado.',
    ),
  ];

  static final products = <ProductModel>[
    const ProductModel(id: '1', name: 'Bolsa transparente 500 ml', description: 'Empaque plástico transparente con tapa, apto para alimentos.', provider: 'PlastiPack Nicaragua', category: 'Empaques', availability: 'Disponible', price: 0.18),
    const ProductModel(id: '2', name: 'Bolsa biodegradable', description: 'Alternativa sostenible para comercio y alimentos.', provider: 'Innoplast', category: 'Sostenibles', availability: 'Bajo pedido', price: 0.24),
    const ProductModel(id: '3', name: 'Envase PET 1 litro', description: 'Envase resistente para bebidas y productos líquidos.', provider: 'Evanplast S.A.', category: 'Envases', availability: 'Disponible', price: 0.31),
    const ProductModel(id: '4', name: 'Etiqueta adhesiva premium', description: 'Etiquetas personalizadas para productos y marcas.', provider: 'Pack Solutions', category: 'Etiquetas', availability: 'Disponible', price: 0.08),
  ];

  static final quotations = <QuotationModel>[
    QuotationModel(provider: 'PlastiPack Nicaragua', price: 12500, deliveryDays: 4, rating: 4.8, distance: 8.2),
    QuotationModel(provider: 'Evanplast S.A.', price: 10900, deliveryDays: 6, rating: 4.6, distance: 32.4),
    QuotationModel(provider: 'Innoplast', price: 11700, deliveryDays: 5, rating: 4.5, distance: 92.1),
  ];
}
