import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceModel {
  final String id;
  final String title;
  final String description;
  final String subject;
  final String category;
  final String sellerId;
  final String sellerName;
  final String pdfUrl;
  final String thumbnailUrl;
  final bool isFree;
  final double price;
  final int downloads;
  final double rating;
  final int totalRatings;
  final bool approved;
  final DateTime createdAt;

  const ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.category,
    required this.sellerId,
    required this.sellerName,
    required this.pdfUrl,
    required this.thumbnailUrl,
    required this.isFree,
    required this.price,
    required this.downloads,
    required this.rating,
    required this.totalRatings,
    required this.approved,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'category': category,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'pdfUrl': pdfUrl,
      'thumbnailUrl': thumbnailUrl,
      'isFree': isFree,
      'price': price,
      'downloads': downloads,
      'rating': rating,
      'totalRatings': totalRatings,
      'approved': approved,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ResourceModel.fromMap(Map<String, dynamic> map) {
    final rawCreatedAt = map['createdAt'];
    DateTime createdAt;
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(rawCreatedAt);
    } else {
      createdAt = DateTime.fromMillisecondsSinceEpoch(0);
    }

    return ResourceModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      category: map['category'] as String? ?? '',
      sellerId: map['sellerId'] as String? ?? '',
      sellerName: map['sellerName'] as String? ?? 'Unknown seller',
      pdfUrl: map['pdfUrl'] as String? ?? '',
      thumbnailUrl: map['thumbnailUrl'] as String? ?? '',
      isFree: map['isFree'] as bool? ?? true,
      price: (map['price'] as num? ?? 0).toDouble(),
      downloads: (map['downloads'] as num? ?? 0).toInt(),
      rating: (map['rating'] as num? ?? 0).toDouble(),
      totalRatings: (map['totalRatings'] as num? ?? 0).toInt(),
      approved: map['approved'] as bool? ?? false,
      createdAt: createdAt,
    );
  }

  factory ResourceModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) {
    final data = document.data() ?? <String, dynamic>{};
    return ResourceModel.fromMap({...data, 'id': data['id'] ?? document.id});
  }
}
