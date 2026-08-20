import '../models/models.dart';

class MockData {
  static final providers = <ProviderModel>[
    ProviderModel(id: 'p1', name: 'PlastiPack Nicaragua', location: 'Managua, Nicaragua', category: 'Empaques', description: 'Fabricación de envases y empaques plásticos de alta calidad para empresas.', logo: 'PLASTI PACK', rating: 4.8, reviews: 128, years: 16, responseTime: '2 horas', featured: true),
    ProviderModel(id: 'p2', name: 'Evanplast S.A.', location: 'Masaya, Nicaragua', category: 'Empaques', description: 'Soluciones de empaque plástico para industrias y comercios.', logo: 'Evanplast', rating: 4.6, reviews: 89, years: 12, responseTime: '3 horas', featured: true),
    ProviderModel(id: 'p3', name: 'Innoplast', location: 'León, Nicaragua', category: 'Empaques', description: 'Innovación en empaques plásticos sostenibles y personalizados.', logo: 'Innoplast', rating: 4.5, reviews: 64, years: 9, responseTime: '3 horas'),
    ProviderModel(id: 'p4', name: 'Pack Solutions', location: 'Managua, Nicaragua', category: 'Empaques', description: 'Empaques personalizados para alimentos, comercio y manufactura.', logo: 'PACK', rating: 4.4, reviews: 71, years: 10, responseTime: '5 horas'),
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
