import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:routine_app/collections/category.dart';
import 'package:routine_app/collections/routine.dart';
import 'package:routine_app/theme/elevated_button.dart';
import 'package:routine_app/theme/input_decoration_theme.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationSupportDirectory();

  final isar = await Isar.open([
    RoutineSchema,
    CategorySchema,
  ], directory: dir.path);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'R O U T I N E',
      theme: ThemeData(
        elevatedButtonTheme: elevatedButtonTheme,
        inputDecorationTheme: inputDecorationTheme,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
