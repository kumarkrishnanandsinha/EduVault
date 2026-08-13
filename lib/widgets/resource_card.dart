import 'package:flutter/material.dart';

import '../models/resource_model.dart';

class ResourceCard extends StatelessWidget {
  const ResourceCard({super.key, required this.resource, this.trailing});

  final ResourceModel resource;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            height: 136,
            child: Image.network(
              resource.thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(
                color: Color(0xFFEDE7F6),
                child: Icon(Icons.menu_book, size: 42),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('${resource.subject} • ${resource.category}'),
                  const SizedBox(height: 6),
                  Text(
                    resource.isFree
                        ? 'Free'
                        : '₹${resource.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: resource.isFree
                          ? Colors.green.shade700
                          : Colors.deepPurple,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(height: 6),
                    Align(alignment: Alignment.centerRight, child: trailing!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
