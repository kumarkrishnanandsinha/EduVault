import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../seller/seller_dashboard_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("No User Found"),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

        final bool sellerMode = data["sellerMode"] ?? false;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                const CircleAvatar(
                  radius: 45,
                  child: Icon(Icons.person, size: 50),
                ),

                const SizedBox(height: 20),

                Text(
                  data["name"] ?? "",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(data["email"] ?? ""),

                const SizedBox(height: 20),

                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.school),
                        title: const Text("University"),
                        subtitle: Text(data["university"] ?? ""),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.menu_book),
                        title: const Text("Course"),
                        subtitle: Text(data["course"] ?? ""),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.class_),
                        title: const Text("Semester"),
                        subtitle: Text(data["semester"] ?? ""),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text("Phone"),
                        subtitle: Text(data["phone"] ?? ""),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Card(
                  child: SwitchListTile(
                    value: sellerMode,
                    title: const Text("Seller Mode"),
                    subtitle: const Text("Enable Seller Dashboard"),
                    secondary: const Icon(Icons.store),
                    onChanged: (value) async {
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .update({
                        "sellerMode": value,
                      });

                      if (value && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const SellerDashboardScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await auth.logout();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}