import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportService {
  // Export image bytes as JPEG or PNG file
  Future<String> exportImage(
    Uint8List imageBytes,
    String fileName,
    String format,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName.$format';

    final file = File(path);
    await file.writeAsBytes(imageBytes);
    return path;
  }

  // Convert image bytes to PDF and export
  Future<String> exportImageAsPdf(Uint8List imageBytes, String fileName) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(image));
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    return path;
  }
}
