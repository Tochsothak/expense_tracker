import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text,
    {MaterialColor? backgroundColor = Colors.red}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      ),
    ),
  );
}
