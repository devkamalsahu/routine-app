import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../collections/category.dart';
import '../collections/routine.dart';

class RoutineProvider extends ChangeNotifier {
  static late Isar isar;

  late bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  List<Routine> _routines = [];
  List<Routine> get routines => _routines;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = Isar.openSync([RoutineSchema, CategorySchema], directory: dir.path);
  }

  // add category
  Future<void> addCategory(Category category) async {
    _setLoading(true);
    await isar.writeTxn(() => isar.categorys.put(category));
    readCategories();

    _setLoading(false);
  }

  // read category
  Future<void> readCategories() async {
    _setLoading(true);

    List<Category> fetchedCategories = await isar.categorys.where().findAll();

    _categories.clear();
    _categories.addAll(fetchedCategories);
    notifyListeners();

    _setLoading(false);
  }

  Future<void> addRoutine(
    String title,
    String startTime,
    String day,
    String categoryName,
  ) async {
    _setLoading(true);

    // 1️⃣ Fetch the Category object from Isar
    final categoryObj =
        await isar.categorys.filter().nameEqualTo(categoryName).findFirst();

    if (categoryObj == null) {
      print("Category not found!");
      _setLoading(false);
      return;
    }

    // 2️⃣ Create a new Routine instance and link the category
    final newRoutine =
        Routine()
          ..title = title
          ..startTime = startTime
          ..day = day
          ..category.value = categoryObj; // Link category

    // 3️⃣ Save Routine & Category Link
    await isar.writeTxn(() async {
      await isar.routines.put(newRoutine); // Save routine
      await newRoutine.category.save(); // Save link
    });

    readRoutines();
    _setLoading(false);
  }

  Future<void> updateRoutine(
    String title,
    String startTime,
    String day,
    String categoryName,
    int id,
  ) async {
    _setLoading(true);

    // 1️⃣ Fetch the Category object from Isar
    final categoryObj =
        await isar.categorys.filter().nameEqualTo(categoryName).findFirst();

    if (categoryObj == null) {
      print("Category not found!");
      _setLoading(false);
      return;
    }

    final fetchedRoutine = await isar.writeTxn(() => isar.routines.get(id));

    final updateRoutine =
        Routine()
          ..id = id
          ..category.value = categoryObj
          ..day = day
          ..startTime = startTime
          ..title = title;

    // 3️⃣ Save Routine & Category Link
    await isar.writeTxn(() async {
      await isar.routines.put(updateRoutine); // Save routine
      await updateRoutine.category.save(); // Save link
    });

    readRoutines();
    _setLoading(false);
  }

  // read all routines
  Future<void> readRoutines() async {
    _setLoading(true);
    List<Routine> fetchedRoutines = await isar.routines.where().findAll();

    _routines.clear();
    _routines.addAll(fetchedRoutines);
    notifyListeners();

    _setLoading(false);
  }

  Future<void> deleteRoutine(Routine routine) async {
    _setLoading(true);
    await isar.writeTxn(() {
      return isar.routines.delete(routine.id);
    });
    readRoutines();
    _setLoading(false);
  }

  Future<void> searchRoutine(String searchText) async {
    if (searchText.isEmpty) {
      _routines.clear();
      readRoutines();
      return;
    }
    _routines.clear();
    final searchResult = await isar.writeTxn(
      () => isar.routines.filter().titleContains(searchText).findAll(),
    );

    _routines.addAll(searchResult);
    notifyListeners();
  }
}
