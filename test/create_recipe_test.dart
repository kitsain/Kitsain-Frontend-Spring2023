import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitsain_frontend_spring2023/views/add_forms/create_recipe.dart';

void main() {
  testWidgets('CreateNewRecipeForm Widget Test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(
      home: CreateNewRecipeForm(),
    ));

    // Verify initial state
    expect(find.byType(CreateNewRecipeForm), findsOneWidget);

    // Tap on the close button
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
    await tester.pumpWidget(const MaterialApp(
      home: CreateNewRecipeForm(),
    ));

    // Fill form fields
    await tester.enterText(
        find.byType(TextFormField).at(0), 'Sample Recipe Type');
    await tester.enterText(find.byType(TextFormField).at(1), 'Sample Supplies');
    await tester.enterText(
        find.byType(TextFormField).at(2), 'Sample Ingredients');

    // Tap on the create recipe button
    await tester.tap(find.text('CREATE RECIPE'));
    await tester.pump();

    // Verify that the recipe is created and form is closed
    expect(find.byType(CreateNewRecipeForm), findsNothing);
  });
}