import 'dart:typed_data';

import 'package:fcpe_trombi/model.dart';
import 'package:fcpe_trombi/pdf/pdf_factory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../pdf/web_pdf.dart' if (dart.library.io) '../pdf/io_pdf.dart';

const defaultInvite = "Échangez avec nous pour préparer les conseils d'école ! "
    "Une question que vous souhaitez partager ?\nBesoin d'aide sur un sujet ? "
    "Un témoignage à faire remonter ? Écrivez-nous...!";

const _gap = SizedBox(height: 16);

class FormController {
  Trombi get value => Trombi(
        schoolName: schoolName.text,
        groupName: groupName.text,
        year: year.value,
        members: members.value,
        invite: invite.text,
        contact: contact.text,
      );

  final schoolName = TextEditingController(
    text: 'Écoles élémentaire et maternelle Harmonie Rebatel',
  );

  final groupName = TextEditingController(text: 'Maternelle');

  final year = ValueNotifier<int>(DateTime.now().year);

  final members = ValueNotifier<List<Member>>([]);

  final invite = TextEditingController(
    text: defaultInvite,
  );

  final contact =
      TextEditingController(text: 'conseil.harmonie-rebatel@fcpe69.fr');

  void updateYear(int? newValue) => year.value = newValue!;

  void savePDF() async {
    final pdf = await buildPdfDocument(value);
    save(pdf);
  }

  void addMember(Member newMember) {
    members.value = [...members.value, newMember];
  }

  void updateMember(Member updatedMember, int index) {
    members.value = [
      ...members.value..replaceRange(index, index + 1, [updatedMember])
    ];
  }

  void removeMember(int index) {
    members.value = [...members.value..removeAt(index)];
  }
}

class FormView extends StatefulWidget {
  const FormView({super.key});

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 400,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Informations', icon: Icon(Icons.text_snippet)),
                Tab(text: 'Membres', icon: Icon(Icons.groups)),
              ],
            ),
            Expanded(
              child: TabBarView(children: [InfoForm(), MemberListForm()]),
            )
          ],
        ),
      ),
    );
  }
}

class InfoForm extends StatelessWidget {
  const InfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<FormController>();
    final currentYear = DateTime.now().year;
    final years = [currentYear - 1, currentYear, currentYear + 1];

    return SingleChildScrollView(
      child: Column(children: [
        _gap,
        TextFormField(
          maxLines: 4,
          decoration: const InputDecoration(label: Text('Nom de l\'école')),
          controller: controller.schoolName,
        ),
        _gap,
        TextFormField(
          maxLines: 2,
          decoration:
              const InputDecoration(label: Text('Nom de groupe ( optionnel )')),
          controller: controller.groupName,
        ),
        _gap,
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 18.0),
              child: Text('Année'),
            ),
            ValueListenableBuilder(
              valueListenable: controller.year,
              builder: (context, selectedYear, _) => DropdownButton<int>(
                value: selectedYear,
                items: years
                    .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                    .toList(),
                onChanged: controller.updateYear,
              ),
            ),
          ],
        ),
        _gap,
        TextFormField(
          maxLines: 8,
          decoration: const InputDecoration(
            label: Text('Invite'),
          ),
          controller: controller.invite,
        ),
        _gap,
        TextFormField(
          maxLines: 2,
          decoration: const InputDecoration(
            label: Text('Contact'),
          ),
          controller: controller.contact,
        ),
      ]),
    );
  }
}

class MemberListForm extends StatelessWidget {
  const MemberListForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<FormController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Membres'),
              TextButton.icon(
                onPressed: () async {
                  final newMember = await createMember(context);
                  if (newMember != null) {
                    controller.addMember(newMember);
                  }
                },
                label: const Text('Ajouter'),
                icon: const Icon(Icons.add),
              )
            ],
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: controller.members,
            builder: (context, members, _) => ListView(
              children: members.indexed.map(
                (m) {
                  final index = m.$1;
                  final member = m.$2;
                  return ListTile(
                    leading:
                        member.hasImage ? Image.memory(member.image!) : null,
                    title: Text(member.name),
                    subtitle: Text(member.levels),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final updatedMember =
                                await editMember(context, member);
                            if (updatedMember != null) {
                              controller.updateMember(updatedMember, index);
                            }
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            final confirmation = await showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: Text(
                                    "Confirmer la suppression de ${member.name}?",
                                  ),
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text(
                                        'Oui',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text(
                                        'Non',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                            if (confirmation == true) {
                              controller.removeMember(index);
                            }
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Future<Member?> createMember(BuildContext context) async {
    final member = await showDialog<Member>(
      context: context,
      builder: (context) => MemberDialog(
        controller: MemberDialogController(),
      ),
    );
    return member;
  }

  Future<Member?> editMember(BuildContext context, Member member) async {
    final updatedMember = await showDialog<Member>(
      context: context,
      builder: (context) => MemberDialog(
        controller: MemberDialogController(member),
      ),
    );
    return updatedMember;
  }
}

class MemberDialogController {
  final nameController = TextEditingController();
  final levelsController = TextEditingController();

  final picker = ImagePicker();

  final Member? member;

  MemberDialogController([this.member]) {
    nameController.text = member?.name ?? '';
    levelsController.text = member?.levels ?? '';
    imageBytes.value = member?.image;
  }

  ValueNotifier<Uint8List?> imageBytes = ValueNotifier(null);

  get newMember => nameController.text.isNotEmpty
      ? Member(
          name: nameController.text,
          levels: levelsController.text,
          image: imageBytes.value,
        )
      : null;

  void selectImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);

    imageBytes.value = await img?.readAsBytes();
  }
}

class MemberDialog extends StatelessWidget {
  final MemberDialogController controller;

  const MemberDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Nouveau membre'),
              ),
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  label: Text("Prénom du parent"),
                  border: OutlineInputBorder(),
                ),
              ),
              _gap,
              TextFormField(
                controller: controller.levelsController,
                decoration: const InputDecoration(
                  label: Text("Classe(s) de/des enfant(s)"),
                  border: OutlineInputBorder(),
                ),
              ),
              _gap,
              ValueListenableBuilder(
                  valueListenable: controller.imageBytes,
                  builder: (context, bytes, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (bytes != null)
                          Flexible(
                            child: Image.memory(bytes),
                          ),
                        ElevatedButton(
                          onPressed: controller.selectImage,
                          child: Text(
                              'Sélectionner une${bytes != null ? ' autre' : ''} image'),
                        )
                      ],
                    );
                  }),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final newMember = controller.newMember;
                      if (newMember == null) return;
                      Navigator.of(context).pop(newMember);
                    },
                    child: const Text('Enregistrer'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
