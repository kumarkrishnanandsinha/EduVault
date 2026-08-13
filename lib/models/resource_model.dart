class ResourceModel {
  final String id;
  final String title;
  final String description;

  final String university;
  final String course;
  final String semester;
  final String subject;

  final String category;

  final String sellerId;
  final String sellerName;

  final double price;
  final bool isFree;

  final double rating;
  final int totalRatings;
  final int downloads;

  final String fileUrl;
  final String thumbnailUrl;

  final bool isApproved;

  const ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.university,
    required this.course,
    required this.semester,
    required this.subject,
    required this.category,
    required this.sellerId,
    required this.sellerName,
    required this.price,
    required this.isFree,
    required this.rating,
    required this.totalRatings,
    required this.downloads,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.isApproved,
  });
}