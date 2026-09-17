import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'package:zuperr/Models/Resume/resume_model.dart';


class ResumePdfGenerator {

  static Future<void> generate(ResumeModel resume) async {

    final pdf = pw.Document();


    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),

        build: (context) {

          return [

            pw.Text(
              resume.fullName,
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.Text(
              resume.jobTitle,
              style: const pw.TextStyle(
                fontSize: 18,
              ),
            ),

            pw.SizedBox(height: 10),

            pw.Text(resume.email),
            pw.Text(resume.phone),
            pw.Text(
              "${resume.city}, ${resume.state}, ${resume.country}",
            ),


            pw.Divider(),


            pw.Text(
              "Summary",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.Text(resume.summary),


            pw.SizedBox(height: 15),


            pw.Text(
              "Skills",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.Wrap(
              spacing: 5,
              children: resume.skills
                  .map(
                    (e)=> pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(e),
                    ),
                  )
                  .toList(),
            ),


            pw.SizedBox(height: 15),


            pw.Text(
              "Experience",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),


            ...resume.experiences.map(
              (e)=> pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

                  pw.Text(
                    e.designation,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.Text(e.company),

                  pw.Text(
                    "${e.startDate} - ${e.endDate}",
                  ),

                  pw.Text(e.description),

                  pw.SizedBox(height:10)
                ],
              ),
            ),



            pw.Text(
              "Education",
              style: pw.TextStyle(
                fontSize:18,
                fontWeight:pw.FontWeight.bold,
              ),
            ),


            ...resume.educations.map(
              (e)=> pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

                  pw.Text(
                    e.degree,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.Text(e.institute),

                  pw.Text(
                    "${e.startDate} - ${e.endDate}",
                  ),

                  pw.SizedBox(height:10)
                ],
              ),
            ),


          ];
        },
      ),
    );


    final directory = await getApplicationDocumentsDirectory();


    final file = File(
      "${directory.path}/${resume.fullName}_Resume.pdf",
    );


    await file.writeAsBytes(
      await pdf.save(),
    );


    // Open PDF
    await OpenFilex.open(file.path);

  }

}