import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel {
  const PurchaseModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.resourceId,
    required this.resourceTitle,
    required this.pdfUrl,
    required this.thumbnailUrl,
    required this.price,
    required this.purchasedAt,
  });

  final String id;
  final String buyerId;
  final String sellerId;
  final String resourceId;
  final String resourceTitle;
  final String pdfUrl;
  final String thumbnailUrl;
  final double price;
  final DateTime purchasedAt;

  factory PurchaseModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? <String, dynamic>{};
    final timestamp = data['purchasedAt'];
    return PurchaseModel(
      id: doc.id,
      buyerId: data['buyerId'] as String? ?? '',
      sellerId: data['sellerId'] as String? ?? '',
      resourceId: data['resourceId'] as String? ?? '',
      resourceTitle: data['resourceTitle'] as String? ?? '',
      pdfUrl: data['pdfUrl'] as String? ?? '',
      thumbnailUrl: data['thumbnailUrl'] as String? ?? '',
      price: (data['price'] as num? ?? 0).toDouble(),
      purchasedAt: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toMap() => {
    'buyerId': buyerId,
    'sellerId': sellerId,
    'resourceId': resourceId,
    'resourceTitle': resourceTitle,
    'pdfUrl': pdfUrl,
    'thumbnailUrl': thumbnailUrl,
    'price': price,
    'purchasedAt': Timestamp.fromDate(purchasedAt),
  };
}
