import 'package:cloud_firestore/cloud_firestore.dart';

// Defining item fields
class Item {
  String name;
  String? isbn;
  int? quantity;
  double? price;
  DateTime? purchaseDate;
  DateTime? openedDate;
  DateTime? expiryDate;
  DateTime? bbDate;
  List<String>? categories;
  List<String>? labels;
  List<String>? ingredients;
  String? processing;
  String? nutritionGrade;
  List<String>? nutriments;
  String? ecoscoreGrade;
  String? packaging;
  String? origins;

  // Constructor for the class with parameters
  Item(
      {required this.name,
      this.isbn,
      this.quantity,
      this.price,
      this.purchaseDate,
      this.openedDate,
      this.expiryDate,
      this.bbDate,
      this.categories,
      this.labels,
      this.ingredients,
      this.processing,
      this.nutritionGrade,
      this.nutriments,
      this.ecoscoreGrade,
      this.packaging,
      this.origins});

  // Creates a snapshot of one item
  factory Item.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Item(
        name: data?["name"],
        isbn: data?["isbn"],
        quantity: data?["quantity"],
        price: data?["price"],
        purchaseDate: data?["purchaseDate"],
        openedDate: data?["openedDate"],
        expiryDate: data?["expiryDate"],
        bbDate: data?["bbDate"],
        categories: data?["categories"] is Iterable
            ? List.from(data?["categories"])
            : null,
        labels: data?["labels"] is Iterable ? List.from(data?["labels"]) : null,
        ingredients: data?["ingredients"] is Iterable
            ? List.from(data?["ingredients"])
            : null,
        processing: data?["processing"],
        nutritionGrade: data?["nutritionGrade"],
        nutriments: data?["nutriments"] is Iterable
            ? List.from(data?["nutriments"])
            : null,
        ecoscoreGrade: data?["ecoscoreGrade"],
        packaging: data?["packaging"],
        origins: data?["origins"]);
  }

  // Adds one item to the db from a map
  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      if (isbn != null) "isbn": isbn,
      if (quantity != null) "quantity": quantity,
      if (price != null) "price": price,
      if (purchaseDate != null) "purchaseDate": purchaseDate,
      if (openedDate != null) "openedDate": openedDate,
      if (expiryDate != null) "expiryDate": expiryDate,
      if (bbDate != null) "bbDate": bbDate,
      if (categories != null) "categories": categories,
      if (labels != null) "labels": labels,
      if (ingredients != null) "ingredients": ingredients,
      if (processing != null) "processing": processing,
      if (nutritionGrade != null) "nutritionGrade": nutritionGrade,
      if (nutriments != null) "nutriments": nutriments,
      if (ecoscoreGrade != null) "ecoscoreGrade": ecoscoreGrade,
      if (packaging != null) "packaging": packaging,
      if (origins != null) "origins": origins
    };
  }
}
