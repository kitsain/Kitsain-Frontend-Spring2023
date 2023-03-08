// File to initialize realm and to modify it

import 'package:realm/realm.dart';
import 'item.dart';
import 'package:flutter/foundation.dart';

var _config = Configuration.local([Item.schema]);
var realm = Realm(_config);

// Get all items
RealmResults<Item> getItems() {
  return realm.all<Item>();
}

// Count all items
int getItemCount() {
  return realm.all<Item>().length;
}

// TODO Count items by tag
int getTagCount(String tag) {
  return 0;
}

String testprint() {
  final apple = Item(ObjectId(), "omppu");
  realm.write(() {
    realm.add(apple);
  });
  return apple.id.toString();
}

// Get item by id
// TODO: After checking everything works, change return to ITEM
String getById(ObjectId objectId) {
  var item = realm.query<Item>("id == oid($objectId)");
  // The line commented below is an example how it works correctly (tested) without a parameter
  // TODO: test with parameter
  // var found = realm.find<Item>("id == oid(6408aa37ecb6ca10553a7d14)");
  return item[0].name;
}

// Add one item
// Parameter is a list. If no value is submitted in the app,
// it should default to null
String? addItem() {
  try {
    // Example data for addItem
    // TODO: Figure out how to make lists null
    List<dynamic> data = [
      ObjectId(),
      "additem!",
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null,
      // null
    ];
    var newItem = Item(data[0], data[1],
        isbn: data[2],
        quantity: data[2],
        price: data[3],
        purchaseDate: data[4],
        openedDate: data[5],
        expiryDate: data[6],
        bbDate: data[7],
        categories: data[8],
        // labels: data[9],
        // ingredients: data[10],
        // processing: data[11],
        // nutritionGrade: data[12],
        // nutriments: data[13],
        // ecoscoreGrade: data[14],
        // packaging: data[15],
        // origins: data[16]
        );
    realm.write(() {
      realm.add<Item>(newItem);
    });
    return newItem.name;
  } on RealmException catch (e) {
    debugPrint(e.message);
    return null;
  }
}

// TODO: Figure out how to import property key from parameter
// //Modify item property
// void modifyItem(ObjectId id, String property, dynamic data) {
//   var item = getById(id);
//   realm.write(() {
//     item.$property = data;
//   });
// }

// Delete one item
bool deleteItem(Item item) {
  try {
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
