import 'package:flutter/material.dart';
import 'package:iboss/components/show_snackbar.dart';

class SizeBoxForm extends StatelessWidget {
  final onPressed;
  final String stringSnack;
  final String stringButton;

  SizeBoxForm({
    super.key,
    required this.onPressed,
    required this.stringSnack,
    required this.stringButton,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: TextButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            onPressed();
            showSnackbar(
              context: context,
              isError: false,
              menssager: stringSnack,
            );
            Navigator.pop(context);
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[100],
        ),
        child: const Text(
          'Variável',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

}
