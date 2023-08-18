import 'dart:convert';

import 'package:flutter/material.dart' hide Page;
import 'package:nexaflow_flutter_sdk/nexaflow_flutter_sdk.dart';
import '../models/Product.dart';

class SdkProvider extends ChangeNotifier {
  final NexaflowSdk _sdk = NexaflowSdk(apiKey: 'API_KEY');

  Map<String, dynamic> otp = {};

  bool _loading = false;
  bool get loading => _loading;

  final String websiteId = 'WEBSITE_ID';
  final String popularProductsPageId = 'POPULAR_PRODUCT_PAGE_ID';
  final String verifyEmailCorsId = 'VERIFY_EMAIL_CORS_ID';

  Future<void> _update(Function function) async {
    _loading = true;
    notifyListeners();
    await function.call();
    _loading = false;
    notifyListeners();
  }

  Future<void> verifyEmail({required String email}) async {
    await _update(
      () async {
        try {
          otp = await _sdk.verifyEmail(id: verifyEmailCorsId, email: email);
        } catch (e) {
          debugPrint(e.toString());
        }
      },
    );
  }

  Future<List<Product>> getPopularProducts() async {
    try {
      Page page = await _sdk.getPageById(
        websiteId: websiteId,
        pageId: popularProductsPageId,
      );
      return page.blocks
          .map((block) => Product.fromJson(jsonDecode(block.blockData)))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
