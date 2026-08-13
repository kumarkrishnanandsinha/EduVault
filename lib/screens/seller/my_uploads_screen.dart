import 'package:flutter/material.dart';

import '../../models/resource_model.dart';
import '../../services/upload_service.dart';
import '../../widgets/resource_card.dart';

class MyUploadsScreen extends StatelessWidget {
  const MyUploadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = UploadService();
    return Scaffold(
      appBar: AppBar(title: const Text('My Uploads')),
      body: StreamBuilder<List<ResourceModel>>(
        stream: service.watchMyUploads(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return _ErrorState(error: snapshot.error!);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final resources = snapshot.data ?? const <ResourceModel>[];
          if (resources.isEmpty) {
            return const _EmptyState(
              icon: Icons.cloud_upload_outlined,
              title: 'No uploads yet',
              message: 'Your uploaded resources will appear here.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: resources.length,
            itemBuilder: (context, index) {
              final resource = resources[index];
              return ResourceCard(
                resource: resource,
                trailing: IconButton(
                  tooltip: 'Delete resource',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context, service, resource),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context,
      UploadService service,
      ResourceModel resource,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete resource?'),
        content: Text(
          '“${resource.title}” and its uploaded files will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await service.deleteResource(resource);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Resource deleted.')));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Colors.deepPurple.shade200),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});
  final Object error;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Could not load uploads.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
