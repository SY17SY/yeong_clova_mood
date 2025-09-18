import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void showFirebaseErrorSnack(BuildContext context, Object? error) {
  final snackBar = SnackBar(
    showCloseIcon: true,
    closeIconColor: Colors.white,
    content: Text(
      (error as FirebaseException).message ?? "Something went wrong.",
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String toImageUrl(String imageUrl) =>
    "https://firebasestorage.googleapis.com/v0/b/yeong-mood-tracker-0.firebasestorage.app/o${imageUrl.substring(1).replaceAll("/", "%2F")}?alt=media&token=b82bba9f-42ed-46c1-a5b8-71fa172acd09";
