import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routine_app/services/routine_provider.dart';
import 'package:routine_app/theme/elevated_button.dart';
import 'package:routine_app/theme/input_decoration_theme.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RoutineProvider.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => RoutineProvider(),
      child: const MyApp(),
    ),
  );
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
