import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import '../models/databaseException.dart' as de;
import '../models/note.dart';
import '../models/group.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
   //await deleteDatabase(join(await getDatabasesPath(), 'faks_projekt.db'));
    return await openDatabase(
      join(await getDatabasesPath(), 'faks_projekt.db'), //Path for db
      onCreate: (db, version) async {
        await db.execute('''  
          CREATE TABLE notes(
            id TEXT PRIMARY KEY,
          
            title TEXT,
            date TEXT,
            groupId TEXT,
            text TEXT
          )
        ''');

        await db.execute('''  
          CREATE TABLE groups(
            id TEXT PRIMARY KEY,
            title TEXT,
            r INT,
            g INT,
            b INT
          )
        ''');
      },
      version: 1,
    );
      
  }

  Future<void> editGroup(Group group) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE groups SET title=?,r=?,g=?,b=?
      WHERE id=?
     ''', [
      group.title,
      group.color.red,
      group.color.green,
      group.color.blue,
      group.id
    ]);
  }

  Future<void> addGroup(Group group) async {
    try {
      print(group.id + ' ' + group.color.red.toString());
      final db = await database;
      await db.rawInsert('''
    INSERT INTO groups(id, title, r, g, b)
    VALUES(?,?,?,?,?)
    ''', [
        group.id,
        group.title,
        group.color.red,
        group.color.green,
        group.color.blue
      ]);
    } catch (error) {
      print(error.toString());
      throw new de.DatabaseException('Error while adding user.');
    }
  }

  Future<void> deleteAllGroups() async {
    final res = await database;
    res.rawDelete(''' 
      DELETE FROM groups
    ''');
  }

  Future<int> addNote(Note note) async {
    try {
      final db = await database;
      return await db.rawInsert('''
      INSERT INTO notes(
        title,date,id,groupId,text
      )VALUES(?,?,?,?,?)
      ''', [
        note.title,
        note.date.toIso8601String(),
        note.id,
        note.groupId,
        note.text
      ]);
    } catch (error) {
      throw new de.DatabaseException('Error while adding NOTE.');
    }
  }

  Future<int> deleteNoteById(String id) async {
    try {
      final db = await database;
      return await db.rawDelete('''
      DELETE FROM notes WHERE id=?
      ''', [id]);
    } catch (error) {
      throw new de.DatabaseException('Error while deleting NOTE by ID.');
    }
  }

  Future<void> deleteAllNotesFromGroup(String groupId) async {
    try {
      final db = await database;
      return await db.rawDelete('''
    DELETE FROM notes WHERE groupId=?
    ''', [groupId]);
    } catch (error) {
      throw new de.DatabaseException(
          'Error while deleting ALL NOTES FROM GROUP.');
    }
  }

  Future<void> deleteGroupById(String groupId) async {
    try {
      final db = await database;
      await deleteAllNotesFromGroup(groupId);
      await db.rawDelete('''
      DELETE FROM groups WHERE id=?
      ''', [groupId]);
    } catch (error) {
      throw new de.DatabaseException('Error while DELETING GROUP BY ID.');
    }
  }

  Future<void> editNote(Note note) async {
    try {
      final res = await database;
      await res.rawUpdate(''' 
      UPDATE notes SET title=?,date=?,text=?
      WHERE id=?
    ''', [note.title, note.date.toIso8601String(), note.text, note.id]);
    } catch (error) {
      throw de.DatabaseException('Error while updating note !!!!');
    }
  }

  Future<Group> getGroupById(String id) async {
    try {
      final db = await database;
      final res = await db.query('groups', where: 'id=?', whereArgs: [id]);
      return res.isNotEmpty ? Group.fromJson(res.first) : null;
    } catch (error) {
      throw new de.DatabaseException('Error while GETTING GROUP BY ID.');
    }
  }

  Future<List<Group>> getAllGroups() async {
    try {
      var db = await database;
      final res = await db.query('groups');
      return res.isNotEmpty ? res.map((e) => Group.fromJson(e)).toList() : null;
    } catch (error) {
      throw new de.DatabaseException('Error while GETTING ALL GROUPS.');
    }
  }

  Future<Note> getNoteById(String id) async {
    try {
      final db = await database;
      final res = await db.query('notes', where: 'id=?', whereArgs: [id]);
      print('DOHVACENO JE');
      return res.isNotEmpty ? Note.fromJson(res.first) : null;
    } catch (error) {
      print(error.toString());
      throw new de.DatabaseException('Error while GETTING NOTE BY ID.');
    }
  }

  Future<List<Note>> loadNotes() async {
    try {
      final db = await database;
      final res = await db.query('notes');
       print('DOHVACENO JE');
      return res.isNotEmpty ? res.map((e) => Note.fromJson(e)).toList() : null;
    } catch (error) {
       print(error.toString());
      throw new de.DatabaseException('Error while GETTING  ALL NOTES.');
    }
  }
}
