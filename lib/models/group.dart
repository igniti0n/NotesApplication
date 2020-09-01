import 'package:flutter/material.dart';

import 'dart:convert';

class Group {
  final String title;
  final String id;
  final Color color;

  Group({@required this.title, @required this.id, @required this.color});

  static Group fromJson(Map<String, dynamic> newGroup) {
    return Group(
      title: newGroup['title'],
      id: newGroup['id'],
      color: Color.fromRGBO(newGroup['r'], newGroup['g'], newGroup['b'], 1.0), 
    );
  }

  static String toJson(Group group){
     return json.encode({
        'title' : group.title,
        'id' : group.id,
        'r': group.color.red,
        'g' : group.color.green,
        'b' : group.color.blue
      });
  }
}
