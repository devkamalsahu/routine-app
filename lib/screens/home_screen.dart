import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine_app/screens/create_routine_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('R O U T I N E'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreateRoutineScreen()),
              );
            },
            icon: Icon(CupertinoIcons.add),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
