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
  final String id, name, description, provider, category, availability;
  final double price;
  ProductModel({required this.id, required this.name, required this.description, required this.provider, required this.category, required this.availability, required this.price});
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
