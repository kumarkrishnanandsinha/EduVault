import 'package:flutter/material.dart';

import '../../models/purchase_model.dart';
import '../../services/download_service.dart';
import '../../services/purchase_service.dart';
import 'pdf_viewer_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _purchases = PurchaseService();
  final _downloads = DownloadService();
  String? _openingId;

  Future<void> _open(PurchaseModel purchase) async {
    setState(() => _openingId = purchase.id);
    try {
      final file = await _downloads.downloadPdf(
        url: purchase.pdfUrl,
        resourceId: purchase.resourceId,
      );
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PdfViewerScreen(file: file, title: purchase.resourceTitle),
        ),
      );
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
    } finally {
      if (mounted) setState(() => _openingId = null);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My Library')),
    body: StreamBuilder<List<PurchaseModel>>(
      stream: _purchases.watchMyLibrary(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(
              'Could not load library.\n${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final items = snapshot.data!;
        if (items.isEmpty)
          return const Center(child: Text('Your library is empty.'));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (_, index) {
            final item = items[index];
            return Card(
              child: ListTile(
                leading: item.thumbnailUrl.isEmpty
                    ? const CircleAvatar(child: Icon(Icons.picture_as_pdf))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.thumbnailUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(item.resourceTitle),
                subtitle: Text(
                  item.price == 0
                      ? 'Free'
                      : 'Purchased for ₹${item.price.toStringAsFixed(0)}',
                ),
                trailing: _openingId == item.id
                    ? const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.menu_book_outlined),
                onTap: _openingId == null ? () => _open(item) : null,
              ),
            );
          },
        );
      },
    ),
  );
}
