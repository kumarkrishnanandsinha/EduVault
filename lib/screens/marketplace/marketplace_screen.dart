import 'package:flutter/material.dart';

import '../../models/resource_model.dart';
import '../../services/upload_service.dart';
import '../../widgets/resource_card.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace')),
      body: StreamBuilder<List<ResourceModel>>(
        stream: UploadService().watchMarketplace(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load the marketplace.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final resources = snapshot.data ?? const <ResourceModel>[];
          if (resources.isEmpty) {
            return const Center(child: Text('No resources are available yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: resources.length,
            itemBuilder: (_, index) => ResourceCard(resource: resources[index]),
          );
        },
      ),
    );
  }
}
