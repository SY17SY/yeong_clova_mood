import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourScreen extends ConsumerStatefulWidget {
  static const routeName = "yours";
  static const routeUrl = "/yours";

  const YourScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YourScreenState();
}

class _YourScreenState extends ConsumerState<YourScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
