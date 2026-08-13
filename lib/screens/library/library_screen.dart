import 'package:flutter/material.dart';

import '../../services/purchase_service.dart';
import '../marketplace/resource_details_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = PurchaseService.purchasedResources;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text("My Library"),
      ),

      body: resources.isEmpty
          ? const Center(
        child: Text(
          "No Purchased Resources Yet",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo.shade100,
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.indigo,
                ),
              ),
              title: Text(resource.title),
              subtitle: Text(resource.subject),
              trailing: ElevatedButton(
                child: const Text("Open"),
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
              ),
            ),
          );
        },
      ),
    );
  }
}