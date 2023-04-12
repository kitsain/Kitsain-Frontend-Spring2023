// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Item extends _Item with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Item(
    String id,
    String name, {
    String? barcode,
    String? brand,
    int? quantity,
    double? price,
    DateTime? addedDate,
    DateTime? openedDate,
    DateTime? expiryDate,
    String? mainCat,
    String? processing,
    String? nutritionGrade,
    String? ecoscoreGrade,
    String? packaging,
    String? origins,
    String? location,
    bool? everyday = false,
    Iterable<String?> categories = const [],
    Iterable<String?> labels = const [],
    Iterable<String?> ingredients = const [],
    Iterable<String?> nutriments = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Item>({
        'everyday': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'barcode', barcode);
    RealmObjectBase.set(this, 'brand', brand);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'addedDate', addedDate);
    RealmObjectBase.set(this, 'openedDate', openedDate);
    RealmObjectBase.set(this, 'expiryDate', expiryDate);
    RealmObjectBase.set(this, 'mainCat', mainCat);
    RealmObjectBase.set(this, 'processing', processing);
    RealmObjectBase.set(this, 'nutritionGrade', nutritionGrade);
    RealmObjectBase.set(this, 'ecoscoreGrade', ecoscoreGrade);
    RealmObjectBase.set(this, 'packaging', packaging);
    RealmObjectBase.set(this, 'origins', origins);
    RealmObjectBase.set(this, 'location', location);
    RealmObjectBase.set(this, 'everyday', everyday);
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
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => throw RealmUnsupportedSetError();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get barcode =>
      RealmObjectBase.get<String>(this, 'barcode') as String?;
  @override
  set barcode(String? value) => RealmObjectBase.set(this, 'barcode', value);

  @override
  String? get brand => RealmObjectBase.get<String>(this, 'brand') as String?;
  @override
  set brand(String? value) => RealmObjectBase.set(this, 'brand', value);

  @override
  int? get quantity => RealmObjectBase.get<int>(this, 'quantity') as int?;
  @override
  set quantity(int? value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  double? get price => RealmObjectBase.get<double>(this, 'price') as double?;
  @override
  set price(double? value) => RealmObjectBase.set(this, 'price', value);

  @override
  DateTime? get addedDate =>
      RealmObjectBase.get<DateTime>(this, 'addedDate') as DateTime?;
  @override
  set addedDate(DateTime? value) =>
      RealmObjectBase.set(this, 'addedDate', value);

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
  String? get mainCat =>
      RealmObjectBase.get<String>(this, 'mainCat') as String?;
  @override
  set mainCat(String? value) => RealmObjectBase.set(this, 'mainCat', value);

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
  String? get location =>
      RealmObjectBase.get<String>(this, 'location') as String?;
  @override
  set location(String? value) => RealmObjectBase.set(this, 'location', value);

  @override
  bool? get everyday => RealmObjectBase.get<bool>(this, 'everyday') as bool?;
  @override
  set everyday(bool? value) => RealmObjectBase.set(this, 'everyday', value);

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
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('barcode', RealmPropertyType.string, optional: true),
      SchemaProperty('brand', RealmPropertyType.string, optional: true),
      SchemaProperty('quantity', RealmPropertyType.int, optional: true),
      SchemaProperty('price', RealmPropertyType.double, optional: true),
      SchemaProperty('addedDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('openedDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('expiryDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('mainCat', RealmPropertyType.string, optional: true),
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
      SchemaProperty('location', RealmPropertyType.string, optional: true),
      SchemaProperty('everyday', RealmPropertyType.bool, optional: true),
    ]);
  }
}
