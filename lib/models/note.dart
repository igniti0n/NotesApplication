import 'dart:convert';

import 'package:flutter/material.dart';

class Note {
  final String title;
  final DateTime date;
  final String id;
  final String groupId;
  final String text;

  Note({
    @required this.title,
    @required this.date,
    @required this.id,
    @required this.text,
    @required this.groupId,
  });

  static String toJson(Note note) {
    return json.encode({
      'title': note.title,
      'date': note.date.toIso8601String(),
      'id': note.id,
      'groupId': note.groupId,
      'text': note.text
    });
  }

  static Note fromJson(Map<String, dynamic> note) {
    return Note(
        title: note['title'],
        date: DateTime.parse(note['date']),
        id: note['id'],
        text: note['text'],
        groupId: note['groupId']);
  }
}
