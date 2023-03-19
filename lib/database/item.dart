import 'package:realm/realm.dart';
part 'item.g.dart';

// Defining item fields
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
  late List<String?> categories;
  late List<String?> labels;
  late List<String?> ingredients;
  late String? processing;
  late String? nutritionGrade;
  late List<String?> nutriments;
  late String? ecoscoreGrade;
  late String? packaging;
  late String? origins;
  late Status? status;
  late bool? everyday;
}

@RealmModel()
enum Status {
  unopened,
  opened,
  expired,
  used
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