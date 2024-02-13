import 'package:realm/realm.dart';
part 'item.g.dart';

@RealmModel()
class _Item {
  @PrimaryKey()
  late final String id; // This will NOT be shown to the user
  late String name;
  late String location;
  late int mainCat;
  late bool favorite = false;
  late String? barcode;
  late String? brand;
  late int? quantity;
  late double? price;
  late DateTime? addedDate;
  late DateTime? openedDate;
  late DateTime? expiryDate;
  late bool?
      hasExpiryDate; // used to put items with no expiry date to the bottom of the results when querying by expdate
  late int? usedMonth;
  late int? usedYear;
  late List<String?> categories;
  late List<String?> labels;
  late List<String?> ingredients;
  late String? processing;
  late String? nutritionGrade;
  late List<String?> nutriments;
  late String? ecoscoreGrade;
  late String? packaging;
  late String? origins;
  late String? details;
}

@RealmModel()
class _Recipe {
  @PrimaryKey()
  late final String id; // This will NOT be shown to the user
  late String name;
  late String? details;
}

class CategoryMaps {
  Map catEnglish = {
    1: 'New',
    2: 'Meat',
    3: 'Seafood',
    4: 'Fruit',
    5: 'Vegetables',
    6: 'Frozen',
    7: 'Drinks',
    8: 'Bread',
    9: 'Treats',
    10: 'Dairy',
    11: 'Ready meals',
    12: 'Dry & canned goods',
    13: 'Other'
  };

  Map catFinnish = {
    1: 'Uudet',
    2: 'Liha',
    3: 'Merenantimet',
    4: 'Hedelmät',
    5: 'Vihannekset',
    6: 'Pakasteet',
    7: 'Juomat',
    8: 'Leivät',
    9: 'Herkut',
    10: 'Maitotuotteet',
    11: 'Valmisateriat',
    12: 'Kuivatuotteet',
    13: 'Muut'
  };
}
