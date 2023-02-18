import 'package:isar/isar.dart';
part "item.g.dart";

@Collection()
class Item {
  Id id = Isar.autoIncrement;
  late String? isbn;
  late String name;
  late int? quantity;
  late float? price;
  late DateTime? purchaseDate;
  late DateTime? openedDate;
  late DateTime? expiryDate;
  late DateTime? bbDate;
  late List<String>? categories;
  late List<String>? labels;
  late List<String>? ingredients;
  late String? processing;
  late String? nutritionGrade;
  late List<String>? nutriments;
  late String? ecoscoreGrade;
  late String? packaging;
  late String? origins;

  @enumerated
  late Amount amount;
}

enum Amount { empty, low, half, full }
