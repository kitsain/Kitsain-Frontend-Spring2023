import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';
import 'package:flutter/material.dart';
part 'item.g.dart';

// Creating the data model class
@RealmModel()
class _Item {
  @PrimaryKey()
  late final ObjectId id;
  @required
  late String name;
  late String? isbn;
  late int? quantity;
  late double? price;
  late DateTime? purchaseDate;
  late DateTime? openedDate;
  late DateTime? expiryDate;
  late DateTime? bbDate;
  late List<String?> categories;
  late List<String?> labels;
  late List<String?> ingredients;
  late String? processing;
  late String? nutritionGrade;
  late List<String?> nutriments;
  late String? ecoscoreGrade;
  late String? packaging;
  late String? origins;
}

// Idk what this does tbh, but it made the errors go away!
class Helpers {
  late Realm realm;

  Helpers() {
    // Configuring a local realm
    var config = Configuration.local([Item.schema]);
    var realm = Realm(config);

    var testItem = Item(ObjectId(), "test");
    realm.write(() {
      realm.add(testItem);
    });

    debugPrint(testItem.name);
  }
}
