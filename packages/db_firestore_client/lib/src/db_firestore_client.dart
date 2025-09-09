import 'package:cloud_firestore/cloud_firestore.dart';

import 'common/core_typedefs.dart';
import 'db_firestore_client_base.dart';

class DbFirestoreClient implements DbFirestoreClientBase {
  DbFirestoreClient({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<void> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    CollectionReference<Map<String, dynamic>> collectionRef;
    collectionRef = _firestore.collection(collectionPath);

    await collectionRef.add(data);
  }

  @override
  Future<void> updateDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    DocumentReference<Map<String, dynamic>> docRef;
    docRef = _firestore.doc(collectionPath);

    await docRef.update(data);
  }

  @override
  Future<String> deleteDocument({
    required String collectionPath,
  }) async {
    DocumentReference<Map<String, dynamic>> docRef;
    docRef = _firestore.doc(collectionPath);
    await docRef.delete();

    return docRef.id;
  }

  @override
  Future<void> setDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    DocumentReference<Map<String, dynamic>> docRef;
    docRef = _firestore.collection(collectionPath).doc(documentId);

    await docRef.set(
      data,
      SetOptions(merge: merge),
    );
  }

  @override
  Future<T?> getDocument<T>({
    required String documentId,
    required String collectionPath,
    required ObjectMapper<T> objectMapper,
  }) async {
    DocumentReference<Map<String, dynamic>> docRef;
    docRef = _firestore.collection(collectionPath).doc(documentId);

    final snapshot = await docRef.get();
    final result = objectMapper(snapshot.data(), snapshot.id);

    return result;
  }

  @override
  Stream<T?> streamDocument<T>({
    required String collectionPath,
    required String documentId,
    required ObjectMapper<T> objectMapper,
  }) {
    DocumentReference<Map<String, dynamic>> docRef;

    docRef = _firestore.collection(collectionPath).doc(documentId);

    final snapshots = docRef.snapshots();
    final result = snapshots.map((doc) {
      if (doc.data() != null) {
        return objectMapper(doc.data()!, doc.id);
      } else {
        return null;
      }
    });

    return result;
  }

  @override
  Future<List<T>> getCollection<T>({
    required String collectionPath,
    required ObjectMapper<T> objectMapper,
  }) async {
    Query<Map<String, dynamic>> query;
    query = _firestore.collection(collectionPath);

    final snapshot = await query.get();
    final result = snapshot.docs
        .map((snapshots) => objectMapper(snapshots.data(), snapshots.id))
        .where((value) => value != null)
        .toList(growable: false);

    return result;
  }

  @override
  Stream<List<T>> streamCollection<T>({
    required String collectionPath,
    required ObjectMapper<T> objectMapper,
  }) {
    CollectionReference<Map<String, dynamic>> collectionRef;
    collectionRef = _firestore.collection(collectionPath);

    final snapshots = collectionRef.snapshots();

    final result = snapshots.map((snapshot) {
      return snapshot.docs
          .map((doc) => objectMapper(doc.data(), doc.id))
          .toList(growable: false);
    });

    return result;
  }

  @override
  Future<List<T>> getQuery<T>({
    required String collectionPath,
    required ObjectMapper<T> mapper,
    required String field,
    required dynamic isEqualTo,
  }) async {
    return _firestore
        .collection(collectionPath)
        .where(field, isEqualTo: isEqualTo)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => mapper(doc.data(), doc.id))
            .toList(growable: false));
  }

  @override
  Stream<List<T>> streamQuery<T>({
    required String collectionPath,
    required ObjectMapper<T> mapper,
    required String field,
    required dynamic isEqualTo,
  }) {
    return _firestore
        .collection(collectionPath)
        .where(field, isEqualTo: isEqualTo)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => mapper(doc.data(), doc.id))
            .toList(growable: false));
  }

  @override
  Stream<List<T>> streamCollectionOrderBy<T>({
    required String collectionPath,
    required ObjectMapper<T> objectMapper,
    required String orderByField,
    bool descending = false,
  }) {
    CollectionReference<Map<String, dynamic>> collectionRef;
    collectionRef = _firestore.collection(collectionPath);

    final snapshots =
        collectionRef.orderBy(orderByField, descending: descending).snapshots();

    final result = snapshots.map((snapshot) {
      return snapshot.docs
          .map((doc) => objectMapper(doc.data(), doc.id))
          .toList(growable: false);
    });

    return result;
  }

  @override
  Future<List<T>> getQueryOrderBy<T>({
    required String collectionPath,
    required ObjectMapper<T> mapper,
    required String field,
    required dynamic isEqualTo,
    required String orderByField,
    bool descending = false,
    int? limit,
  }) async {
    // Query đơn giản không cần index - chỉ lấy data và sắp xếp trong code
    final snapshot = await _firestore
        .collection(collectionPath)
        .where(field, isEqualTo: isEqualTo)
        .get();

    // Chuyển đổi thành list
    final docs = snapshot.docs;

    // Sắp xếp trong code
    docs.sort((a, b) {
      final aValue = a.data()[orderByField];
      final bValue = b.data()[orderByField];

      if (aValue == null || bValue == null) return 0;

      int comparison = 0;
      if (aValue is num && bValue is num) {
        comparison = aValue.compareTo(bValue);
      } else if (aValue is String && bValue is String) {
        comparison = aValue.compareTo(bValue);
      } else if (aValue is DateTime && bValue is DateTime) {
        comparison = aValue.compareTo(bValue);
      }

      return descending ? -comparison : comparison;
    });

    // Map thành List<T>
    final result =
        docs.map((doc) => mapper(doc.data(), doc.id)).toList(growable: false);

    return limit != null ? result.take(limit).toList() : result;
  }

  @override
  Stream<List<T>> streamQueryOrderBy<T>({
    required String collectionPath,
    required ObjectMapper<T> mapper,
    required String field,
    required dynamic isEqualTo,
    required String orderByField,
    bool descending = false,
  }) {
    return _firestore
        .collection(collectionPath)
        .where(field, isEqualTo: isEqualTo)
        .orderBy(orderByField, descending: descending)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => mapper(doc.data(), doc.id))
            .toList(growable: false));
  }
}
