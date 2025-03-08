import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routine_app/collections/routine.dart';
import '/collections/category.dart';
import '/screens/create_routine_screen.dart';
import '/services/routine_provider.dart';

class UpdateRoutine extends StatefulWidget {
  const UpdateRoutine({super.key, required this.routine});

  final Routine routine;

  @override
  State<UpdateRoutine> createState() => _UpdateRoutineState();
}

class _UpdateRoutineState extends State<UpdateRoutine> {
  // initial values
  String? selectedCategoy;
  String? selectedDay;
  late TimeOfDay timeOfDay;
  bool isInit = true;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isInit) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        initForm();
      });
      isInit = false;
    }
  }

  void initForm() async {
    await db.readCategories();

    selectedCategoy = selectedDay = widget.routine.day;
    timeController.text = widget.routine.startTime;
    titleController.text = widget.routine.title;
    await widget.routine.category.load();

    final category = db.categories.firstWhere(
      (element) => element.id == widget.routine.category.value!.id,
    );
    selectedCategoy = category.name;

    setState(() {
      isLoading = false;
    });
  }

  // controllers
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final newCatController = TextEditingController();

  // week days
  final days = [
    DropdownMenuItem(value: 'Monday', child: Text('Monday')),
    DropdownMenuItem(value: 'Tuesday', child: Text('Tuesday')),
    DropdownMenuItem(value: 'Wednesday', child: Text('Wednesday')),
    DropdownMenuItem(value: 'Thursday', child: Text('Thursday')),
    DropdownMenuItem(value: 'Friday', child: Text('Friday')),
    DropdownMenuItem(value: 'Saturday', child: Text('Saturday')),
    DropdownMenuItem(value: 'Sunday', child: Text('Sunday')),
  ];

  // providers
  late final db = Provider.of<RoutineProvider>(context, listen: false);
  late final dbProvider = Provider.of<RoutineProvider>(context);

  void addCategory() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add Category'),
            content: TextFormField(
              controller: newCatController,
              decoration: InputDecoration(hintText: 'category name'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (newCatController.text.isNotEmpty) {
                    final newCategory =
                        Category()..name = newCatController.text;
                    db.addCategory(newCategory);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
    );
  }

  // adding time
  void addTime() async {
    // fetching current time
    timeOfDay = TimeOfDay(
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
    );

    //
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );

    if (selectedTime != null) {
      timeOfDay = selectedTime;
      timeController.text = formatTime(selectedTime);
    }
  }

  void updateRoutine() async {
    if (titleController.text.isNotEmpty &&
        selectedCategoy != null &&
        timeController.text.isNotEmpty &&
        selectedDay != null) {
      await db.updateRoutine(
        titleController.text,
        timeController.text,
        selectedDay!,
        selectedCategoy!, // Pass category name
        widget.routine.id,
      );

      titleController.clear();
      timeController.clear();

      setState(() {
        selectedCategoy = null;
        selectedDay = null;
      });

      Navigator.of(context).pop();
    }
  }

  void deleteRoutine() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Routine'),
            content: Text('Are you sure you want to delete this routine?'),
            actions: [
              TextButton(
                onPressed: () {
                  db.deleteRoutine(widget.routine);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPDATE ROUTINE'),
        actions: [
          IconButton(
            onPressed: deleteRoutine,
            icon: Icon(CupertinoIcons.delete),
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // category
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: DropdownButton(
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down),
                                hint: Text('Category'),
                                borderRadius: BorderRadius.circular(16),
                                items:
                                    dbProvider.categories
                                        .map(
                                          (cat) => DropdownMenuItem(
                                            value: cat.name,
                                            child: Text(cat.name),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategoy = value;
                                  });
                                },
                                value: selectedCategoy,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: addCategory,
                            icon: Icon(CupertinoIcons.add),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // title
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // start time field
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: timeController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Start time',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: addTime,
                            icon: Icon(CupertinoIcons.clock),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      // days form field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: DropdownButton(
                          hint: Text('Day'),
                          items: days,
                          onChanged: (value) {
                            setState(() {
                              selectedDay = value;
                            });
                          },
                          value: selectedDay,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(16),
                          icon: Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                      SizedBox(height: 20),

                      // add button
                      ElevatedButton(
                        onPressed: updateRoutine,
                        child: Text('Update'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
