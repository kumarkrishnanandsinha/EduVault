import 'package:flutter/material.dart';

import '../models/resource_model.dart';
import '../services/purchase_service.dart';

class BuyButton extends StatefulWidget {
  const BuyButton({
    super.key,
    required this.resource,
    required this.onAccessGranted,
  });
  final ResourceModel resource;
  final VoidCallback onAccessGranted;
  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  final _service = PurchaseService();
  bool _busy = false;

  Future<void> _acquire() async {
    if (!widget.resource.isFree) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm purchase'),
          content: Text(
            'Buy “${widget.resource.title}” for ₹${widget.resource.price.toStringAsFixed(0)}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Buy'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    setState(() => _busy = true);
    try {
      await _service.acquire(widget.resource);
      if (mounted) widget.onAccessGranted();
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
    stream: _service.watchAccess(widget.resource),
    builder: (context, snapshot) {
      final hasAccess = snapshot.data ?? false;
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          onPressed: _busy
              ? null
              : hasAccess
              ? widget.onAccessGranted
              : _acquire,
          icon: _busy
              ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Icon(
            hasAccess
                ? Icons.menu_book
                : widget.resource.isFree
                ? Icons.download
                : Icons.shopping_cart,
          ),
          label: Text(
            hasAccess
                ? 'Open resource'
                : widget.resource.isFree
                ? 'Get free resource'
                : 'Buy for ₹${widget.resource.price.toStringAsFixed(0)}',
          ),
        ),
      );
    },
  );
}
