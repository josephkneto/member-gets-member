import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/referrals/referral_service.dart';

class DeepLinksHandler {
  DeepLinksHandler(this._service);
  final ReferralService _service;
  StreamSubscription? _sub;

  Future<void> start() async {
    final appLinks = AppLinks();
    try {
      final initial = await appLinks.getInitialLink();
      if (initial != null) await _handleUri(initial);
    } on PlatformException {
      // ignore
    }
    _sub = appLinks.uriLinkStream.listen((uri) async {
      await _handleUri(uri);
    }, onError: (_) {});
  }

  Future<void> _handleUri(Uri uri) async {
    if (uri.scheme == 'myapp' && uri.host == 'referral') {
      final code = uri.queryParameters['code'];
      if (code != null && code.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pending_referral_code', code);
      }
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
  }
}

Future<void> capturePendingReferralCodeOnce() async {
  try {
    final appLinks = AppLinks();
    final initial = await appLinks.getInitialLink();
    if (initial != null &&
        initial.scheme == 'myapp' &&
        initial.host == 'referral') {
      final code = initial.queryParameters['code'];
      if (code != null && code.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pending_referral_code', code);
      }
    }
  } on PlatformException {
    // ignore
  }
}
