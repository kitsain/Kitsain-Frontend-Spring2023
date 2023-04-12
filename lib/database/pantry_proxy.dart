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

  RealmResults<Item> getItems() {
    var all = _realm.all<Item>();
    return all;
  }

  subscribe() {
    final items = getItems();
    items.changes.listen((changes) {
      changes.inserted; // indexes of inserted objects
      changes.modified; // indexes of modified objects
      changes.deleted; // indexes of deleted objects
      changes.newModified; // indexes of modified objects
      // after deletions and insertions are accounted for
      changes.moved; // indexes of moved objects
      changes.results; // the full List of objects
    });
  }

  RealmResults<Item> getPantryItems({String sortBy = "az"}) {
    var all = getItems();
    var result = all.query("location == \$0", ["Pantry"]);
    //var result = all.query("location = \$0 SORT(\$1 DESC)", ["Pantry", sortBy]);
    return result;
  }

  RealmResults<Item> getOpenedItems() {
    var pantryitems = getPantryItems();
    //var result = all.query("location == \$0", ["Pantry"]);
    var result = pantryitems.query(
      "openedDate != null",
    );
    return result;
  }

  int getCatCount(String category) {
    var count = getPantryItems().query("mainCat == \$0", [category]).length;
    return count;
  }

  RealmResults<Item> getByMainCat(String category) {
    var pantryitems = getPantryItems();
    var result =
        pantryitems.query("mainCat == \$0 SORT(name DESC)", [category]);
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

  void changeLocation(Item item, String newLoc) {
    _realm.write(() {
      item.location = newLoc;
    });
    notifyListeners();
  }

  void deleteItem(Item item) {
    try {
      _realm.write(() {
        _realm.delete(item);
      });
      notifyListeners();
    } on RealmException catch (e) {
      debugPrint(e.message);
    }
  }

  void deleteAll() {
    _realm.write(() {
      _realm.deleteAll<Item>();
    });
    notifyListeners();
  }
}
