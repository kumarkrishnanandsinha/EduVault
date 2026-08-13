import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final auth = AuthService();

  final nameController = TextEditingController();
  final universityController = TextEditingController();
  final courseController = TextEditingController();
  final semesterController = TextEditingController();
  final phoneController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = auth.currentUser!;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final data = doc.data()!;

    nameController.text = data["name"] ?? "";
    universityController.text = data["university"] ?? "";
    courseController.text = data["course"] ?? "";
    semesterController.text = data["semester"] ?? "";
    phoneController.text = data["phone"] ?? "";

    setState(() {
      loading = false;
    });
  }

  Future<void> saveProfile() async {
    final user = auth.currentUser!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({
      "name": nameController.text.trim(),
      "university": universityController.text.trim(),
      "course": courseController.text.trim(),
      "semester": semesterController.text.trim(),
      "phone": phoneController.text.trim(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Updated"),
      ),
    );

    Navigator.pop(context);
  }

  Widget field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            field("Name", nameController),
            field("University", universityController),
            field("Course", courseController),
            field("Semester", semesterController),
            field("Phone", phoneController),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveProfile,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}