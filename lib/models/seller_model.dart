class SellerModel {
  final String id;
  final String name;
  final String profileImage;

  final double rating;
  final int totalSales;
  final int totalResources;

  const SellerModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.rating,
    required this.totalSales,
    required this.totalResources,
  });
}