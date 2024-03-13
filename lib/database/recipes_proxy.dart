import 'package:realm/realm.dart';
import 'package:flutter/foundation.dart';
import 'item.dart';
import 'realmsetup.dart';

var realm = RealmSetup.getRealm();

class RecipeProxy with ChangeNotifier {
  RealmResults<Recipe> getItems() {
    var all = realm.all<Recipe>();
    return all;
  }

  subscribe() {
    final recipes = getItems();
    recipes.changes.listen(
      (changes) {
        changes.inserted; // indexes of inserted objects
        changes.modified; // indexes of modified objects
        changes.deleted; // indexes of deleted objects
        changes.newModified; // indexes of modified objects
        // after deletions and insertions are accounted for
        changes.moved; // indexes of moved objects
        changes.results; // the full List of objects
      },
    );
  }
  /*
  GETTERS
  */

  /// Gets all recipes from the database
  RealmResults<Recipe> getRecipes([String sortBy = "az"]) {
    var all = getItems();

    return all;
  }

  /// Gets only the recipes that are favorited from the database
  RealmResults<Recipe> getFavouriteRecipes([String sortBy = "az"]) {
    var all = getRecipes();
    late RealmResults<Recipe> result;
    if (sortBy == "az") {
      result = all.query("favorite = true SORT(name ASC)");
    } else if (sortBy == "expdate") {
      result = all.query("favorite = true SORT(expiryDate ASC)");
    } else if (sortBy == "addedlast") {
      result = all.query("favorite = true SORT(addedDate DESC)");
    }
    return result;
  }

  /*
  MODIFYING ITEMS
  */

  /// Inserts the [recipe] into the database
  /// Returns true if succesful, false otherwise
  bool upsertRecipe(Recipe recipe) {
    try {
      realm.write(() {
        realm.add<Recipe>(recipe, update: true);
      });
      notifyListeners();
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  /// Deletes the [recipe] from the database
  void deleteRecipe(Recipe recipe) {
    try {
      realm.write(() {
        realm.delete(recipe);
      });
      notifyListeners();
    } on RealmException catch (e) {
      debugPrint(e.message);
    }
  }
  /// Deletes all recipes from the database
  void deleteAll() {
    realm.write(() {
      realm.deleteAll<Recipe>();
    });
    notifyListeners();
  }

  int getCatCount(int category) {
    var count = getRecipes().query("mainCat == \$0", [category]).length;
    return count;
  }
}
