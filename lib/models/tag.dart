import 'package:realm/realm.dart';
import '../database/realm_models.dart' as realm_db;

class Tag {
  final ObjectId? id;
  final String name;

  Tag({this.id, required this.name});

  // Convert from Realm object to model
  factory Tag.fromRealm(realm_db.Tag realmTag) {
    return Tag(
      id: realmTag.id,
      name: realmTag.name,
    );
  }

  // Convert to Realm object
  realm_db.Tag toRealm() {
    return realm_db.Tag(
      id ?? ObjectId(),
      name,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(id: map['id'], name: map['name']);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tag && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
