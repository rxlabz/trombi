import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';
import 'widgets/form_view.dart';
import 'widgets/pdf_preview.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      theme: theme,
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final formController = FormController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trombi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        leadingWidth: 0,
        backgroundColor: fcpeGreen,
      ),
      body: Provider.value(
        value: formController,
        child: Row(
          children: [
            const FormView(),
            Expanded(child: Preview(controller: formController)),
          ],
        ),
      ),
    );
  }
}

class Preview extends StatelessWidget {
  final FormController controller;

  const Preview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: controller.savePDF,
                  label: const Text('Exporter PDF'),
                  icon: const Icon(Icons.print),
                ),
                /*TextButton.icon(
                  onPressed: () {},
                  label: const Text('Enregistrer'),
                  icon: const Icon(Icons.save),
                ),*/
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Center(
                child: PDFPreview(
                  controller: controller,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
