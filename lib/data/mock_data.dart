import '../models/models.dart';

class MockData {
  static final providers = <ProviderModel>[
    ProviderModel(id: 'p1', name: 'PlastiPack Nicaragua', location: 'Managua, Nicaragua', category: 'Empaques', description: 'Fabricación de envases y empaques plásticos de alta calidad para empresas y marcas nacionales.', logo: 'PLASTI PACK', rating: 4.8, reviews: 128, years: 16, responseTime: '2 horas', featured: true),
    ProviderModel(id: 'p2', name: 'Evanplast S.A.', location: 'Masaya, Nicaragua', category: 'Empaques', description: 'Soluciones integrales de empaque plástico e inyección para industrias, cosméticos y comercios.', logo: 'Evanplast', rating: 4.6, reviews: 89, years: 12, responseTime: '3 horas', featured: true),
    ProviderModel(id: 'p3', name: 'Innoplast', location: 'León, Nicaragua', category: 'Empaques', description: 'Innovación en empaques plásticos sostenibles, bolsas oxo-biodegradables y sellado hermético.', logo: 'Innoplast', rating: 4.5, reviews: 64, years: 9, responseTime: '3 horas'),
    ProviderModel(id: 'p4', name: 'Pack Solutions', location: 'Managua, Nicaragua', category: 'Empaques', description: 'Empaques personalizados y cajas de cartón corrugado para alimentos, comercio y manufactura.', logo: 'PACK', rating: 4.4, reviews: 71, years: 10, responseTime: '5 horas'),
    ProviderModel(id: 'p5', name: 'TransLogix Nicaragua', location: 'Managua, Nicaragua', category: 'Logística y Transporte', description: 'Transporte de carga pesada, distribución de última milla y almacenamiento refrigerado a nivel nacional.', logo: 'TransLogix', rating: 4.9, reviews: 156, years: 14, responseTime: '1 hora', featured: true),
    ProviderModel(id: 'p6', name: 'AgroInsumos del Norte', location: 'Matagalpa, Nicaragua', category: 'Materia Prima', description: 'Suministro mayorista de insumos agrícolas orgánicos, semillas certificadas y fertilizantes.', logo: 'AgroInsumos', rating: 4.7, reviews: 82, years: 18, responseTime: '4 horas', featured: true),
    ProviderModel(id: 'p7', name: 'PrintGrafic & Etiquetas', location: 'Managua, Nicaragua', category: 'Etiquetas y Publicidad', description: 'Impresión digital flexográfica de etiquetas autoadhesivas en bobina, termoencogibles y material POP.', logo: 'PrintGrafic', rating: 4.7, reviews: 95, years: 11, responseTime: '2 horas', featured: true),
    ProviderModel(id: 'p8', name: 'BioEnvases Occidente', location: 'Chinandega, Nicaragua', category: 'Empaques', description: 'Fabricante de envases biodegradables a base de bagazo de caña y fibras vegetales.', logo: 'BioEnvases', rating: 4.8, reviews: 43, years: 6, responseTime: '3 horas'),
    ProviderModel(id: 'p9', name: 'NicaTech Soluciones B2B', location: 'Estelí, Nicaragua', category: 'Tecnología B2B', description: 'Desarrollo de software empresarial ERP, automatización de inventarios y facturación electrónica DGI.', logo: 'NicaTech', rating: 4.9, reviews: 67, years: 8, responseTime: '1 hora', featured: true),
    ProviderModel(id: 'p10', name: 'Lácteos y Materia Prima Segoviana', location: 'Estelí, Nicaragua', category: 'Materia Prima', description: 'Distribución mayorista de derivados lácteos, pulpas de fruta y materias primas alimenticias.', logo: 'Segoviana', rating: 4.6, reviews: 52, years: 15, responseTime: '4 horas'),
    ProviderModel(id: 'p11', name: 'Express Carga Masaya', location: 'Masaya, Nicaragua', category: 'Logística y Transporte', description: 'Fletes y paquetería empresarial interdepartamental con entregas garantizadas en 24 horas.', logo: 'ExpressCarga', rating: 4.5, reviews: 78, years: 7, responseTime: '2 horas'),
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
