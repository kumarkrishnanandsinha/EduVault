class PurchaseModel {
  final String id;
  final String userId;
  final String resourceId;

  final DateTime purchaseDate;

  const PurchaseModel({
    required this.id,
    required this.userId,
    required this.resourceId,
    required this.purchaseDate,
  });
}