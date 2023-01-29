import 'package:flutter/material.dart';

class tabs extends StatefulWidget {
  const tabs(
      {Key? key,
      required this.text,
      required this.color,
      required this.function,
      required this.fontSize})
      : super(key: key);
  final String text;
  final Color color;
  final Function function;
  final double fontSize;

  @override
  State<tabs> createState() => _tabsState();
}

class _tabsState extends State<tabs> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.function();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.color,
        ),
        child: Text(
          widget.text,
          style:
              TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
