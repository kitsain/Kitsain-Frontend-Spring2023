import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kitsain_frontend_spring2023/views/add_forms/create_recipe.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Create new recipe form test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: CreateNewRecipeForm(),
    ));
    // Verify initial state
    expect(find.text('GENERATE A NEW RECIPE'), findsOneWidget);

    // Tap on cancel button
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

// Verify that the dialog appears
    expect(find.text('DISCARD'), findsOneWidget);

// Tap on discard in dialog
    await tester.tap(find.text('DISCARD'));
    await tester.pumpAndSettle(); // Wait for the dialog to close

// Verify that the form is closed
    expect(find.byType(CreateNewRecipeForm), findsNothing);

    // Re-open form
    await tester.pumpWidget(MaterialApp(
      home: CreateNewRecipeForm(),
    ));

    // Fill form fields
    await tester.enterText(
        find.byType(TextFormField).at(0), 'Sample Recipe Type');
    await tester.enterText(find.byType(TextFormField).at(1), 'Sample Supplies');
    await tester.enterText(
        find.byType(TextFormField).at(2), 'Sample Ingredients');
    // await tester.tap(find.text('CREATE RECIPE'));
    await tester.pump();

    // Verify that the recipe is created and form is closed
    // expect(find.byType(CreateNewRecipeForm), findsNothing);
  });
}
