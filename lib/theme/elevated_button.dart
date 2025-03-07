import 'package:flutter/material.dart';

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: Colors.black,
    side: BorderSide(color: Colors.black12),
    padding: const EdgeInsets.symmetric(vertical: 15),
    maximumSize: const Size.fromHeight(50),
    minimumSize: const Size.fromHeight(40),
    foregroundColor: Colors.white,
    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
);
