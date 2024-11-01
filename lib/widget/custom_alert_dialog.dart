import 'package:bus_way/theme/colors.dart';
import 'package:flutter/material.dart';

Future<dynamic> showCustomAlertDialog(
    BuildContext context, String dialogTitle) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          dialogTitle,
          style: const TextStyle(
            fontSize: 15.0,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              return Navigator.of(context, rootNavigator: true).pop(true);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: orchid,
              side: const BorderSide(color: orchid),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            child: const Text('확인'),
          ),
          OutlinedButton(
            onPressed: () {
              return Navigator.of(context, rootNavigator: false).pop(false);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.black),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            child: const Text('취소'),
          ),
        ],
      );
    },
  );
}
