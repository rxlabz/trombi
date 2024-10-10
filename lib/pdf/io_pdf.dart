import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

void save(pw.Document pdf) async {
  var bytes = await pdf.save();
  final dir = await getApplicationDocumentsDirectory();

  final file = File('${dir.path}/${DateTime.now().toIso8601String()}.pdf')
    ..create();

  print('pdf path ${file.path}');

  await file.writeAsBytes(bytes);
}
