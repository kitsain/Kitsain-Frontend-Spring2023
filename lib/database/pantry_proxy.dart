import 'package:realm/realm.dart';
import 'package:flutter/foundation.dart';
import 'item.dart';

// This file is used to modify the database.
// When you want to call a function from another class,
// use for example PantryProxy().

// Creating and initiating the DB (realm)
var _config =
    Configuration.local([Item.schema], shouldDeleteIfMigrationNeeded: true);
var realm = Realm(_config);

class PantryProxy with ChangeNotifier {
  RealmResults<Item> getItems() {
    var all = realm.all<Item>();
    return all;
  }

  subscribe() {
    final items = getItems();
    items.changes.listen(
      (changes) {
        changes.inserted; // indexes of inserted objects
        changes.modified; // indexes of modified objects
        changes.deleted; // indexes of deleted objects
        changes.newModified; // indexes of modified objects
        // after deletions and insertions ar
        //
        //
        //
        //
        //
        //
        //
        //
        //
        //
        //
        // e accounted for
        changes.moved; // indexes of moved objects
        changes.results; // the full List of objects
      },
    );
  }

  /*
  GETTERS
  */

  RealmResults<Item> getPantryItems([String sortBy = "az"]) {
    var all = getItems();
    late RealmResults<Item> result;
    if (sortBy == "az") {
      result = all.query(
        "location = \$0 SORT(name ASC)",
        ["Pantry"],
      );
    } else if (sortBy == "expdate") {
      result = all.query(
          "location = \$0 SORT(hasExpiryDate DESC, expiryDate ASC)",
          ["Pantry"]);
    } else if (sortBy == "addedlast") {
      result = all.query(
        "location = \$0 SORT(addedDate DESC)",
        ["Pantry"],
      );
    }
    return result;
  }

  RealmResults<Item> getFavouriteItems([String sortBy = "az"]) {
    var all = getPantryItems();
    late RealmResults<Item> result;
    if (sortBy == "az") {
      result = all.query("favorite = true SORT(name ASC)");
    } else if (sortBy == "expdate") {
      result = all.query("favorite = true SORT(expiryDate ASC)");
    } else if (sortBy == "addedlast") {
      result = all.query("favorite = true SORT(addedDate DESC)");
    }
    return result;
  }

  RealmResults<Item> getOpenedItems([String sortBy = "az"]) {
    var pantryitems = getPantryItems();
    var opened = pantryitems.query(
      "openedDate != null",
    );
    late RealmResults<Item> sorted;
    if (sortBy == "az") {
      sorted = opened.query("location = \$0 SORT(name ASC)", ["Pantry"]);
    } else if (sortBy == "expdate") {
      sorted = opened.query("location = \$0 SORT(expiryDate ASC)", ["Pantry"]);
    } else if (sortBy == "addedlast") {
      sorted = opened.query("location = \$0 SORT(addedDate DESC)", ["Pantry"]);
    }
    return sorted;
  }

  RealmResults<Item> getUsedItems() {
    var all = getItems();
    var result = all.query("location == \$0", ["Used"]);
    return result;
  }

  RealmResults<Item> getBinItems() {
    var all = getItems();
    var result = all.query("location == \$0", ["Bin"]);
    return result;
  }

  int getCatCount(int category) {
    var count = getPantryItems().query("mainCat == \$0", [category]).length;
    return count;
  }

  RealmResults<Item> getByMainCat(int category, [String sortBy = "az"]) {
    var pantryitems = getPantryItems();
    late RealmResults<Item> result;
    if (sortBy == "az") {
      result = pantryitems.query("mainCat = \$0 SORT(name ASC)", [category]);
    } else if (sortBy == "expdate") {
      result =
          pantryitems.query("mainCat = \$0 SORT(expiryDate ASC)", [category]);
    } else if (sortBy == "addedlast") {
      result =
          pantryitems.query("mainCat = \$0 SORT(addedDate DESC)", [category]);
    }
    // var result =
    //     pantryitems.query("mainCat == \$0 SORT(name DESC)", [category]);
    return result;
  }

  /*
  MODIFYING ITEMS
  */

  bool upsertItem(Item item) {
    try {
      realm.write(() {
        realm.add<Item>(item, update: true);
      });
      notifyListeners();
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool toggleItemFavorite(Item item) {
    try {
      realm.write(
        () {
          if (item.favorite == false) {
            item.favorite = true;
          } else {
            item.favorite = false;
          }
        },
      );
      notifyListeners();
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  void changeLocation(Item item, String newLoc) {
    realm.write(() {
      item.location = newLoc;
    });

    if (newLoc == "Used" || newLoc == "Bin") {
      realm.write(
        () {
          item.usedYear = DateTime.now().year;
          item.usedMonth = DateTime.now().month;
        },
      );
    }
    notifyListeners();
  }

  void deleteItem(Item item) {
    try {
      realm.write(() {
        realm.delete(item);
      });
      notifyListeners();
    } on RealmException catch (e) {
      debugPrint(e.message);
    }
  }

  void deleteAll() {
    realm.write(() {
      realm.deleteAll<Item>();
    });
    notifyListeners();
  }

  /*
  FOR HISTORY/STATS PAGE
  */

  RealmResults<Item> getByYearMonthUsed(int month) {
    var all = getUsedItems();
    var result = all.query(
        "usedYear == \$0 AND usedMonth == \$1", [DateTime.now().year, month]);
    return result;
  }

  RealmResults<Item> getByYearMonthBin(int month) {
    var all = getBinItems();
    var result = all.query(
        "usedYear == \$0 AND usedMonth == \$1", [DateTime.now().year, month]);
    return result;
  }

  String countByMonth(int month, String selectedView) {
    var usedItems = getByYearMonthUsed(month).length;
    var binItems = getByYearMonthBin(month).length;
    var allCount = usedItems + binItems;
    if (allCount > 0) {
      var percentage = usedItems / allCount * 100;
      if (selectedView == "used") {
        return percentage.toStringAsFixed(0);
      } else {
        return (100 - percentage).toStringAsFixed(0);
      }
    } else {
      return "0";
    }
  }
}
