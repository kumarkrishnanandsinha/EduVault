import 'package:flutter/material.dart';

import '../../models/resource_model.dart';
import '../../services/download_service.dart';
import '../../widgets/buy_button.dart';
import '../library/pdf_viewer_screen.dart';

class ResourceDetailsScreen extends StatefulWidget {
  const ResourceDetailsScreen({super.key, required this.resource});
  final ResourceModel resource;
  @override
  State<ResourceDetailsScreen> createState() => _ResourceDetailsScreenState();
}

class _ResourceDetailsScreenState extends State<ResourceDetailsScreen> {
  bool _opening = false;
  Future<void> _open() async {
    setState(() => _opening = true);
    try {
      final file = await DownloadService().downloadPdf(
        url: widget.resource.pdfUrl,
        resourceId: widget.resource.id,
      );
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PdfViewerScreen(file: file, title: widget.resource.title),
        ),
      );
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.resource;
    return Scaffold(
      appBar: AppBar(title: const Text('Resource details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                r.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Color(0xffede7f6),
                  child: Icon(Icons.menu_book, size: 64),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            r.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('${r.subject} • ${r.category}'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            children: [
              Text('⭐ ${r.rating.toStringAsFixed(1)} (${r.totalRatings})'),
              Text('⬇ ${r.downloads}'),
              Text('By ${r.sellerName}'),
            ],
          ),
          const SizedBox(height: 20),
          Text(r.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 28),
          if (_opening)
            const Center(child: CircularProgressIndicator())
          else
            BuyButton(resource: r, onAccessGranted: _open),
        ],
      ),
    );
  }
}
