import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  NoteModel({
    required this.tital,
    required this.description,
    required this.time,
    required this.backgroundColor,
  });

  @HiveField(0)
  final String tital;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final DateTime time;

  @HiveField(3)
  final Color backgroundColor;
}
