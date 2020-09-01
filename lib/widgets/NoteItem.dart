import 'package:flutter/material.dart';

import '../models/note.dart';
import '../screens/addNoteScreen.dart';

import 'package:intl/intl.dart';

class NoteItem extends StatelessWidget {
  final Note note;

  NoteItem(this.note);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
         Navigator.of(context).pushNamed(NoteScreen.routeName, arguments: {
        'title': note.title,
        'id': note.id,
        'date': note.date,
        'text': note.text,
        'groupId': note.groupId,
      });
      print(note.id.toString() + ',  ' + note.title.toString());
      },
         
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
              colors: [Colors.white, Colors.white70],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 140,
              alignment: Alignment.centerLeft,
              child: Text(
                note.title,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              'Date: ',
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 22),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat.yMd().format(note.date),
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 22),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
