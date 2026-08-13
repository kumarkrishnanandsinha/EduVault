import 'package:flutter/material.dart';

import 'my_uploads_screen.dart';
import 'upload_resource_screen.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seller Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.deepPurple.shade50,
            child: const Icon(Icons.store, size: 52, color: Colors.deepPurple),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome Seller 🚀',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your study resources here.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 55,
            child: FilledButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Resource'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UploadResourceScreen()),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 55,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.folder),
              label: const Text('My Uploads'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyUploadsScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
