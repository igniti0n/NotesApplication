import 'package:flutter/material.dart';

import '../models/group.dart';
import '../providers/groups.dart';
import '../providers/databaseProvider.dart';

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

class AddGroupScreen extends StatelessWidget {
  static final routeName = '/addGroupeScreen';
  var _formKey = GlobalKey<FormState>();

  Map<String, dynamic> newGroup = {
    'title': '',
    'id': null,
    'color': Colors.red,
  };

  Future<void> saveGroup(BuildContext ctx) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (newGroup['id'] == null) {
        try {
          final _group = Group(
              title: newGroup['title'],
              id: DateTime.now().toIso8601String(),
              color: newGroup['color']);

          await DBProvider.db.addGroup(_group);
          Provider.of<Groups>(ctx, listen: false).addGroup(_group);
        } catch (error) {
          print(error.toString());
        }
      } else {
        final _group = Group(
          title: newGroup['title'],
          id: newGroup['id'],
          color: newGroup['color'],
        );

        await DBProvider.db.editGroup(_group);
        Provider.of<Groups>(ctx, listen: false).editGroup(_group);
      }
      Navigator.of(ctx).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //var query = MediaQuery.of(context);
    // final availableHeight = query.size.height -
    //     query.viewInsets.bottom -
    //     query.padding.top -
    //     query.padding.bottom;

    var route =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    if (route != null) {
      newGroup['title'] = route['title'];
      newGroup['id'] = route['id'];
      newGroup['color'] = route['color'];
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.orange],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft)),

        //  height: availableHeight + 10,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: 30,
            // ),
            Container(
              height: 100,
              child: Text(
                'Edit group',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 36),
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 6, vertical: 20),
              transform: Matrix4.rotationZ(0.1),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: ' Name of the group.',
                      ),
                      keyboardType: TextInputType.text,
                      initialValue: newGroup['title'],
                      validator: (value) {
                        if (value.isEmpty) return 'Title is empty.';
                        return null;
                      },
                      style: theme.textTheme.bodyText1,
                      maxLines: 1,
                      onSaved: (value) => newGroup['title'] = value,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FlatButton(
                                onPressed: () => saveGroup(context),
                                child: Row(
                                  children: [
                                    Text(
                                      'Save group',
                                      style: theme.textTheme.bodyText1.copyWith(
                                          color: Colors.purple, fontSize: 27),
                                    ),
                                    Icon(
                                      Icons.save,
                                      color: Colors.purple,
                                    ),
                                  ],
                                ),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  // bool delete = await showDialog(
                                  //     context: context,
                                  //     builder: (ctx) => Column(
                                  //       children: [
                                  //         Text("Delete group?"),
                                  //         Row(
                                  //           children: [
                                  //             FlatButton(
                                  //                 onPressed: () =>
                                  //                     Navigator.of(context)
                                  //                         .pop(true),
                                  //                 child: Text("Yes")),
                                  //             FlatButton(
                                  //                 onPressed: () =>
                                  //                     Navigator.of(context)
                                  //                         .pop(false),
                                  //                 child: Text("No"))
                                  //           ],
                                  //         )
                                  //       ],
                                  //     ));
                                  // if (delete) {
                                    if (newGroup['id'] != null) {
                                      try {
                                        await DBProvider.db
                                            .deleteGroupById(newGroup['id']);

                                        Provider.of<Groups>(context,
                                                listen: false)
                                            .deleteGroup(newGroup['id']);
                                      } catch (error) {
                                        print(error.toString());
                                      }
                                    }

                                    Navigator.of(context)
                                        .pushReplacementNamed('/');
                                  //}
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Delete group',
                                      style: theme.textTheme.bodyText1.copyWith(
                                          fontSize: 27,
                                          color: Colors.red.shade800),
                                    ),
                                    Icon(Icons.delete_outline,
                                        color: Colors.red.shade800)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Pick your group color',
                            style: theme.textTheme.bodyText1
                                .copyWith(fontSize: 33),
                          ),
                          Expanded(
                            child: MaterialColorPicker(
                              onColorChange: (value) {
                                newGroup['color'] = value;
                              },
                              onMainColorChange: (value) {
                                newGroup['color'] = value;
                              },
                              selectedColor:
                                  Colors.red, // Color(newGroup['color']),
                              allowShades: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
