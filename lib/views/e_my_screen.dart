import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyScreen extends ConsumerStatefulWidget {
  static const routeName = "mine";
  static const routeUrl = "/mine";

  const MyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
