import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/resource_model.dart';
import '../../widgets/resource_card.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Marketplace')),
    body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('resources')
          .where('approved', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(
              'Could not load marketplace.\n${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final resources =
        snapshot.data!.docs.map(ResourceModel.fromDocument).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        if (resources.isEmpty)
          return const Center(child: Text('No resources are available yet.'));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: resources.length,
          itemBuilder: (_, i) => ResourceCard(resource: resources[i]),
        );
      },
    ),
  );
}
