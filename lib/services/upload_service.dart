import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (result == null) return null;

    return File(result.files.single.path!);
  }

  Future<File?> pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return null;

    return File(image.path);
  }

  Future<String> uploadPdf(File file) async {
    final id = const Uuid().v4();

    final ref = _storage.ref("resources/pdfs/$id.pdf");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  Future<String> uploadImage(File file) async {
    final id = const Uuid().v4();

    final ref = _storage.ref("resources/images/$id.jpg");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }
}