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
  late String? status;
  late bool? everyday;
}