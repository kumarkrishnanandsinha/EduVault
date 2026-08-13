import 'package:flutter/material.dart';

import '../../../models/resource_model.dart';
import '../resource_details_screen.dart';

class ResourceCard extends StatelessWidget {
  final ResourceModel resource;

  const ResourceCard({
    super.key,
    required this.resource,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.indigo.shade100,
              child: const Icon(
                Icons.picture_as_pdf,
                color: Colors.indigo,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    resource.sellerName,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(resource.rating.toString()),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  resource.isFree
                      ? "FREE"
                      : "₹${resource.price.toInt()}",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: resource.isFree
                        ? Colors.green
                        : Colors.indigo,
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResourceDetailsScreen(
                          resource: resource,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    resource.isFree ? "Open" : "Buy",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}