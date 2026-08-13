import 'package:flutter/material.dart';

class MarketplaceSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterPressed;

  const MarketplaceSearchBar({
    super.key,
    this.controller,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Search Notes, PYQs, Books...",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: onFilterPressed,
          icon: const Icon(Icons.tune),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}