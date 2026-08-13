import 'package:flutter/material.dart';
import 'upload_resource_screen.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text("Seller Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [

            SellerCard(
              icon: Icons.upload_file,
              title: "Upload",
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadResourceScreen(),
                  ),
                );
              },
            ),

            const SellerCard(
              icon: Icons.pending_actions,
              title: "Pending",
              color: Colors.orange,
            ),

            const SellerCard(
              icon: Icons.check_circle,
              title: "Approved",
              color: Colors.green,
            ),

            const SellerCard(
              icon: Icons.account_balance_wallet,
              title: "Earnings",
              color: Colors.purple,
            ),

            const SellerCard(
              icon: Icons.bar_chart,
              title: "Analytics",
              color: Colors.teal,
            ),

            const SellerCard(
              icon: Icons.settings,
              title: "Settings",
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class SellerCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const SellerCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(.15),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}