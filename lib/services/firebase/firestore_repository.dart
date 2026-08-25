// ==============================================================================
// PROVEO NICARAGUA - Repositorio de Persistencia en Cloud Firestore (lib/services/firebase/firestore_repository.dart)
// ¿Qué hace?: Administra las lecturas, escrituras, auto-sembrado y flujos en tiempo real (Streams) de Firestore.
// ¿Por qué se utiliza?: Centraliza la interacción con la base de datos NoSQL de Proveo con tolerancia a fallos y fallback mock.
// ==============================================================================

// Importa el SDK de Cloud Firestore (DocumentSnapshot, CollectionReference, SetOptions, etc.)
import 'package:cloud_firestore/cloud_firestore.dart';

// Importa los datos semilla estáticos para auto-rellenado inicial o fallback offline
import '../../data/mock_data.dart';

// Importa los modelos del dominio (ProviderModel, ProductModel, QuotationModel, AuthUser, UserRole)
import '../../models/models.dart';

// Importa el servicio centralizado de Firebase
import 'firebase_service.dart';

/// Repositorio principal de persistencia de datos en Firestore para PROVEO Nicaragua.
class FirestoreRepository {
  /// Instancia de Cloud Firestore inyectada o resuelta desde FirebaseService
  final FirebaseFirestore? _firestore;

  /// Constructor que resuelve automáticamente la instancia de Firestore si la app está inicializada
  FirestoreRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ??
            (FirebaseService.isInitialized ? FirebaseService.firestore : null);

  /// Obtiene la lista de todos los proveedores registrados en la colección 'providers'.
  ///
  /// Si la colección está vacía, realiza un auto-sembrado con [MockData.providers].
  Future<List<ProviderModel>> getProviders() async {
    // Si no hay conexión con Firestore, retorna los datos locales mock
    if (_firestore == null) {
      return MockData.providers;
    }
    try {
      // Consulta todos los documentos de la colección 'providers'
      final snapshot = await _firestore.collection('providers').get();
      
      // Auto-sembrado (seeding) inicial si es la primera vez que se consulta la base de datos en la nube
      if (snapshot.docs.isEmpty) {
        for (final p in MockData.providers) {
          await saveProvider(p);
        }
        return MockData.providers;
      }
      
      // Mapea cada documento de Firestore al modelo fuertemente tipado ProviderModel
      return snapshot.docs.map(_providerFromDocument).toList();
    } catch (_) {
      // Fallback seguro a datos mock en caso de desconexión o restricciones de red
      return MockData.providers;
    }
  }

  /// Obtiene el historial de solicitudes y ofertas de cotización registradas en la nube.
  Future<List<QuotationModel>> getQuotations() async {
    if (_firestore == null) {
      return MockData.quotations;
    }
    try {
      final snapshot = await _firestore.collection('quotations').get();
      if (snapshot.docs.isEmpty) {
        return MockData.quotations;
      }
      return snapshot.docs.map((document) {
        final data = document.data();
        return QuotationModel(
          provider: data['provider'] as String? ?? '',
          price: (data['price'] as num?)?.toDouble() ?? 0,
          deliveryDays: (data['deliveryDays'] as num?)?.toInt() ?? 0,
          rating: (data['rating'] as num?)?.toDouble() ?? 0,
          distance: (data['distance'] as num?)?.toDouble() ?? 0,
          status: data['status'] as String? ?? 'Pendiente',
        );
      }).toList();
    } catch (_) {
      return MockData.quotations;
    }
  }

  /// Escucha en tiempo real (Stream) las modificaciones en la colección de proveedores.
  Stream<List<ProviderModel>> watchProviders() {
    if (_firestore == null) {
      return Stream.error(
        StateError('Firebase Firestore no está inicializado.'),
      );
    }
    // Retorna un flujo reactivo que emite una nueva lista cada vez que un proveedor cambia en la nube
    return _firestore
        .collection('providers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_providerFromDocument).toList());
  }

  /// Guarda o actualiza los datos de un proveedor en Firestore fusionando cambios (merge).
  Future<void> saveProvider(ProviderModel provider) =>
      _firestore!.collection('providers').doc(provider.id).set({
        'name': provider.name,
        'location': provider.location,
        'category': provider.category,
        'description': provider.description,
        'logo': provider.logo,
        'rating': provider.rating,
        'reviews': provider.reviews,
        'years': provider.years,
        'responseTime': provider.responseTime,
        'featured': provider.featured,
      }, SetOptions(merge: true));

  /// Guarda o actualiza el perfil de un usuario registrando su nombre, correo y rol asignado.
  Future<void> saveUser(AuthUser user) =>
      _firestore!.collection('users').doc(user.id).set({
        'name': user.name,
        'email': user.email,
        'role': user.role.name,
        'updatedAt': FieldValue.serverTimestamp(), // Marca de tiempo del servidor
      }, SetOptions(merge: true));

  /// Consulta el rol asignado a un usuario según su identificador único (UID).
  Future<UserRole?> getUserRole(String userId) async {
    if (_firestore == null) return null;
    final document = await _firestore.collection('users').doc(userId).get();
    final value = document.data()?['role'] as String?;
    // Busca la coincidencia en el enum UserRole
    for (final role in UserRole.values) {
      if (role.name == value) return role;
    }
    return null;
  }

  /// Registra un nuevo producto en el catálogo comercial de Firestore.
  Future<void> saveProduct(ProductModel product) =>
      _firestore!.collection('products').doc(product.id).set({
        'name': product.name,
        'description': product.description,
        'provider': product.provider,
        'category': product.category,
        'availability': product.availability,
        'price': product.price,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  /// Guarda una cotización formal enviada por un comprador o respondida por un proveedor.
  Future<void> saveQuotation(QuotationModel quotation, {String? id}) =>
      _firestore!.collection('quotations').doc(id).set({
        'provider': quotation.provider,
        'price': quotation.price,
        'deliveryDays': quotation.deliveryDays,
        'rating': quotation.rating,
        'distance': quotation.distance,
        'status': quotation.status,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  /// Envía un mensaje a la conversación directa entre un comprador y un proveedor.
  Future<void> saveMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) =>
      _firestore!.collection('chats').doc(chatId).collection('messages').add({
        'senderId': senderId,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

  /// Agrega un proveedor o producto a la lista de favoritos del usuario autenticado.
  Future<void> saveFavorite({
    required String userId,
    required String itemId,
    required String itemType,
  }) =>
      _firestore!
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(itemId)
          .set({
        'itemId': itemId,
        'itemType': itemType,
        'createdAt': FieldValue.serverTimestamp(),
      });

  /// Crea una notificación en la bandeja del usuario (ej: nueva cotización recibida).
  Future<void> saveNotification({
    required String userId,
    required String title,
    required String message,
  }) =>
      _firestore!
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add({
        'title': title,
        'message': message,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

  /// Función auxiliar que convierte un snapshot de Firestore en una instancia tipada de [ProviderModel].
  ProviderModel _providerFromDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return ProviderModel(
      id: document.id,
      name: data['name'] as String? ?? '',
      location: data['location'] as String? ?? '',
      category: data['category'] as String? ?? '',
      description: data['description'] as String? ?? '',
      logo: data['logo'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviews: (data['reviews'] as num?)?.toInt() ?? 0,
      years: (data['years'] as num?)?.toInt() ?? 0,
      responseTime: data['responseTime'] as String? ?? '',
      featured: data['featured'] as bool? ?? false,
    );
  }
}

