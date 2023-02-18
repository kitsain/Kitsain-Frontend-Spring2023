import 'package:isar/isar.dart';
import 'package:kitsain_frontend_spring2023/models/item.dart';

class IsarService {
  // Opening DB
  late Future<Isar> db;
  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([ItemSchema], inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  // Reset database
  Future<void> cleanDB() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  // Get all items
  Future<List<Item>> getAllItems() async {
    final isar = await db;
    return await isar.items.where().findAll();
  }

  // Get one item
  Future<Item?> getItem(Id itemId) async {
    final isar = await db;
    return await isar.items.get(itemId);
  }

  //Delete one item
  Future<void> deleteItem(Id itemId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.items.delete(itemId);
    });
  }

  // // Insert from OpenFoodFacts
  // Future<void> importJSON(

  // )

  // Insert custom item or modify any item
  // What form is the data sent? String list, map...?
  Future<void> addItem(Map itemInfo) async {
    final isar = await db;

    final newItem = Item()
      ..name = itemInfo["name"]
      ..quantity = itemInfo["quantity"]
      ..amount = itemInfo["amount"]
      ..price = itemInfo["price"]
      ..purchaseDate = itemInfo["purchaseDate"]
      ..openedDate = itemInfo["openedDate"]
      ..expiryDate = itemInfo["expiryDate"]
      ..bbDate = itemInfo["bbDate"]
      ..categories = itemInfo["categories"]
      ..labels = itemInfo["labels"]
      ..ingredients = itemInfo["ingredients"]
      ..processing = itemInfo["processing"]
      ..nutritionGrade = itemInfo["nutritionGrade"]
      ..nutriments = itemInfo["nutriments"]
      ..ecoscoreGrade = itemInfo["ecoscoreGrade"]
      ..packaging = itemInfo["packaging"]
      ..origins = itemInfo["origins"];

    await isar.writeTxn(() async {
      await isar.items.put(newItem);
    });
  }
}
