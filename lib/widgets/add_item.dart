import 'package:flutter/material.dart';

import '../screens/addGroupScreen.dart';

class AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AddGroupScreen.routeName, arguments: null),
          child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: Colors.blueGrey
        ),
        child: Icon(Icons.playlist_add,size: 44,),
      ),
    );
  }
}
