import 'package:flutter/material.dart';

import '../providers/groups.dart';
import '../models/group.dart';
import '../widgets/GroupItem.dart';
import '../screens/notes_screen.dart';
import '../widgets/add_item.dart';
import '../providers/notes.dart';

import 'package:provider/provider.dart';

class GroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My Notes'),
      //   actions: [IconButton(icon: Icon(Icons.add), onPressed: null)],
      // ),

      body: BodyWidget(),
    );
  }
}

class BodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    final availableHeight = query.size.height -
        query.viewInsets.bottom -
        query.padding.top -
        query.padding.bottom;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.blue, Colors.orange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
      child: Column(
        children: [
          SizedBox(
            height: availableHeight * 0.05,
          ),
          Container(
            height: availableHeight * 0.2,
            child: Text(
              "My \ Notes",
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 54),
            ),
            transform: Matrix4.rotationZ(0.15),
          ),
          SizedBox(
            height: availableHeight * 0.05,
          ),
          ChangeWidget(),
        ],
      ),
    );
  }
}

class ChangeWidget extends StatefulWidget {
  @override
  _ChangeWidgetState createState() => _ChangeWidgetState();
}

class _ChangeWidgetState extends State<ChangeWidget> {
  var _showGroup = true;
  String _groupId;

  void _changeScreen(String groupId) {
    setState(() {
      _showGroup = !_showGroup;
      this._groupId = groupId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showGroup
        ? GroupWidget(_changeScreen)
        : NotesScreen(_groupId, _changeScreen);
  }
}

class GroupWidget extends StatefulWidget {
  final Function change;
  GroupWidget(this.change);

  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  bool _loaded = false;

  Future<void> _loadInit() async {
    if (!_loaded) {
      print('STARTING LOAD');
      await Provider.of<Groups>(context, listen: false).loadGroups();
      await Provider.of<Notes>(context, listen: false).loadNotes();
      //setState(() {
      _loaded = true;
      print('LOADING DONE!!!!');
      //});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadInit(),
      builder: (ctx, snapshot) {
        return snapshot.connectionState != ConnectionState.done && !_loaded
            ? Center(child: CircularProgressIndicator())
            : Consumer<Groups>(builder: (ctx, groups, _) {
                final List<Group> _groupList = groups.groups;
                return Expanded(
                  child: GridView.builder(
                    itemCount: _groupList.length + 1,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 5),
                    itemBuilder: (ctx, index) {
                      return index != _groupList.length
                          ? GroupItem(_groupList[index], this.widget.change)
                          : AddItem();
                    },
                  ),

                  // child: ListView.builder(
                  //   itemCount: _groupList.length,
                  //   itemBuilder: (ctx, index) => GroupItem(_groupList[index]),
                  //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  // ),
                );
              });
      },
    );
  }
}
