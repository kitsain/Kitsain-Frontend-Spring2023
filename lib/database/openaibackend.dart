import 'dart:convert';
import 'package:kitsain_frontend_spring2023/database/item.dart';
import 'package:http/http.dart' as http;
import 'package:realm/realm.dart';


Future<Recipe> generateRecipe(String ingredients, String recipe_type,
    String exp_soon, String supplies, String pantry_only) async {
  var url = Uri.https(
      'kitsain-build-ohtuprojekti-staging.apps.ocp-test-0.k8s.it.helsinki.fi',
      '/generate');
  var headers = {"Content-Type": "application/json"};
  var requestBody = json.encode({
    'ingredients': ingredients,
    'recipe_type': recipe_type,
    'exp_soon': exp_soon,
    'supplies': supplies,
    'pantry_only': pantry_only
  });
  var response = await http.post(url, headers: headers, body: requestBody);

  print(
      "${ingredients}, ${recipe_type}, ${exp_soon}, ${supplies}, ${pantry_only}");

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  var responseMap = json.decode(response.body);

  /* The Recipe class only has these few fields so we have to hack the recipe data into those existing fields.
   * Change this when Recipe class gets more complete. */
  return Recipe(ObjectId().toString(), responseMap["recipe_name"],
      details: json
          .encode([responseMap["ingredients"], responseMap["instructions"]]));
}