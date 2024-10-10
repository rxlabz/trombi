import 'package:fcpe_trombi/theme.dart';
import 'package:fcpe_trombi/widgets/form_view.dart';
import 'package:flutter/material.dart';

class PDFPreview extends StatelessWidget {
  final FormController controller;

  const PDFPreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.41428,
      child: LayoutBuilder(builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        final scale = maxWidth / 1290;

        return Container(
          padding: EdgeInsets.all(18 * scale),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 5, spreadRadius: 1, color: Colors.grey)
          ]),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/fcpe.png', width: 200 * scale),
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: controller.schoolName,
                      builder: (context, schoolName, _) => Text(
                        schoolName.text,
                        style: TextStyle(
                          fontSize: 20 * scale,
                          fontWeight: FontWeight.w600,
                          color: fcpeBlue,
                        ),
                      ),
                    ),
                  ),
                  /* TODO(rxlabz) afficher le texte seul */
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: controller.year,
                          builder: (context, year, _) {
                            return Text.rich(
                              TextSpan(
                                text: 'Vos parents délégués FCPE ',
                                style: TextStyle(
                                  fontSize: 36 * scale,
                                  fontWeight: FontWeight.bold,
                                  color: fcpeBlue,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' $year-${year + 1}',
                                    style: const TextStyle(color: fcpeGreen),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: controller.groupName,
                          builder: (context, groupName, _) {
                            return groupName.text.isNotEmpty
                                ? Text(
                                    groupName.text,
                                    style: TextStyle(
                                      fontSize: 28 * scale,
                                      fontWeight: FontWeight.bold,
                                      color: fcpeBlue,
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: controller.members,
                    builder: (context, members, _) {
                      return Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          /*for (final c in TrombiColor.refColors)*/
                          for (final m in members.indexed)
                            Column(
                              children: [
                                Container(
                                  height: maxHeight / 5,
                                  width: maxWidth / 7,
                                  color: TrombiColor
                                      .refColors[m.$1 % 12].lightColor,
                                  alignment: Alignment.bottomCenter,
                                  child: m.$2.hasImage
                                      ? Image.memory(
                                          m.$2.image!,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.account_box,
                                          color: TrombiColor
                                              .refColors[m.$1 % 12].color,
                                          size: 64,
                                        ),
                                ),
                                Container(
                                  height: maxHeight / 12,
                                  width: maxWidth / 7,
                                  color: TrombiColor.refColors[m.$1 % 12].color,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          m.$2.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20 * scale,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          m.$2.levels,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18 * scale,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: controller.invite,
                builder: (context, invite, _) => Text(
                  invite.text,
                  style: TextStyle(
                    fontSize: 24 * scale,
                    fontWeight: FontWeight.bold,
                    color: fcpeGreen,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0 * scale),
                child: ValueListenableBuilder(
                  valueListenable: controller.contact,
                  builder: (context, invite, _) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/mail.png',
                          width: 60 * scale,
                        ),
                      ),
                      Text(
                        invite.text,
                        style: TextStyle(
                          fontSize: 24 * scale,
                          fontWeight: FontWeight.bold,
                          color: fcpeBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
