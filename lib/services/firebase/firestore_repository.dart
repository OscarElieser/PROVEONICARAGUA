import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/models.dart';
import 'firebase_service.dart';

/// Fuente de datos persistente de PROVEO.
///
/// Cada dominio tiene su propia coleccion para el producto en producción.
class FirestoreRepository {
  final FirebaseFirestore? _firestore;

  FirestoreRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? (FirebaseService.isInitialized ? FirebaseService.firestore : null);

  CollectionReference<T> _collection<T>(
    String name, {
    required T Function(DocumentSnapshot<Map<String, dynamic>>, SnapshotOptions?) fromFirestore,
    required Map<String, Object?> Function(T, SetOptions?) toFirestore,
  }) =>
      _firestore!.collection(name).withConverter<T>(
            fromFirestore: fromFirestore,
            toFirestore: toFirestore,
          );

  Future<List<ProviderModel>> getProviders() async {
    if (_firestore == null) throw StateError('Firebase Firestore no está inicializado.');
    final snapshot = await _providersCollection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<QuotationModel>> getQuotations() async {
    if (_firestore == null) throw StateError('Firebase Firestore no está inicializado.');
    final snapshot = await _firestore!.collection('quotations').get();
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
  }

  Stream<List<ProviderModel>> watchProviders() {
    if (_firestore == null) return Stream.error(StateError('Firebase Firestore no está inicializado.'));
    return _providersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> saveProvider(ProviderModel provider) => _providersCollection
      .doc(provider.id)
      .set(provider, SetOptions(merge: true));

  Future<void> saveUser(AuthUser user) => _firestore!.collection('users').doc(user.id).set({
        'name': user.name,
        'email': user.email,
        'role': user.role.name,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  Future<UserRole?> getUserRole(String userId) async {
    if (_firestore == null) return null;
    final document = await _firestore!.collection('users').doc(userId).get();
    final value = document.data()?['role'] as String?;
    for (final role in UserRole.values) {
      if (role.name == value) return role;
    }
    return null;
  }

  Future<void> saveProduct(ProductModel product) => _firestore!.collection('products')
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
      _firestore!.collection('quotations').doc(id).set({
        'provider': quotation.provider,
        'price': quotation.price,
        'deliveryDays': quotation.deliveryDays,
        'rating': quotation.rating,
        'distance': quotation.distance,
        'status': quotation.status,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  Future<void> saveMessage({required String chatId, required String senderId, required String text}) =>
      _firestore!.collection('chats').doc(chatId).collection('messages').add({
        'senderId': senderId,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> saveFavorite({required String userId, required String itemId, required String itemType}) =>
      _firestore!.collection('users').doc(userId).collection('favorites').doc(itemId).set({
        'itemId': itemId,
        'itemType': itemType,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> saveNotification({required String userId, required String title, required String message}) =>
      _firestore!.collection('users').doc(userId).collection('notifications').add({
        'title': title,
        'message': message,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

  // Helper para la colección de proveedores con su conversor.
  CollectionReference<ProviderModel> get _providersCollection =>
      _collection<ProviderModel>(
        'providers',
        fromFirestore: (snap, _) => ProviderModel.fromFirestore(snap, _),
        toFirestore: (provider, _) => provider.toFirestore(),
      );
}