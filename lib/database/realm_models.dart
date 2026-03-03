import 'package:realm/realm.dart';

part 'realm_models.realm.dart';

@RealmModel()
class _Tag {
  @PrimaryKey()
  late ObjectId id;

  @Indexed()
  late String name;
}

@RealmModel()
class _Task {
  @PrimaryKey()
  late ObjectId id;

  late String title;
  late String description;
  late DateTime createdAt;

  DateTime? deadline;

  late List<_Tag> tags;
}