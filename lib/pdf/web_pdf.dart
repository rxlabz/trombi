import 'dart:convert';

import 'package:pdf/widgets.dart' as pw;
import 'package:web/web.dart' as web;

void save(pw.Document pdf) async {
  var savedFile = await pdf.save();
  List<int> fileInts = List.from(savedFile);
  web.HTMLAnchorElement()
    ..href =
        "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}"
    ..setAttribute("download", "${DateTime.now().millisecondsSinceEpoch}.pdf")
    ..click();
}
