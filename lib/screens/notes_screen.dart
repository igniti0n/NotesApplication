import 'package:faks_app/providers/databaseProvider.dart';
import 'package:flutter/material.dart';

import '../widgets/NoteItem.dart';
import '../models/note.dart';
import '../screens/addNoteScreen.dart';
import '../providers/notes.dart';
import '../providers/groups.dart';
import '../screens/addGroupScreen.dart';

import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  static const routeName = '/notesScreen';

  final String _groupId;
  final Function change;

  NotesScreen(this._groupId, this.change);

  @override
  Widget build(BuildContext context) {
    final List<Note> _notes =
        Provider.of<Notes>(context).getGroupNotes(_groupId);

    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            Provider.of<Groups>(context, listen: true)
                .getGroupTitleByID(_groupId),
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Expanded(
            child: _notes == null
                ? Container(
                    child: Image.asset('assets/images/waiting.png'),
                    // height: 200,
                    margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                  )
                : ListView.builder(
                    itemCount: _notes.length,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    itemBuilder: (ctx, ind) => NoteItem(_notes[ind]),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => change(null),
                iconSize: 50,
                color: Colors.blueGrey,
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  var group = Provider.of<Groups>(context, listen: false)
                      .getGroupByID(_groupId);
                  Navigator.of(context)
                      .pushNamed(AddGroupScreen.routeName, arguments: {
                    'title': group.title,
                    'id': group.id,
                    'color': group.color,
                  });
                },
                iconSize: 50,
                color: Colors.blueGrey,
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(NoteScreen.routeName, arguments: {
                    'title': null,
                    'id': null,
                    'date': DateTime.now(),
                    'text': null,
                    'groupId': _groupId,
                  });
                },
                iconSize: 50,
                color: Colors.blueGrey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
