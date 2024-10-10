import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../model.dart';
import '../theme.dart';

Future<pw.Document> buildPdfDocument(Trombi data) async {
  const maxHeight = 120.0;
  const maxWidth = 29.7 * PdfPageFormat.cm / 7;

  final logoAsset = await rootBundle.load('assets/fcpe.png');
  final logoBytes = logoAsset.buffer.asUint8List();
  pw.Image logo = pw.Image(pw.MemoryImage(logoBytes));

  final mailAsset = await rootBundle.load('assets/mail.png');
  final mailBytes = mailAsset.buffer.asUint8List();
  pw.Image mail = pw.Image(pw.MemoryImage(mailBytes));

  final noPhotoAsset = await rootBundle.load('assets/no-photo.png');
  final noPhotoBytes = noPhotoAsset.buffer.asUint8List();
  pw.Image noPhoto = pw.Image(pw.MemoryImage(noPhotoBytes));

  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      orientation: pw.PageOrientation.landscape,
      pageFormat: const PdfPageFormat(
        29.7 * PdfPageFormat.cm,
        21.7 * PdfPageFormat.cm,
        marginAll: 1.0 * PdfPageFormat.cm,
      ),
      margin: const pw.EdgeInsets.all(12),
      build: (pw.Context context) {
        var selectedYear = data.year;
        return pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Flexible(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Container(
                      alignment: pw.Alignment.center,
                      width: 140,
                      child: logo,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    data.schoolName,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(fcpeBlue.value),
                    ),
                  ),
                ),
                /* TODO(rxlabz) afficher le texte seul */
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.RichText(
                        text: pw.TextSpan(
                          text: 'Vos parents délégués FCPE ',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromInt(fcpeBlue.value),
                          ),
                          children: [
                            pw.TextSpan(
                              text: '$selectedYear-${selectedYear + 1}',
                              style: pw.TextStyle(
                                color: PdfColor.fromInt(fcpeGreen.value),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (data.groupName.isNotEmpty)
                        pw.Text(
                          data.groupName,
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromInt(fcpeBlue.value),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
            pw.Expanded(
              child: pw.Center(
                child: pw.Wrap(
                  runAlignment: pw.WrapAlignment.end,
                  alignment: pw.WrapAlignment.center,
                  children: [
                    for (final m in data.members.indexed)
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(
                            height: maxHeight,
                            width: maxWidth,
                            alignment: pw.Alignment.bottomCenter,
                            color: PdfColor.fromInt(
                              TrombiColor
                                  .refColors[
                                      m.$1 % TrombiColor.refColors.length]
                                  .lightColor
                                  .value,
                            ),
                            child: pw.Image(
                              pw.MemoryImage(m.$2.image ?? noPhotoBytes),
                              height: maxHeight,
                              width: maxWidth,
                            ),
                          ),
                          pw.Container(
                            height: maxHeight / 3,
                            width: maxWidth,
                            color: PdfColor.fromInt(
                              TrombiColor
                                  .refColors[
                                      m.$1 % TrombiColor.refColors.length]
                                  .color
                                  .value,
                            ),
                            child: pw.Column(
                              children: [
                                pw.Text(
                                  m.$2.name,
                                  style: pw.TextStyle(
                                    color: PdfColor.fromHex('#ffffff'),
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                pw.Text(
                                  m.$2.levels,
                                  style: pw.TextStyle(
                                    color: PdfColor.fromHex('#ffffff'),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            pw.Text(
              data.invite,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(fcpeGreen.value),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(18.0),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.center,
                    width: 50,
                    child: mail,
                    padding: const pw.EdgeInsets.only(right: 8),
                  ),
                  pw.Text(
                    data.contact,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(fcpeBlue.value),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
  return pdf;
}
