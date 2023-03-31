import 'package:realm/realm.dart';
import 'package:flutter/foundation.dart';
import 'item.dart';

// This file is used to modify the database.
// When you want to call a function from another class,
// use for example PantryProxy().

class PantryProxy with ChangeNotifier {
  final Configuration _config =
      Configuration.local([Item.schema], shouldDeleteIfMigrationNeeded: true);
  late Realm _realm;

  PantryProxy() {
    openRealm();
  }

  openRealm() {
    _realm = Realm(_config);
  }

  closeRealm() {
    if (!_realm.isClosed) {
      _realm.close();
    }
  }

  listenToChanges() {
    final subscription = getItems().changes.listen((changes) {
      changes.inserted;
      changes.modified;
      changes.deleted;
      changes.newModified;
      changes.moved;
      changes.results;
    });
  }

  List groupBy(RealmResults<Item> items) {
    return [];
  }

  RealmResults<Item> getItems() {
    var all = _realm.all<Item>();
    return all;
  }

  RealmResults<Item> getPantryItems() {
    var all = getItems();
    var result = all.query("location == \$0", ["Pantry"]);
    return result;
  }

  Item? getItem(String id) {
    final item = _realm.find<Item>(id);
    return item;
  }

  RealmResults<Item> getByMainCat(String category) {
    var all = getItems();
    var result = all.query("mainCat == \$0", [category]);
    return result;
  }

  bool upsertItem(Item item) {
    debugPrint("addItem");
    try {
      debugPrint(item.mainCat);
      _realm.write(() {
        _realm.add<Item>(item, update: true);
      });
      notifyListeners();
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool toggleItemEveryday(Item item) {
    try {
      _realm.write(() {
        if (item.everyday == false) {
          item.everyday = true;
        } else {
          item.everyday = false;
        }
      });
      notifyListeners();
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool deleteItem(Item item) {
    try {
      _realm.write(() {
        _realm.delete(item);
      });
      notifyListeners();
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  void deleteAll() {
    _realm.write(() {
      _realm.deleteAll<Item>();
    });
    notifyListeners();
  }
}
