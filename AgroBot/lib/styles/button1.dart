import 'package:flutter/material.dart';

ButtonStyle buttonPrimary({required Size minimumSize}){
  return ElevatedButton.styleFrom(
  minimumSize: minimumSize,
  backgroundColor:const Color(0xFFDAFFF2),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  splashFactory: NoSplash.splashFactory,
);
}
