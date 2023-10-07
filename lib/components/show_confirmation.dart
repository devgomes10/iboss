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
        backgroundColor: Colors.black,
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        title: Text(
          title,
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'NÃO',
                    style: TextStyle(
                      color: const Color(0xFF5CE1E6),
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
                    style: const TextStyle(
                      color: Color(0xFF5CE1E6),
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

