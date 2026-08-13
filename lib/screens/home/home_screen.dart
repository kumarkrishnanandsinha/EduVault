import 'package:flutter/material.dart';

import '../../services/dummy_data.dart';

import 'widgets/greeting_card.dart';
import 'widgets/quick_access_card.dart';
import 'widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text("EduVault"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            GreetingCard(
              userName: user.name,
            ),

            const SizedBox(height: 30),

            const SectionTitle(
              title: "Quick Access",
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                QuickAccessCard(
                  icon: Icons.description,
                  title: "Notes",
                  color: Colors.blue,
                  onTap: () {},
                ),

                const SizedBox(width: 15),

                QuickAccessCard(
                  icon: Icons.assignment,
                  title: "PYQs",
                  color: Colors.orange,
                  onTap: () {},
                ),

              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                QuickAccessCard(
                  icon: Icons.menu_book,
                  title: "Books",
                  color: Colors.green,
                  onTap: () {},
                ),

                const SizedBox(width: 15),

                QuickAccessCard(
                  icon: Icons.quiz,
                  title: "Quiz",
                  color: Colors.purple,
                  onTap: () {},
                ),

              ],
            ),

            const SizedBox(height: 30),

            const SectionTitle(
              title: "Recent Activity",
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.history),
                ),
                title: const Text("No recent activity"),
                subtitle: const Text(
                  "Purchase resources from Marketplace.",
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {},
              ),
            ),

          ],
        ),
      ),
    );
  }
}