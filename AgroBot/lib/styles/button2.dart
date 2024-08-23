import 'package:flutter/material.dart';

ButtonStyle buttonSecondary(Color color1, bool includeBorder,) {
  return ElevatedButton.styleFrom(
    minimumSize: const Size(300, 60),
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      side: includeBorder ? const BorderSide(color: Color(0xFF02AA6D), width: 2) : BorderSide.none,
    ),
    backgroundColor: color1,
  );
}