// File to modify the database

import 'package:realm/realm.dart';
import 'item.dart';
import 'package:flutter/foundation.dart';

class Pantry extends ChangeNotifier {
  late Realm realm;

  Pantry() {
    var config = Configuration.local([Item.schema]);
    realm = Realm(config);
  }

  // Get item by id
  Item getById(String objectId) {
    var item = realm.find<Item>(objectId)!;
    return item;
  }

  // TODO Count items by category
  int getTagCount() {
    return 0;
  }

  // Example data for addItem
  List<dynamic> data = [
    ObjectId().toString(),
    "turnip!",
    "ean",
    "Pirkka",
    2,
    1.5,
    DateTime.now().toUtc(),
    DateTime.now().toUtc(),
    DateTime.now().toUtc(),
    DateTime.now().toUtc(),
    ["vegetables", "good stuff"],
    ["joutsenmerkki"],
    ["turnip", "healthy bits"],
    "unprocessed",
    "amazing!",
    [null],
    "not applicable",
    "plastic",
    "Qo'onoS",
    "unopened",
    false
  ];

  // Upsert one item
  // Parameter is a list. If no value is submitted in the app,
  // it should default to null
  bool addItem(List<dynamic> data) {
    try {
      // Check if the object already exists; if not, create a new ObjectId
      if (getById(data[0]).isValid == false) {
        data[0] = ObjectId();
      }
      var newItem = Item(data[0], data[1],
          barcode: data[2],
          quantity: data[3],
          price: data[4],
          addedDate: data[5],
          openedDate: data[6],
          expiryDate: data[7],
          bbDate: data[8],
          categories: data[9],
          labels: data[10],
          ingredients: data[11],
          processing: data[12],
          nutritionGrade: data[13],
          nutriments: data[14],
          ecoscoreGrade: data[15],
          packaging: data[16],
          origins: data[17],
          status: data[18],
          everyday: data[19],
          brand: data[20]);
      realm.write(() {
        realm.add<Item>(newItem, update: true);
      });
      debugPrint("Item added successfully.");
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  // Delete one item
  bool deleteItem(String id) {
    try {
      var item = realm.find<Item>(id)!;
      realm.write(() {
        realm.delete(item);
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  //Delete all items
  void deleteAll() {
    realm.write(() {
      realm.deleteAll<Item>();
    });
  }
}
