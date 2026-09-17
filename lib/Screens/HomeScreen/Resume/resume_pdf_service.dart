import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:zuperr/Models/Resume/resume_model.dart';

class ResumePdfService {
  static Future<File> generate(ResumeModel resume) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                resume.fullName,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(resume.jobTitle),
              pw.SizedBox(height: 10),
              pw.Text(resume.email),
              pw.Text(resume.phone),
              pw.Text(
                '${resume.city}, ${resume.state}, ${resume.country}',
              ),

              pw.Divider(),

              pw.Text(
                'Summary',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(resume.summary),

              pw.SizedBox(height: 16),

              pw.Text(
                'Skills',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Wrap(
                spacing: 8,
                runSpacing: 8,
                children: resume.skills
                    .map((e) => pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(),
                            borderRadius: pw.BorderRadius.circular(6),
                          ),
                          child: pw.Text(e),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/resume.pdf');

    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static Future<void> printPdf(ResumeModel resume) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Text(resume.fullName),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}