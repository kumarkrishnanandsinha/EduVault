import '../models/resource_model.dart';

class PurchaseService {
  static final List<ResourceModel> _purchasedResources = [];

  static List<ResourceModel> get purchasedResources =>
      List.unmodifiable(_purchasedResources);

  static bool isPurchased(ResourceModel resource) {
    return _purchasedResources.any((e) => e.id == resource.id);
  }

  static void purchase(ResourceModel resource) {
    if (!isPurchased(resource)) {
      _purchasedResources.add(resource);
    }
  }
}