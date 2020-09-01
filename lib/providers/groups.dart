import 'package:flutter/material.dart';

import '../providers/databaseProvider.dart';
import '../models/group.dart';

class Groups with ChangeNotifier {
  List<Group> _myGroups = [
    // Group(
    //     title: "GRUPA je ovo moja sada evo nesto ovamo",
    //     id: 'ssss',
    //     color: Color(0xFFAFFFFF)),
    // Group(title: "GRUPA", id: 's', color: Color(0xFFFFFFFF)),
  ];

  List<Group> get groups {
    return [..._myGroups]; //ne vraćaj pravu listu, vrati kopiju
  }

  Future<void> loadGroups() async {
    final loadedGroups = await DBProvider.db.getAllGroups();

    if (loadedGroups == null || loadedGroups.length == 0) {
      print('LOoaded groups null or lenght 0.');
      return;
    }
    _myGroups = loadedGroups;
    notifyListeners();
  }

  String getGroupTitleByID(String id) {
    final res =
        _myGroups.firstWhere((element) => element.id == id, orElse: () => null);
    return res != null ? res.title : '';
  }

  Group getGroupByID(String id) {
    return _myGroups.firstWhere((element) => element.id == id);
  }

  void addGroup(Group newGroup) {
    _myGroups.add(newGroup);

    notifyListeners();
  }

  void editGroup(Group group) {
    int index = _myGroups.indexWhere((element) => element.id == group.id);
    print(index);
    _myGroups[index] = group;
    notifyListeners();
  }

  void deleteGroup(String id) {
    final toDelete =
        _myGroups.firstWhere((element) => element.id == id, orElse: null);
    if (toDelete == null) return;
    _myGroups.remove(toDelete);

    notifyListeners();
  }
}
