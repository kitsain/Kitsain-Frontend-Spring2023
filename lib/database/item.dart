import 'package:realm/realm.dart';
part 'item.g.dart';

/*
If a change is made to the item model, a migration error will occur,
as the item's no longer follow it. If that happens, either navigate to 
your phone's data folder and delete realm files. For me this is 
this is /data/data/com.example.kitsain_frontend_spring2023/files. You can also
delete the database by running Realm.deleteRealm(Configuration.defaultPath)

The only mandatory fields for an item are:
- String id, generated from Realm's ObjectID-class
- String name, inputted either through scanning a barcode or through Add item -form,
*/

@RealmModel()
class _Item {
  @PrimaryKey()
  late final String id; // This will NOT be shown to the user
  late String name;
  late String? barcode;
  late String? brand;
  late int? quantity;
  late double? price;
  late DateTime? addedDate;
  late DateTime? openedDate;
  late DateTime? expiryDate;
  late DateTime? usedDate;
  late String? mainCat;
  late List<String?> categories;
  late List<String?> labels;
  late List<String?> ingredients;
  late String? processing;
  late String? nutritionGrade;
  late List<String?> nutriments;
  late String? ecoscoreGrade;
  late String? packaging;
  late String? origins;
  late String? location; // Pantry, used, bin, new; Not shown to user
  late bool? everyday = false;
}
