import 'package:flutter/material.dart';
import 'package:iboss/components/show_snackbar.dart';

showConfirmation({
  required BuildContext context,
  required String title,
  required onPressed,
  required String messegerSnack,
  required bool isError,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'NÃO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onPressed();
                    Navigator.pop(context);
                    showSnackbar(context: context, menssager: messegerSnack, isError: isError);
                  },
                  child: const Text(
                    'SIM',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
