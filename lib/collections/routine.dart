import 'category.dart';
import 'package:isar/isar.dart';

part 'routine.g.dart';

@Collection()
class Routine {
  Id id = Isar.autoIncrement;
  late String title;

  // default index -> data is sorted so it will be faster to fetch
  @Index()
  late DateTime startTime;

  // by default casSensitive is true
  @Index(caseSensitive: false)
  late String day;

  @Index(composite: [CompositeIndex('title')])
  final category = IsarLink<Category>();
}
