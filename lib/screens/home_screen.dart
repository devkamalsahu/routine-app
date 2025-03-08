import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routine_app/screens/create_routine_screen.dart';
import 'package:routine_app/screens/update_routine.dart';
import 'package:routine_app/services/routine_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final db = Provider.of<RoutineProvider>(context, listen: false);
  late final dbProvider = Provider.of<RoutineProvider>(context);

  // controller
  final searchcontroller = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      db.readRoutines();
    });
    super.initState();
  }

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
      body:
          dbProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // search controller
                    TextFormField(
                      onChanged: (value) {
                        db.searchRoutine(value);
                      },
                      controller: searchcontroller,
                      decoration: InputDecoration(
                        hintText: 'Search routine',
                        prefixIcon: Icon(CupertinoIcons.search),
                      ),
                    ),
                    dbProvider.routines.isNotEmpty
                        ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: dbProvider.routines.length,
                          itemBuilder: (context, index) {
                            final routine = dbProvider.routines[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            UpdateRoutine(routine: routine),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                        31,
                                        188,
                                        186,
                                        186,
                                      ),
                                    ),
                                  ],
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          routine.title,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.clock,
                                              size: 20,
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              routine.startTime,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.titleSmall,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.calendar,
                                              size: 20,
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              routine.day,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.titleSmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                        : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.arrow_2_circlepath,
                                size: 200,
                              ),
                              SizedBox(height: 50),
                              Text(
                                'No routine is available',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
    );
  }
}
