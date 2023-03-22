import 'package:realm/realm.dart';
part 'item.g.dart';

/*
If a change is made to the item model, a migration error will occur,
as the item's no longer follow it. If that happens, either navigate to 
your phone's data folder and delete realm files. For me this is 
this is /data/data/com.example.kitsain_frontend_spring2023/files. You can also
delete the database by running Realm.deleteRealm(Configuration.defaultPath)

The only mandatory fields for an item are:
- String name, inputted either through scanning a barcode or through Add item -form,
- bool everyday, which is used to toggle the everyday/favourite status of the 
  item. If true, the item will automatically be kept on the shopping list.
  The default value is set to false. 

*/

@RealmModel()
class _Item {
  @PrimaryKey()
  late final String id;
  late String name;
  late String? barcode;
  late String? brand;
  late int? quantity;
  late double? price;
  late DateTime? addedDate;
  late DateTime? openedDate;
  late DateTime? expiryDate;
  late DateTime? bbDate;
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
  late String? status;
  late bool everyday = false;
  late bool? newItem;
}
