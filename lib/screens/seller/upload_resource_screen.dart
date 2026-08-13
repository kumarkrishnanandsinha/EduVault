import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../services/upload_service.dart';

class UploadResourceScreen extends StatefulWidget {
  const UploadResourceScreen({super.key});

  @override
  State<UploadResourceScreen> createState() => _UploadResourceScreenState();
}

class _UploadResourceScreenState extends State<UploadResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = UploadService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subjectController = TextEditingController();
  final _priceController = TextEditingController();

  File? _pdfFile;
  File? _imageFile;
  bool _isFree = true;
  bool _isUploading = false;
  double _progress = 0;
  String _category = 'Notes';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subjectController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickPdf() async {
    try {
      final file = await _service.pickPdf();
      if (file != null && mounted) setState(() => _pdfFile = file);
    } catch (error) {
      _showError(_messageFor(error));
    }
  }

  Future<void> _pickImage() async {
    try {
      final file = await _service.pickImage();
      if (file != null && mounted) setState(() => _imageFile = file);
    } catch (error) {
      _showError(_messageFor(error));
    }
  }

  Future<void> _upload() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (_pdfFile == null) {
      _showError('Please select a PDF file.');
      return;
    }
    if (_imageFile == null) {
      _showError('Please select a thumbnail image.');
      return;
    }

    final price = _isFree ? 0.0 : double.parse(_priceController.text.trim());
    setState(() {
      _isUploading = true;
      _progress = 0;
    });

    try {
      await _service.uploadResource(
        title: _titleController.text,
        description: _descriptionController.text,
        subject: _subjectController.text,
        category: _category,
        isFree: _isFree,
        price: price,
        pdfFile: _pdfFile!,
        thumbnailFile: _imageFile!,
        onProgress: (value) {
          if (mounted) setState(() => _progress = value);
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resource uploaded successfully.')),
      );
      Navigator.pop(context, true);
    } catch (error) {
      if (mounted) _showError(_messageFor(error));
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  String _messageFor(Object error) {
    if (error is FirebaseException) {
      if (error.code == 'unauthorized' || error.code == 'permission-denied') {
        return 'Firebase permission denied. Check your Storage and Firestore rules.';
      }
      return error.message ?? 'Firebase upload failed. Please try again.';
    }
    return error.toString().replaceFirst('Bad state: ', '');
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isUploading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Upload Resource')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _titleController,
                enabled: !_isUploading,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _required(value, 'Enter a title.'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                enabled: !_isUploading,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _required(value, 'Enter a description.'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subjectController,
                enabled: !_isUploading,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _required(value, 'Enter a subject.'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const ['Notes', 'PYQs', 'Books', 'Assignments']
                    .map(
                      (item) =>
                      DropdownMenuItem(value: item, child: Text(item)),
                )
                    .toList(),
                onChanged: _isUploading
                    ? null
                    : (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Free Resource'),
                subtitle: Text(
                  _isFree
                      ? 'Everyone can access it for free'
                      : 'Set a selling price',
                ),
                value: _isFree,
                onChanged: _isUploading
                    ? null
                    : (value) => setState(() {
                  _isFree = value;
                  if (value) _priceController.clear();
                }),
              ),
              if (!_isFree) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  enabled: !_isUploading,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_isFree) return null;
                    final price = double.tryParse(value?.trim() ?? '');
                    return price == null || price <= 0
                        ? 'Enter a valid price.'
                        : null;
                  },
                ),
              ],
              const SizedBox(height: 18),
              _FileButton(
                icon: Icons.picture_as_pdf,
                label: _pdfFile == null
                    ? 'Select PDF'
                    : _pdfFile!.path.split('/').last,
                selected: _pdfFile != null,
                onPressed: _isUploading ? null : _pickPdf,
              ),
              const SizedBox(height: 12),
              _FileButton(
                icon: Icons.image,
                label: _imageFile == null
                    ? 'Select Thumbnail'
                    : _imageFile!.path.split('/').last,
                selected: _imageFile != null,
                onPressed: _isUploading ? null : _pickImage,
              ),
              if (_imageFile != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _imageFile!,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              if (_isUploading) ...[
                const SizedBox(height: 24),
                LinearProgressIndicator(
                  value: _progress == 0 ? null : _progress,
                ),
                const SizedBox(height: 8),
                Text(
                  _progress == 0
                      ? 'Preparing upload…'
                      : 'Uploading ${(_progress * 100).round()}%',
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 28),
              SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: _isUploading ? null : _upload,
                  icon: const Icon(Icons.cloud_upload),
                  label: Text(_isUploading ? 'Uploading…' : 'Upload Resource'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value, String message) {
    return value == null || value.trim().isEmpty ? message : null;
  }
}

class _FileButton extends StatelessWidget {
  const _FileButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(selected ? Icons.check_circle : icon),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
