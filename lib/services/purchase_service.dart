import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/purchase_model.dart';
import '../models/resource_model.dart';

class PurchaseService {
  PurchaseService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Please sign in first.');
    return user.uid;
  }

  String purchaseId(String resourceId) => '${_uid}_$resourceId';

  Stream<bool> watchAccess(ResourceModel resource) {
    final user = _auth.currentUser;
    if (user?.uid == resource.sellerId) return Stream.value(true);
    if (user == null) return Stream.value(false);
    return _firestore
        .collection('purchases')
        .doc('${user.uid}_${resource.id}')
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<void> acquire(ResourceModel resource) async {
    final uid = _uid;
    if (uid == resource.sellerId) return;
    final purchaseRef = _firestore
        .collection('purchases')
        .doc('${uid}_${resource.id}');
    final resourceRef = _firestore.collection('resources').doc(resource.id);

    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(purchaseRef);
      if (existing.exists) return;
      transaction.set(
        purchaseRef,
        PurchaseModel(
          id: purchaseRef.id,
          buyerId: uid,
          sellerId: resource.sellerId,
          resourceId: resource.id,
          resourceTitle: resource.title,
          pdfUrl: resource.pdfUrl,
          thumbnailUrl: resource.thumbnailUrl,
          price: resource.isFree ? 0 : resource.price,
          purchasedAt: DateTime.now(),
        ).toMap(),
      );
      transaction.update(resourceRef, {'downloads': FieldValue.increment(1)});
    });
  }

  Stream<List<PurchaseModel>> watchMyLibrary() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(const []);
    return _firestore
        .collection('purchases')
        .where('buyerId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs.map(PurchaseModel.fromDocument).toList();
      items.sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));
      return items;
    });
  }
}
