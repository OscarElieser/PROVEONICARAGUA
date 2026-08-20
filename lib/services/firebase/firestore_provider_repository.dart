import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../models/models.dart';

/// Acceso a proveedores en Firestore. La UI puede seguir usando el contrato
/// aunque el origen cambie entre Firestore y MockData.
class FirestoreProviderRepository {
  final FirebaseFirestore _firestore;

  FirestoreProviderRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ??
            FirebaseFirestore.instanceFor(
              app: Firebase.app(),
              databaseId: 'proveodb',
            );

  Future<List<ProviderModel>> fetchProviders() async {
    final snapshot = await _firestore.collection('providers').get();
    return snapshot.docs.map(_fromDocument).toList();
  }

  Future<void> saveProvider(ProviderModel provider) =>
      _firestore.collection('providers').doc(provider.id).set({
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
      });

  ProviderModel _fromDocument(
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
        reviews: data['reviews'] as int? ?? 0,
        years: data['years'] as int? ?? 0,
        responseTime: data['responseTime'] as String? ?? '',
        featured: data['featured'] as bool? ?? false);
  }
}
