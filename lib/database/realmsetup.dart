import 'package:realm/realm.dart';
import 'package:flutter/foundation.dart';
import 'item.dart';

Realm realm = RealmSetup()._initializeRealm();


class RealmSetup {
  Realm _initializeRealm() {
    var config = Configuration.local([Item.schema, Recipe.schema], shouldDeleteIfMigrationNeeded: true);
    return Realm(config);
  }


  static void test() {
    var all = realm.all<Recipe>();
    if(all.isEmpty) {
      var recipe = Recipe("Chicken soup","Throw some chickens in hot water lol",);
    realm.write(() {
      realm.add(recipe);     
      }
    );
    }
    
  }
  static Realm getRealm() {
    test();
    return realm;
  }
}