import 'package:flutter/material.dart';

showSnackbar(
    {required BuildContext context,
    required String menssager,
    bool isError = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(menssager),
    backgroundColor: (isError) ? Colors.red : const Color(0xFF5CE1E6),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
