import 'package:flutter/foundation.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'dart:async';

Future<Product?> getFromJson(String barcode) async {
  final config = ProductQueryConfiguration(barcode,
      language: OpenFoodFactsLanguage.ENGLISH,
      country: OpenFoodFactsCountry.FINLAND,
      fields: [
        ProductField.NAME,
        ProductField.BARCODE,
        ProductField.BRANDS,
        ProductField.CATEGORIES_TAGS_IN_LANGUAGES,
        ProductField.LABELS_TAGS_IN_LANGUAGES,
        ProductField.INGREDIENTS_TEXT_IN_LANGUAGES,
        ProductField.NOVA_GROUP,
        ProductField.NUTRISCORE,
        ProductField.NUTRIMENT_DATA_PER,
        ProductField.ECOSCORE_GRADE,
        ProductField.PACKAGINGS,
        ProductField.ORIGINS
      ],
      version: ProductQueryVersion.v3);

  ProductResultV3 result = await OpenFoodAPIClient.getProductV3(config);

  if (result.status == ProductResultV3.statusSuccess) {
    debugPrint(result.product?.productName);
    return result.product;
  } else {
    throw Exception("Product not found.");
  }
}
