import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booko/app.dart'; // or your root widget

void main() {
  runApp(const ProviderScope(child: App()));
}
