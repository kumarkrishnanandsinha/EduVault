import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DownloadService {
  Future<File> downloadPdf({
    required String url,
    required String resourceId,
  }) async {
    if (url.isEmpty) throw StateError('This resource has no PDF URL.');
    final directory = await getApplicationDocumentsDirectory();
    final folder = Directory('${directory.path}/eduvault');
    if (!await folder.exists()) await folder.create(recursive: true);
    final file = File('${folder.path}/$resourceId.pdf');
    if (await file.exists() && await file.length() > 0) return file;

    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('Download failed (${response.statusCode}).');
      }
      await response.pipe(file.openWrite());
      return file;
    } catch (_) {
      if (await file.exists()) await file.delete();
      rethrow;
    } finally {
      client.close();
    }
  }
}
