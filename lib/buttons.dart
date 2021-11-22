import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  final String title;
  final Function action;

  const ChipButton({Key? key, required this.title, required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
