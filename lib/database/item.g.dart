// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Item extends _Item with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Item(
    String id,
    String name,
    String location,
    int mainCat, {
    bool favorite = false,
    String? barcode,
    String? brand,
    int? quantity,
    double? price,
    DateTime? addedDate,
    DateTime? openedDate,
    DateTime? expiryDate,
    bool? hasExpiryDate,
    int? usedMonth,
    int? usedYear,
    String? processing,
    String? nutritionGrade,
    String? ecoscoreGrade,
    String? packaging,
    String? origins,
    String? details,
    Iterable<String?> categories = const [],
    Iterable<String?> labels = const [],
    Iterable<String?> ingredients = const [],
    Iterable<String?> nutriments = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Item>({
        'favorite': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'location', location);
    RealmObjectBase.set(this, 'mainCat', mainCat);
    RealmObjectBase.set(this, 'favorite', favorite);
    RealmObjectBase.set(this, 'barcode', barcode);
    RealmObjectBase.set(this, 'brand', brand);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'addedDate', addedDate);
    RealmObjectBase.set(this, 'openedDate', openedDate);
    RealmObjectBase.set(this, 'expiryDate', expiryDate);
    RealmObjectBase.set(this, 'hasExpiryDate', hasExpiryDate);
    RealmObjectBase.set(this, 'usedMonth', usedMonth);
    RealmObjectBase.set(this, 'usedYear', usedYear);
    RealmObjectBase.set(this, 'processing', processing);
    RealmObjectBase.set(this, 'nutritionGrade', nutritionGrade);
    RealmObjectBase.set(this, 'ecoscoreGrade', ecoscoreGrade);
    RealmObjectBase.set(this, 'packaging', packaging);
    RealmObjectBase.set(this, 'origins', origins);
    RealmObjectBase.set(this, 'details', details);
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
  String get location =>
      RealmObjectBase.get<String>(this, 'location') as String;
  @override
  set location(String value) => RealmObjectBase.set(this, 'location', value);

  @override
  int get mainCat => RealmObjectBase.get<int>(this, 'mainCat') as int;
  @override
  set mainCat(int value) => RealmObjectBase.set(this, 'mainCat', value);

  @override
  bool get favorite => RealmObjectBase.get<bool>(this, 'favorite') as bool;
  @override
  set favorite(bool value) => RealmObjectBase.set(this, 'favorite', value);

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
  bool? get hasExpiryDate =>
      RealmObjectBase.get<bool>(this, 'hasExpiryDate') as bool?;
  @override
  set hasExpiryDate(bool? value) =>
      RealmObjectBase.set(this, 'hasExpiryDate', value);

  @override
  int? get usedMonth => RealmObjectBase.get<int>(this, 'usedMonth') as int?;
  @override
  set usedMonth(int? value) => RealmObjectBase.set(this, 'usedMonth', value);

  @override
  int? get usedYear => RealmObjectBase.get<int>(this, 'usedYear') as int?;
  @override
  set usedYear(int? value) => RealmObjectBase.set(this, 'usedYear', value);

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
  String? get details =>
      RealmObjectBase.get<String>(this, 'details') as String?;
  @override
  set details(String? value) => RealmObjectBase.set(this, 'details', value);

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
      SchemaProperty('location', RealmPropertyType.string),
      SchemaProperty('mainCat', RealmPropertyType.int),
      SchemaProperty('favorite', RealmPropertyType.bool),
      SchemaProperty('barcode', RealmPropertyType.string, optional: true),
      SchemaProperty('brand', RealmPropertyType.string, optional: true),
      SchemaProperty('quantity', RealmPropertyType.int, optional: true),
      SchemaProperty('price', RealmPropertyType.double, optional: true),
      SchemaProperty('addedDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('openedDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('expiryDate', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('hasExpiryDate', RealmPropertyType.bool, optional: true),
      SchemaProperty('usedMonth', RealmPropertyType.int, optional: true),
      SchemaProperty('usedYear', RealmPropertyType.int, optional: true),
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
      SchemaProperty('details', RealmPropertyType.string, optional: true),
    ]);
  }
}

class Recipe extends _Recipe with RealmEntity, RealmObjectBase, RealmObject {
  Recipe(
    String id,
    String name, {
    String? details,
    String? recipeType,
    bool? pantryonly,
    Iterable<String?> selectedItems = const [],
    Iterable<String?> supplies = const [],
    Iterable<String?> expSoon = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'details', details);
    RealmObjectBase.set(this, 'recipeType', recipeType);
    RealmObjectBase.set(this, 'pantryonly', pantryonly);
    RealmObjectBase.set<RealmList<String?>>(
        this, 'selectedItems', RealmList<String?>(selectedItems));
    RealmObjectBase.set<RealmList<String?>>(
        this, 'supplies', RealmList<String?>(supplies));
    RealmObjectBase.set<RealmList<String?>>(
        this, 'expSoon', RealmList<String?>(expSoon));
  }

  Recipe._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => throw RealmUnsupportedSetError();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get details =>
      RealmObjectBase.get<String>(this, 'details') as String?;
  @override
  set details(String? value) => RealmObjectBase.set(this, 'details', value);

  @override
  RealmList<String?> get selectedItems =>
      RealmObjectBase.get<String?>(this, 'selectedItems') as RealmList<String?>;
  @override
  set selectedItems(covariant RealmList<String?> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get recipeType =>
      RealmObjectBase.get<String>(this, 'recipeType') as String?;
  @override
  set recipeType(String? value) =>
      RealmObjectBase.set(this, 'recipeType', value);

  @override
  RealmList<String?> get supplies =>
      RealmObjectBase.get<String?>(this, 'supplies') as RealmList<String?>;
  @override
  set supplies(covariant RealmList<String?> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String?> get expSoon =>
      RealmObjectBase.get<String?>(this, 'expSoon') as RealmList<String?>;
  @override
  set expSoon(covariant RealmList<String?> value) =>
      throw RealmUnsupportedSetError();

  @override
  bool? get pantryonly =>
      RealmObjectBase.get<bool>(this, 'pantryonly') as bool?;
  @override
  set pantryonly(bool? value) => RealmObjectBase.set(this, 'pantryonly', value);

  @override
  Stream<RealmObjectChanges<Recipe>> get changes =>
      RealmObjectBase.getChanges<Recipe>(this);

  @override
  Recipe freeze() => RealmObjectBase.freezeObject<Recipe>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Recipe._);
    return const SchemaObject(ObjectType.realmObject, Recipe, 'Recipe', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('details', RealmPropertyType.string, optional: true),
      SchemaProperty('selectedItems', RealmPropertyType.string,
          optional: true, collectionType: RealmCollectionType.list),
      SchemaProperty('recipeType', RealmPropertyType.string, optional: true),
      SchemaProperty('supplies', RealmPropertyType.string,
          optional: true, collectionType: RealmCollectionType.list),
      SchemaProperty('expSoon', RealmPropertyType.string,
          optional: true, collectionType: RealmCollectionType.list),
      SchemaProperty('pantryonly', RealmPropertyType.bool, optional: true),
    ]);
  }
}
