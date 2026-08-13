import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/upload_service.dart';

class UploadResourceScreen extends StatefulWidget {
  const UploadResourceScreen({super.key});

  @override
  State<UploadResourceScreen> createState() => _UploadResourceScreenState();
}

class _UploadResourceScreenState extends State<UploadResourceScreen> {
  final UploadService uploadService = UploadService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final subjectController = TextEditingController();

  File? pdfFile;
  File? imageFile;

  bool loading = false;
  bool isFree = true;

  String category = "Notes";

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  Future<void> pickPdf() async {
    final file = await uploadService.pickPdf();

    if (file == null) return;

    setState(() {
      pdfFile = file;
    });
  }

  Future<void> pickImage() async {
    final file = await uploadService.pickImage();

    if (file == null) return;

    setState(() {
      imageFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: "Subject",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Notes",
                  child: Text("Notes"),
                ),
                DropdownMenuItem(
                  value: "PYQs",
                  child: Text("PYQs"),
                ),
                DropdownMenuItem(
                  value: "Books",
                  child: Text("Books"),
                ),
                DropdownMenuItem(
                  value: "Assignments",
                  child: Text("Assignments"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 20),

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

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: pickPdf,
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(
                  pdfFile == null
                      ? "Select PDF"
                      : "PDF Selected ✅",
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: Text(
                  imageFile == null
                      ? "Select Thumbnail"
                      : "Image Selected ✅",
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: loading ? null : () {},
                icon: const Icon(Icons.cloud_upload),
                label: Text(
                  loading
                      ? "Uploading..."
                      : "Upload Resource",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}