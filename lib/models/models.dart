/// Roles disponibles en la experiencia PROVEO.
enum UserRole { entrepreneur, provider, admin, auditor }

/// Identidad minima que consumen los repositorios de autenticacion.
class AuthUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

class ProviderModel {
  final String id, name, location, category, description, logo;
  final double rating;
  final int reviews, years;
  final String responseTime;
  final bool featured;
  ProviderModel({required this.id, required this.name, required this.location, required this.category, required this.description, required this.logo, required this.rating, required this.reviews, required this.years, required this.responseTime, this.featured = false});
}

class ProductModel {
  final String id;
  final String name;
  final String model;
  final String description;
  final String provider;
  final String category;
  final String availability;
  final String currency;
  final double price;
  final double? maxPrice;
  final int moq;
  final String unit;
  final List<String> characteristics;
  final String imageUrl;
  final double discount;
  final bool isNew;

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

  String get priceDisplay {
    final base = '$currency ${price.toStringAsFixed(2)}';
    if (maxPrice != null) return '$base - $currency ${maxPrice!.toStringAsFixed(2)} / $unit';
    return '$base / $unit';
  }
}

class QuotationModel {
  final String provider;
  final double price;
  final int deliveryDays;
  final double rating;
  final double distance;
  final String status;
  QuotationModel({required this.provider, required this.price, required this.deliveryDays, required this.rating, required this.distance, this.status = 'Recibida'});
}
