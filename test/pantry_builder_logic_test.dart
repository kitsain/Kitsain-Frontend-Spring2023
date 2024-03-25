import 'package:flutter_test/flutter_test.dart';
import 'package:kitsain_frontend_spring2023/assets/pantry_builder_recipe_generation.dart';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:mockito/mockito.dart';
import 'package:realm/realm.dart';

class MockRealmResults<T> extends Mock implements RealmResults<T> {
  @override
  int get length => 0;
  @override
  Iterator<T> get iterator => <T>[].iterator;
}

void main() {
  group('PantryBuilderLogic', () {
    late PantryBuilderLogic logic;
    setUp(() {
      logic = PantryBuilderLogic();
    });

    test('getOptionalItemsNames returns correct names', () {
      // Add some items to the optionalItems list
      logic.optionalItems = [Item("3", "pinapple", "Fridge", 1)];
      var result = logic.getOptionalItemsNames();

      // Check that the result is correct
      expect(result, equals(["pinapple"]));
    });

    // Add more tests for the other methods in the PantryBuilderLogic class
  });
}