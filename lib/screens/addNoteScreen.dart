import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/databaseProvider.dart';
import '../providers/notes.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatefulWidget {
  static const routeName = 'noteScreen';

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  DateTime dateSelected = DateTime.now();
  var _textNode = new FocusNode();
  var _formKey = GlobalKey<FormState>();
  bool loadedInitialValues = false;

  Map<String, dynamic> newNote = {
    'title:': '',
    'text': '',
    'id': '',
    'groupId': '',
    'date': DateTime.now(),
  };

  @override
  void didChangeDependencies() {
    if (!loadedInitialValues) {
      var arguments =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      newNote['groupId'] = arguments['groupId'];
      newNote['text'] = arguments['text'];
      newNote['id'] = arguments['id'];
      newNote['title'] = arguments['title'];
      newNote['date'] = arguments['date'];
      dateSelected = arguments['date'];

      loadedInitialValues = true;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _textNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _deleteNote() async {
    try {
      // final res = await DBProvider.db.getNoteById(newNote['id']);
      // print(res.title);
       final res = await DBProvider.db.deleteNoteById(newNote['id']);
      print('deleted $res items');
      Provider.of<Notes>(context, listen: false).deleteNote(newNote['id']);
    } catch (error) {
      print(error.toString());
    }
  }

  void saveNote() async {
    _formKey.currentState.save();

    if (newNote['id'] != null) {
      try {
        final Note _note = Note(
          title: newNote['title'],
          date: newNote['date'],
          id: newNote['id'],
          text: newNote['text'],
          groupId: newNote['groupId'],
        );

        await DBProvider.db.editNote(_note);
        Provider.of<Notes>(context, listen: false).updateNote(_note);
      } catch (error) {
        print(error.toString());
      }
    } else {
      try {
        final Note _note = Note(
          title: newNote['title'],
          date: newNote['date'],
          id: DateTime.now().toIso8601String(),
          text: newNote['text'],
          groupId: newNote['groupId'],
        );

         await DBProvider.db.addNote(_note); 
        Provider.of<Notes>(context, listen: false).addNote(_note);
        
      } catch (error) {
        print(error.toString());
      }
      print(Provider.of<Notes>(context, listen: false).notes.toString());
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var textStyle = Theme.of(context).textTheme.bodyText1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.orange]),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Expanded(
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Title.',
                            ),
                            keyboardType: TextInputType.text,
                            initialValue: newNote['title'],
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).requestFocus(_textNode),
                            onSaved: (value) => newNote['title'] = value,
                            textInputAction: TextInputAction.next,
                            // maxLines: ,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: TextFormField(
                              focusNode: _textNode,
                              initialValue: newNote['text'],
                              onSaved: (value) => newNote['text'] = value,
                              decoration: InputDecoration(
                                hintText: 'Write your note.',
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 12,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Date :   ',
                                        style: textStyle,
                                      ),
                                      Text(
                                        DateFormat.yMMMd().format(dateSelected),
                                        style: textStyle,
                                      ),
                                      FlatButton(
                                        onPressed: () => showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        ).then((value) {
                                          if (value != null)
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());

                                          setState(() {
                                            dateSelected = value;

                                            newNote['date'] = value;
                                          });
                                        }),
                                        child: Text(
                                          'Date Picker',
                                          style: textStyle.copyWith(
                                              color: Colors.purple),
                                        ),
                                      ),
                                      SizedBox(width: 40),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.end,
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.save,
                                      size: 30,
                                      color: Colors.purple,
                                    ),
                                    onPressed: () {
                                      saveNote();
                                      Navigator.of(context).pop();
                                    }),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      if (newNote['id'] != null) {
                                        _deleteNote();
                                      }
                                      Navigator.of(context).pop();
                                    })
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
