import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import 'firebase_service.dart';

/// Fuente de datos persistente de PROVEO.
///
/// Cada dominio tiene su propia coleccion. Los metodos de lectura conservan
/// un fallback local para que la demo siga arrancando sin Firebase.
class FirestoreRepository {
  final FirebaseFirestore? _firestore;

  FirestoreRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? (FirebaseService.isInitialized ? FirebaseService.firestore : null);

  CollectionReference<Map<String, dynamic>> _collection(String name) =>
      _firestore!.collection(name);

  Future<List<ProviderModel>> getProviders() async {
    if (_firestore == null) return MockData.providers;
    try {
      final snapshot = await _collection('providers').get();
      if (snapshot.docs.isEmpty) return MockData.providers;
      return snapshot.docs.map(_providerFromDocument).toList();
    } on FirebaseException {
      return MockData.providers;
    }
  }

  Stream<List<ProviderModel>> watchProviders() {
    if (_firestore == null) return Stream.value(MockData.providers);
    return _collection('providers').snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return MockData.providers;
      return snapshot.docs.map(_providerFromDocument).toList();
    });
  }

  Future<void> saveProvider(ProviderModel provider) => _collection('providers')
      .doc(provider.id)
      .set(_providerToMap(provider), SetOptions(merge: true));

  Future<void> saveUser(AuthUser user) => _collection('users').doc(user.id).set({
        'name': user.name,
        'email': user.email,
        'role': user.role.name,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  Future<void> saveProduct(ProductModel product) => _collection('products')
      .doc(product.id)
      .set({
        'name': product.name,
        'description': product.description,
        'provider': product.provider,
        'category': product.category,
        'availability': product.availability,
        'price': product.price,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  Future<void> saveQuotation(QuotationModel quotation, {String? id}) =>
      _collection('quotations').doc(id).set({
        'provider': quotation.provider,
        'price': quotation.price,
        'deliveryDays': quotation.deliveryDays,
        'rating': quotation.rating,
        'distance': quotation.distance,
        'status': quotation.status,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  Future<void> saveMessage({required String chatId, required String senderId, required String text}) =>
      _collection('chats').doc(chatId).collection('messages').add({
        'senderId': senderId,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> saveFavorite({required String userId, required String itemId, required String itemType}) =>
      _collection('users').doc(userId).collection('favorites').doc(itemId).set({
        'itemId': itemId,
        'itemType': itemType,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> saveNotification({required String userId, required String title, required String message}) =>
      _collection('users').doc(userId).collection('notifications').add({
        'title': title,
        'message': message,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> seedDemoProviders() async {
    await _seedCollectionIfEmpty('providers', MockData.providers.map((provider) => MapEntry(provider.id, {..._providerToMap(provider), 'demo': true})));
  }

  /// Carga el contenido demostrativo para que la consola no aparezca vacia.
  /// Nunca sobreescribe documentos existentes en Firestore.
  Future<void> seedDemoData() async {
    if (_firestore == null) return;
    try {
      await seedDemoProviders();
      await _seedCollectionIfEmpty('products', MockData.products.map((product) => MapEntry(product.id, {
            'name': product.name,
            'description': product.description,
            'provider': product.provider,
            'category': product.category,
            'availability': product.availability,
            'price': product.price,
            'demo': true,
          })));
      await _seedCollectionIfEmpty('quotations', MockData.quotations.asMap().map((index, quotation) => MapEntry('demo-${index + 1}', {
            'provider': quotation.provider,
            'price': quotation.price,
            'deliveryDays': quotation.deliveryDays,
            'rating': quotation.rating,
            'distance': quotation.distance,
            'status': quotation.status,
            'demo': true,
          })).entries);
      await _seedCollectionIfEmpty('categories', const [
        'Materias primas', 'Productos terminados', 'Servicios profesionales',
        'Tecnología', 'Equipos', 'Transporte', 'Construcción', 'Agricultura',
        'Alimentación', 'Empaques', 'Marketing', 'Servicios empresariales',
      ].asMap().map((index, name) => MapEntry('category-${index + 1}', {'name': name, 'demo': true})).entries);
    } on FirebaseException {
      // La app sigue funcionando con MockData si Firestore aun no tiene acceso.
    }
  }

  Future<void> _seedCollectionIfEmpty(String name, Iterable<MapEntry<String, Map<String, dynamic>>> documents) async {
    final collection = _collection(name);
    final existing = await collection.limit(1).get();
    if (existing.docs.isNotEmpty) return;
    final batch = _firestore!.batch();
    for (final document in documents) {
      batch.set(collection.doc(document.key), {...document.value, 'createdAt': FieldValue.serverTimestamp()});
    }
    await batch.commit();
  }

  Map<String, dynamic> _providerToMap(ProviderModel provider) => {
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
        'updatedAt': FieldValue.serverTimestamp(),
      };

  ProviderModel _providerFromDocument(QueryDocumentSnapshot<Map<String, dynamic>> document) {
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