import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/collections/category.dart';
import '/services/routine_provider.dart';

class CreateRoutineScreen extends StatefulWidget {
  const CreateRoutineScreen({super.key});

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  // controllers
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final newCatController = TextEditingController();

  // providers
  late final db = Provider.of<RoutineProvider>(context, listen: false);
  late final dbProvider = Provider.of<RoutineProvider>(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      db.readCategories();
    });
  }

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

  // initial values
  String? selectedCategoy;
  String? selectedDay;
  late TimeOfDay timeOfDay;

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

  void addRoutine() async {
    if (titleController.text.isNotEmpty &&
        selectedCategoy != null &&
        timeController.text.isNotEmpty &&
        selectedDay != null) {
      final db = Provider.of<RoutineProvider>(context, listen: false);

      await db.addRoutine(
        titleController.text,
        timeController.text,
        selectedDay!,
        selectedCategoy!, // Pass category name
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

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    timeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CREATE ROUTINE')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // category
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
              ElevatedButton(onPressed: addRoutine, child: Text('Add')),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to format time in 12-hour format
String formatTime(TimeOfDay time) {
  final hour = time.hourOfPeriod; // Converts 17 to 5
  final minute = time.minute.toString().padLeft(2, '0'); // Ensures two digits
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';

  return '$hour:$minute $period';
}
