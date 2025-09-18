import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void showFirebaseErrorSnack(BuildContext context, Object? error) {
  String errorMessage;
  if (error is FirebaseException) {
    errorMessage = error.message ?? "Something went wrong.";
  } else {
    errorMessage = error?.toString() ?? "Something went wrong.";
  }

  final snackBar = SnackBar(
    showCloseIcon: true,
    closeIconColor: Colors.white,
    content: Text(errorMessage),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String toImageUrl(String imageUrl) =>
    "https://firebasestorage.googleapis.com/v0/b/yeong-clova-mood.firebasestorage.app/o/${imageUrl.substring(1).replaceAll("/", "%2F")}?alt=media&token=b82bba9f-42ed-46c1-a5b8-71fa172acd09";
