import 'package:flutter/material.dart';

class UploadResourceScreen extends StatefulWidget {
  const UploadResourceScreen({super.key});

  @override
  State<UploadResourceScreen> createState() =>
      _UploadResourceScreenState();
}

class _UploadResourceScreenState
    extends State<UploadResourceScreen> {

  final TextEditingController titleController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();

  final TextEditingController priceController =
  TextEditingController();

  String category = "Notes";
  bool isFree = false;

  final List<String> categories = [
    "Notes",
    "PYQs",
    "Books",
    "Assignments",
    "Quiz",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text("Upload Resource"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Resource Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: categories.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            SwitchListTile(
              value: isFree,
              title: const Text("Free Resource"),
              onChanged: (value) {
                setState(() {
                  isFree = value;
                });
              },
            ),

            const SizedBox(height: 10),

            if (!isFree)
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price (₹)",
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "PDF Picker Firebase phase me connect hoga.",
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Choose PDF"),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Submitted for Admin Approval ✅",
                      ),
                    ),
                  );
                },
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}