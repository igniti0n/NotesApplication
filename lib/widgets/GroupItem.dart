import 'package:flutter/material.dart';

import '../models/group.dart';

class GroupItem extends StatefulWidget {
  final Group group;
  final Function change;

  GroupItem(this.group, this.change);

  @override
  _GroupItemState createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem>
    with SingleTickerProviderStateMixin {
  List<Group> _groupList = [];
  AnimationController _controller;
  Animation<double> _opacityAnimation;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    _controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _opacityAnimation.addListener(() => setState(() {}));
      _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.change(widget.group.id),
      child: Container(
          // height: 40,
          decoration: BoxDecoration(
            color: widget.group.color.withOpacity(_opacityAnimation.value),
            // border: Border.all(width: 2, color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Center(
            child: Text(
              widget.group.title,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}
