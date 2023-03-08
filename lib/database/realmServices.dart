// File to initialize realm and to modify it

import 'package:realm/realm.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:flutter/foundation.dart';

var _config = Configuration.local([Item.schema]);
var realm = Realm(_config);

// //testing
// void testing() {
//   var testing = realm.write<Item>(() {
//     return realm.add(Item(ObjectId(), "testing"));
//   });
//   debugPrint(testing.name);
// }

// openRealm() {
//   realm = Realm(_config);
// }

// closeRealm() {
//   if (!realm.isClosed) {
//     realm.close();
//   }
// }

// Get all items
RealmResults<Item> getItems() {
  return realm.all<Item>();
}

// Get item by id
Item getById(ObjectId id) {
  var item = realm.find<Item>(id)!;
  return item;
}

// Add one item
String addItem(List<dynamic> data) {
  try {
    var newItem = Item(ObjectId(), data[0],
        isbn: data[1],
        quantity: data[2],
        price: data[3],
        purchaseDate: data[4],
        openedDate: data[5],
        expiryDate: data[6],
        bbDate: data[7],
        categories: data[8],
        labels: data[9],
        ingredients: data[10],
        processing: data[11],
        nutritionGrade: data[12],
        nutriments: data[13],
        ecoscoreGrade: data[14],
        packaging: data[15],
        origins: data[16]);
    realm.write(() {
      realm.add<Item>(newItem);
    });
    return "true";
  } on RealmException catch (e) {
    debugPrint(e.message);
    return "false";
  }
}

// //Modify item property
// void modifyItem(ObjectId id, String property, dynamic data) {
//   var item = getById(id);
//   realm.write(() {
//     item.{property} = data;
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
