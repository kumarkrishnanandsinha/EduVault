import 'package:flutter/material.dart';

import '../../services/dummy_data.dart';
import 'widgets/category_chip.dart';
import 'widgets/resource_card.dart';
import 'widgets/search_bar.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text("Marketplace"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const MarketplaceSearchBar(),

            const SizedBox(height: 25),

            const Text(
              "Categories",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryChip(title: "All", isSelected: true),
                  CategoryChip(title: "Notes"),
                  CategoryChip(title: "PYQs"),
                  CategoryChip(title: "Books"),
                  CategoryChip(title: "Assignments"),
                  CategoryChip(title: "Quiz"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Trending Resources",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: DummyData.resources.length,
                itemBuilder: (context, index) {
                  return ResourceCard(
                    resource: DummyData.resources[index],
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}