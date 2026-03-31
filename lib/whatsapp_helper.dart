// lib/whatsapp_helper.dart
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html; // Only used for Web

Future<void> sendWhatsAppRequest(String number, String message) async {
  number = number.replaceAll('+', '');
  final url = 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';

  if (kIsWeb) {
    // Opens in new browser tab for Web
    html.window.open(url, '_blank');
  } else {
    // Mobile: use url_launcher
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
