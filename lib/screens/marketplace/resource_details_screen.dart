import 'package:flutter/material.dart';

import '../../models/resource_model.dart';
import '../../services/purchase_service.dart';

class ResourceDetailsScreen extends StatefulWidget {
  final ResourceModel resource;

  const ResourceDetailsScreen({
    super.key,
    required this.resource,
  });

  @override
  State<ResourceDetailsScreen> createState() =>
      _ResourceDetailsScreenState();
}

class _ResourceDetailsScreenState
    extends State<ResourceDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    final purchased =
    PurchaseService.isPurchased(widget.resource);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text("Resource Details"),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: () {

                if (!purchased) {

                  PurchaseService.purchase(widget.resource);

                  setState(() {});

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Resource Purchased Successfully 🎉",
                      ),
                    ),
                  );

                } else {

                  Navigator.pop(context);

                }
              },

              child: Text(
                purchased
                    ? "Open in Library"
                    : widget.resource.isFree
                    ? "Download Free"
                    : "Buy for ₹${widget.resource.price.toInt()}",
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                size: 90,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.resource.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),

                const SizedBox(width: 5),

                Text(widget.resource.rating.toString()),

                const Spacer(),

                Text(
                  widget.resource.isFree
                      ? "FREE"
                      : "₹${widget.resource.price.toInt()}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(widget.resource.sellerName),
              subtitle: const Text("Verified Seller"),
            ),

            const Divider(),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.resource.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Includes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const ListTile(
              leading: Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              title: Text("High Quality PDF"),
            ),

            const ListTile(
              leading: Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              title: Text("Instant Access"),
            ),

            const ListTile(
              leading: Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              title: Text("Lifetime Access"),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}