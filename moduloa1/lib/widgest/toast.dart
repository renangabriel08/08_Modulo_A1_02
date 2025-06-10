import 'package:flutter/material.dart';
import 'package:moduloa1/styles/styles.dart';

class MyToast {
  static get(String txt, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Cores.azulClaro,
        content: Text(txt, style: TextStyle(color: Cores.branco)),
      ),
    );
  }
}
