import 'package:realm/realm.dart';
import 'package:flutter/material.dart';
part 'item.g.dart';

// Defining item fields
@RealmModel()
class _Item {
  @PrimaryKey()
  late final ObjectId id;
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

// Creating a configuration object
final config = Configuration.local([Item.schema]);

// Opening a Realm
final realm = Realm(config);
