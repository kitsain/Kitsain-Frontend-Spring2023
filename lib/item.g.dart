// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Item extends _Item with RealmEntity, RealmObjectBase, RealmObject {
  Item(
    ObjectId id,
    String name, {
    String? isbn,
    int? quantity,
    double? price,
    DateTime? purchaseDate,
    DateTime? openedDate,
    DateTime? expiryDate,
    DateTime? bbDate,
    String? processing,
    String? nutritionGrade,
    String? ecoscoreGrade,
    String? packaging,
    String? origins,
    Iterable<String?> categories = const [],
    Iterable<String?> labels = const [],
    Iterable<String?> ingredients = const [],
    Iterable<String?> nutriments = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'isbn', isbn);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'purchaseDate', purchaseDate);
    RealmObjectBase.set(this, 'openedDate', openedDate);
    RealmObjectBase.set(this, 'expiryDate', expiryDate);
    RealmObjectBase.set(this, 'bbDate', bbDate);
    RealmObjectBase.set(this, 'processing', processing);
    RealmObjectBase.set(this, 'nutritionGrade', nutritionGrade);
    RealmObjectBase.set(this, 'ecoscoreGrade', ecoscoreGrade);
    RealmObjectBase.set(this, 'packaging', packaging);
    RealmObjectBase.set(this, 'origins', origins);
    RealmObjectBase.set<RealmList<String?>>(
        this, 'categories', RealmList<String?>(categories));
    RealmObjectBase.set<RealmList<String?>>(
        this, 'labels', RealmList<String?>(labels));
    RealmObjectBase.set<RealmList<String?>>(
        this, 'ingredients', RealmList<String?>(ingredients));
    RealmObjectBase.set<RealmList<String?>>(
        this, 'nutriments', RealmList<String?>(nutriments));
  }

  Item._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => throw RealmUnsupportedSetError();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get isbn => RealmObjectBase.get<String>(this, 'isbn') as String?;
  @override
  set isbn(String? value) => RealmObjectBase.set(this, 'isbn', value);

  @override
  int? get quantity => RealmObjectBase.get<int>(this, 'quantity') as int?;
  @override
  set quantity(int? value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  double? get price => RealmObjectBase.get<double>(this, 'price') as double?;
  @override
  set price(double? value) => RealmObjectBase.set(this, 'price', value);

  @override
  DateTime? get purchaseDate =>
      RealmObjectBase.get<DateTime>(this, 'purchaseDate') as DateTime?;
  @override
  set purchaseDate(DateTime? value) =>
      RealmObjectBase.set(this, 'purchaseDate', value);

  @override
  DateTime? get openedDate =>
      RealmObjectBase.get<DateTime>(this, 'openedDate') as DateTime?;
  @override
  set openedDate(DateTime? value) =>
      RealmObjectBase.set(this, 'openedDate', value);

  @override
  DateTime? get expiryDate =>
      RealmObjectBase.get<DateTime>(this, 'expiryDate') as DateTime?;
  @override
  set expiryDate(DateTime? value) =>
      RealmObjectBase.set(this, 'expiryDate', value);

  @override
  DateTime? get bbDate =>
      RealmObjectBase.get<DateTime>(this, 'bbDate') as DateTime?;
  @override
  set bbDate(DateTime? value) => RealmObjectBase.set(this, 'bbDate', value);

  @override
  RealmList<String?> get categories =>
      RealmObjectBase.get<String?>(this, 'categories') as RealmList<String?>;
  @override
  set categories(covariant RealmList<String?> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String?> get labels =>
      RealmObjectBase.get<String?>(this, 'labels') as RealmList<String?>;
  @override
  set labels(covariant RealmList<String?> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String?> get ingredients =>
      RealmObjectBase.get<String?>(this, 'ingredients') as RealmList<String?>;
  @override
  set ingredients(covariant RealmList<String?> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get processing =>
      RealmObjectBase.get<String>(this, 'processing') as String?;
  @override
  set processing(String? value) =>
      RealmObjectBase.set(this, 'processing', value);

  @override
  String? get nutritionGrade =>
      RealmObjectBase.get<String>(this, 'nutritionGrade') as String?;
  @override
  set nutritionGrade(String? value) =>
      RealmObjectBase.set(this, 'nutritionGrade', value);

  @override
  RealmList<String?> get nutriments =>
      RealmObjectBase.get<String?>(this, 'nutriments') as RealmList<String?>;
  @override
  set nutriments(covariant RealmList<String?> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get ecoscoreGrade =>
      RealmObjectBase.get<String>(this, 'ecoscoreGrade') as String?;
  @override
  set ecoscoreGrade(String? value) =>
      RealmObjectBase.set(this, 'ecoscoreGrade', value);

  @override
  String? get packaging =>
      RealmObjectBase.get<String>(this, 'packaging') as String?;
  @override
  set packaging(String? value) => RealmObjectBase.set(this, 'packaging', value);

  @override
  String? get origins =>
      RealmObjectBase.get<String>(this, 'origins') as String?;
  @override
  set origins(String? value) => RealmObjectBase.set(this, 'origins', value);

  @override
  Stream<RealmObjectChanges<Item>> get changes =>
      RealmObjectBase.getChanges<Item>(this);

  @override
  Item freeze() => RealmObjectBase.freezeObject<Item>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Item._);
    return const SchemaObject(ObjectType.realmObject, Item, 'Item', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('isbn', RealmPropertyType.string, optional: true),
      SchemaProperty('quantity', RealmPropertyType.int, optional: true),
      SchemaProperty('price', RealmPropertyType.double, optional: true),
      SchemaProperty('purchaseDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('openedDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('expiryDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('bbDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('categories', RealmPropertyType.string,
          optional: true, collectionType: RealmCollectionType.list),
      SchemaProperty('labels', RealmPropertyType.string,
          optional: true, collectionType: RealmCollectionType.list),
      SchemaProperty('ingredients', RealmPropertyType.string,
          optional: true, collectionType: RealmCollectionType.list),
      SchemaProperty('processing', RealmPropertyType.string, optional: true),
      SchemaProperty('nutritionGrade', RealmPropertyType.string,
          optional: true),
      SchemaProperty('nutriments', RealmPropertyType.string,
          optional: true, collectionType: RealmCollectionType.list),
      SchemaProperty('ecoscoreGrade', RealmPropertyType.string, optional: true),
      SchemaProperty('packaging', RealmPropertyType.string, optional: true),
      SchemaProperty('origins', RealmPropertyType.string, optional: true),
    ]);
  }
}
