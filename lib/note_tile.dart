import 'package:flutter/material.dart';

import 'models/note.dart';

class NoteTile extends StatefulWidget {
  final Function onDelete;
  final Function onCompleted;
  final Note note;

  const NoteTile(
      {Key key,
      @required this.note,
      @required this.onCompleted,
      @required this.onDelete})
      : super(key: key);

  @override
  _NoteTileState createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  bool completed;

  @override
  void initState() {
    super.initState();
    completed = widget.note.completed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        widget.onDelete();
      },
      child: Container(
        key: Key(widget.note.uid),
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(1, 2), blurRadius: 20),
          ],
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(6.0),
                child: Text(
                  widget.note.title,
                  style: TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Checkbox(
                value: completed,
                onChanged: (val) {
                  widget.onCompleted(val);
                  setState(() {
                    completed = val;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
