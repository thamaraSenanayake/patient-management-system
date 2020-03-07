import 'dart:math';

import 'package:first/database.dart';
import 'package:first/module/sendMail.dart';

void changePassword(String id) async {
  var randomizer = new Random();
  var num = randomizer.nextInt(10);
  var num1 = randomizer.nextInt(10);
  var num2 = randomizer.nextInt(10);
  var num3 = randomizer.nextInt(10);

  String newPassword = num.toString() +
      "" +
      num1.toString() +
      "" +
      num2.toString() +
      "" +
      num3.toString();
  String response;
  await addNewPassword(
    id,
    newPassword,
  ).then((s) {
    response = s;
    Mail newMail = new Mail(
        to: response,
        subject: "passwrodChange",
        text: 'your new password '+ newPassword);
    newMail.sendMail();
  });

}
