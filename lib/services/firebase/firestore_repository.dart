import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import 'firebase_service.dart';

/// Fuente de datos persistente de PROVEO.
///
/// Cada dominio tiene su propia coleccion para el producto en producción.
class FirestoreRepository {
  final FirebaseFirestore? _firestore;

  FirestoreRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ??
            (FirebaseService.isInitialized ? FirebaseService.firestore : null);

  Future<List<ProviderModel>> getProviders() async {
    if (_firestore == null) {
      return MockData.providers;
    }
    try {
      final snapshot = await _firestore.collection('providers').get();
      if (snapshot.docs.isEmpty) {
        // Auto-sembrado inicial en Firestore si la base de datos esta vacia
        for (final p in MockData.providers) {
          await saveProvider(p);
        }
        return MockData.providers;
      }
      return snapshot.docs.map(_providerFromDocument).toList();
    } catch (_) {
      // Fallback a datos mock si no hay permisos de red o reglas bloqueadas
      return MockData.providers;
    }
  }

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

  Stream<List<ProviderModel>> watchProviders() {
    // Verifica que Firestore este inicializado antes de retornar el stream de error
    if (_firestore == null) {
      return Stream.error(
          StateError('Firebase Firestore no está inicializado.'));
    }
    return _firestore
        .collection('providers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_providerFromDocument).toList());
  }

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

  Future<void> saveUser(AuthUser user) =>
      _firestore!.collection('users').doc(user.id).set({
        'name': user.name,
        'email': user.email,
        'role': user.role.name,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  Future<UserRole?> getUserRole(String userId) async {
    if (_firestore == null) return null;
    final document = await _firestore.collection('users').doc(userId).get();
    final value = document.data()?['role'] as String?;
    for (final role in UserRole.values) {
      if (role.name == value) return role;
    }
    return null;
  }

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

  Future<void> saveMessage(
          {required String chatId,
          required String senderId,
          required String text}) =>
      _firestore!.collection('chats').doc(chatId).collection('messages').add({
        'senderId': senderId,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> saveFavorite(
          {required String userId,
          required String itemId,
          required String itemType}) =>
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

  Future<void> saveNotification(
          {required String userId,
          required String title,
          required String message}) =>
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
