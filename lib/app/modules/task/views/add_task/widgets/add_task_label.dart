import 'package:flutter/material.dart';

class AddTaskLabel extends StatelessWidget {
  final String text;

  const AddTaskLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF616161),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
