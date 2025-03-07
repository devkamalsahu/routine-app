import 'package:isar/isar.dart';

part 'category.g.dart';

@Collection()
class Category {
  Id id = Isar.autoIncrement;

  // ensures that the name is gonna be unique
  @Index(unique: true)
  late String name;
}
