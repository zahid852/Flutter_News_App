import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';

class GlobalMethods {
  static String formatedDateText(String publishedAt) {
    final parsedData = DateTime.parse(publishedAt);
    String formatedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(parsedData);
    DateTime publishedDataDate =
        DateFormat('yyyy-MM-dd hh:mm:ss').parse(formatedDate);
    return "${publishedDataDate.year}/${publishedDataDate.month}/${publishedDataDate.day} on ${publishedDataDate.hour}:${publishedDataDate.minute}";
  }

  static Future<void> errorDialog(
      {required String error, required BuildContext context}) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('$error'),
            title: Row(
              children: [
                Icon(
                  IconlyBold.danger,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('An error occured')
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }
}
