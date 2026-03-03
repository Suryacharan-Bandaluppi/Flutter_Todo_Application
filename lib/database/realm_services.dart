import 'package:realm/realm.dart';
import 'realm_models.dart';

class RealmService {
  late final Realm realm;

  RealmService() {
    final config = Configuration.local(
      [Task.schema, Tag.schema],
    );
    realm = Realm(config);
  }

  void close() {
    realm.close();
  }
}