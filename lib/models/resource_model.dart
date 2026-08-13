import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceModel {
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
  final bool approved;

  final double price;
  final double rating;

  final int downloads;
  final int totalRatings;

  final DateTime createdAt;

  factory ResourceModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final m = doc.data() ?? <String, dynamic>{};

    final created = m['createdAt'];

    return ResourceModel(
      id: m['id'] as String? ?? doc.id,
      title: m['title'] as String? ?? '',
      description: m['description'] as String? ?? '',
      subject: m['subject'] as String? ?? '',
      category: m['category'] as String? ?? '',
      sellerId: m['sellerId'] as String? ?? '',
      sellerName: m['sellerName'] as String? ?? 'Unknown seller',
      pdfUrl: m['pdfUrl'] as String? ?? '',
      thumbnailUrl: m['thumbnailUrl'] as String? ?? '',
      isFree: m['isFree'] as bool? ?? true,
      price: (m['price'] as num? ?? 0).toDouble(),
      downloads: (m['downloads'] as num? ?? 0).toInt(),
      rating: (m['rating'] as num? ?? 0).toDouble(),
      totalRatings: (m['totalRatings'] as num? ?? 0).toInt(),
      approved: m['approved'] as bool? ?? false,
      createdAt: created is Timestamp
          ? created.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

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
}