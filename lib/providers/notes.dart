import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/databaseProvider.dart';

class Notes with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes {
    return [..._notes];
  }

  List<Note> getGroupNotes(String groupId) {
    var list = _notes.where((element) => element.groupId == groupId).toList();
    return list.isNotEmpty ? list : null;
  }

  Future<void> loadNotes() async {
    try{
       final _loadedNotes = await DBProvider.db.loadNotes();
       print('notes: ' + _loadedNotes.toString() );
       if(_loadedNotes == null)return;
       this._notes = _loadedNotes;
    }catch(error){
      print(error.toString());
    }
   
  }

  Note getNote(String noteId) {
    return _notes.firstWhere((element) => element.id == noteId);
  }

  void deleteNote(String noteId) {
    _notes.removeWhere((element) => element.id == noteId);
    notifyListeners();
  }

  void deleteAllNotesFromGroup(String groupId) {
    _notes.removeWhere((element) => element.groupId == groupId);
    notifyListeners();
  }

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void updateNote(Note note) {
    int index = _notes.indexWhere((element) => element.id == note.id);
    _notes[index] = note;
    notifyListeners();
  }
}
