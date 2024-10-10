import 'package:flutter/foundation.dart';

class Trombi {
  final String schoolName;
  final String groupName;
  final int year;
  final List<Member> members;
  final String invite;
  final String contact;

  Trombi({
    required this.schoolName,
    required this.groupName,
    required this.year,
    required this.members,
    required this.invite,
    required this.contact,
  });
}

class Member {
  final String name;
  final String levels;
  final Uint8List? image;

  Member({
    required this.name,
    required this.levels,
    required this.image,
  });

  bool get hasImage => image != null;
}
