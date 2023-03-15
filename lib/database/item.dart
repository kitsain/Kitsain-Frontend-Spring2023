import 'package:realm/realm.dart';
part 'item.g.dart';

// Defining item fields
@RealmModel()
class _Item {
  @PrimaryKey()
  late final String id;
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
//
// // A proxy of the pantry
// class PantryModel {
//   late Realm realm;
//
//   PantryModel() {
//     var config = Configuration.local([Item.schema]);
//     realm = Realm(config);
//
//     var allItems = realm.all<Item>();
//
//     // Putting some test objects in an empty pantry
//     if (allItems.isEmpty) {
//       realm.write(() {
//         realm.addAll([
//           Item(ObjectId().toString(), "carrot"),
//           Item(ObjectId().toString(), "turnip", isbn: "isbn")
//         ]);
//       });
//     }
//   }
//
//     // Get item by id
//     Item getById(ObjectId id) {
//       final item = realm.find<Item>(id)!;
//       return item;
//     }
// }