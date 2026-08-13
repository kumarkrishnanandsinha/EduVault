import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/resource_model.dart';

typedef UploadProgressCallback = void Function(double progress);

class UploadService {
  UploadService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    ImagePicker? imagePicker,
  }) : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _imagePicker = imagePicker ?? ImagePicker();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final ImagePicker _imagePicker;

  Future<File?> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
      allowMultiple: false,
      withData: false,
    );
    final path = result?.files.single.path;
    return path == null ? null : File(path);
  }

  Future<File?> pickImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1600,
    );
    return image == null ? null : File(image.path);
  }

  Stream<List<ResourceModel>> watchMyUploads() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(const <ResourceModel>[]);

    return _firestore
        .collection('resources')
        .where('sellerId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      final resources = snapshot.docs
          .map(ResourceModel.fromDocument)
          .toList();
      resources.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return resources;
    });
  }

  Stream<List<ResourceModel>> watchMarketplace() {
    return _firestore
        .collection('resources')
        .where('approved', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final resources = snapshot.docs
          .map(ResourceModel.fromDocument)
          .toList();
      resources.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return resources;
    });
  }

  Future<ResourceModel> uploadResource({
    required String title,
    required String description,
    required String subject,
    required String category,
    required bool isFree,
    required double price,
    required File pdfFile,
    required File thumbnailFile,
    UploadProgressCallback? onProgress,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Please sign in before uploading.');

    final resourceId = const Uuid().v4();
    final pdfRef = _storage.ref(
      'resources/${user.uid}/$resourceId/resource.pdf',
    );
    final imageRef = _storage.ref(
      'resources/${user.uid}/$resourceId/thumbnail.jpg',
    );

    var pdfUploaded = false;
    var imageUploaded = false;

    try {
      final pdfUrl = await _uploadFile(
        ref: pdfRef,
        file: pdfFile,
        contentType: 'application/pdf',
        onProgress: (value) => onProgress?.call(value * .75),
      );
      pdfUploaded = true;

      final thumbnailUrl = await _uploadFile(
        ref: imageRef,
        file: thumbnailFile,
        contentType: 'image/jpeg',
        onProgress: (value) => onProgress?.call(.75 + (value * .20)),
      );
      imageUploaded = true;

      final sellerName = await _sellerName(user);
      final resource = ResourceModel(
        id: resourceId,
        title: title.trim(),
        description: description.trim(),
        subject: subject.trim(),
        category: category,
        sellerId: user.uid,
        sellerName: sellerName,
        pdfUrl: pdfUrl,
        thumbnailUrl: thumbnailUrl,
        isFree: isFree,
        price: isFree ? 0 : price,
        downloads: 0,
        rating: 0,
        totalRatings: 0,
        approved: true,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('resources')
          .doc(resourceId)
          .set(resource.toMap());
      onProgress?.call(1);
      return resource;
    } catch (_) {
      if (imageUploaded) await _safeDelete(imageRef);
      if (pdfUploaded) await _safeDelete(pdfRef);
      rethrow;
    }
  }

  Future<void> deleteResource(ResourceModel resource) async {
    final user = _auth.currentUser;
    if (user == null || user.uid != resource.sellerId) {
      throw StateError('You can only delete your own uploads.');
    }

    await _firestore.collection('resources').doc(resource.id).delete();
    await Future.wait([
      _safeDelete(_storage.refFromURL(resource.pdfUrl)),
      _safeDelete(_storage.refFromURL(resource.thumbnailUrl)),
    ]);
  }

  Future<String> _uploadFile({
    required Reference ref,
    required File file,
    required String contentType,
    required UploadProgressCallback onProgress,
  }) async {
    final task = ref.putFile(file, SettableMetadata(contentType: contentType));
    task.snapshotEvents.listen((snapshot) {
      if (snapshot.totalBytes > 0) {
        onProgress(snapshot.bytesTransferred / snapshot.totalBytes);
      }
    });
    await task;
    return ref.getDownloadURL();
  }

  Future<String> _sellerName(User user) async {
    final profile = await _firestore.collection('users').doc(user.uid).get();
    final data = profile.data();
    final name = data?['name'] ?? data?['fullName'] ?? data?['displayName'];
    if (name is String && name.trim().isNotEmpty) return name.trim();
    if (user.displayName?.trim().isNotEmpty == true)
      return user.displayName!.trim();
    return user.email?.split('@').first ?? 'EduVault Seller';
  }

  Future<void> _safeDelete(Reference ref) async {
    try {
      await ref.delete();
    } on FirebaseException catch (error) {
      if (error.code != 'object-not-found') rethrow;
    }
  }
}
