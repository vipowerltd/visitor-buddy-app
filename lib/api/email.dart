import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../resources/widgets/shared_tools.dart';

String username = "notifications@thekeypower.co.uk";
String password = "Guv03529";

final smtpServer = SmtpServer(
  'smtp-mail.outlook.com',
  port: 587,
  username: username,
  password: password,
);

Future<bool> sendEmail(String email, String code, BuildContext context) async {

  final message = Message()
    ..from = Address(username, 'VisitorPower Password Reset')
    ..recipients.add(email)
    ..subject = 'VisitorPower Password Reset'
    ..html = '<p>A password reset has been requested for an account with this email for VisitorPower.</p>'
        '<p>Enter the following code in the VisitorPower application to verify your email address:</p>'
        '<hr>'
        '<h6 style="color:blue">Reset Code:</h6>'
        '<h4>$code</h4>'
        '<br>'
        '<hr><p>If you did not request this password reset then ignore this email.</p>'
        '<p>Thank you,<br>VisitorPower</p>';

  try {
    final sendReport = await send(message, smtpServer);
    log('Message sent: $sendReport');
    showSnackBar(context, 'Reset code sent to $email.}');
    return true;
  } on MailerException catch (e) {
    log('Message not sent');
    for (var p in e.problems) {
      log('Problem: ${p.code}: ${p.msg}');
    }
    return false;
  }
}