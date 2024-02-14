import 'package:http/http.dart' as http;

Future<String?> generateRecipe(String ingredients, String recipe_type,
    String exp_soon, String supplies, String pantry_only) async {
  var url = Uri.https(
      'kitsain-build-ohtuprojekti-staging.apps.ocp-test-0.k8s.it.helsinki.fi',
      'whatsit/create');
  var response = await http.post(url, body: {
    'ingredients': 'ingredients',
    'recipe_type': 'recipe_type',
    'exp_soon': 'exp_soon',
    'supplies': 'supplies',
    'pantry_only': 'pantry_only'
  });

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  print(await http.read(Uri.https('example.com', 'foobar.txt')));
  return response.body;
}
