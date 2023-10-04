import 'package:flutter/material.dart';

showSnackbar(
    {required BuildContext context,
    required String menssager,
    bool isError = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(menssager),
    backgroundColor: (isError) ? Colors.red : Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
