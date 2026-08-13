import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.indigo
                : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.indigo.shade100,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}