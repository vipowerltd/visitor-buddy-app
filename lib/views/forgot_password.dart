import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/api/account_management_apis.dart';
import 'package:visitor_power_buddy/api/email.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';
import 'package:visitor_power_buddy/resources/styles/formstyles.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';

import '../resources/widgets/shared_tools.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key,});

  @override
  State<ForgotPasswordPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ForgotPasswordPage> {
  TextEditingController pw1TextController = TextEditingController();
  TextEditingController pw2TextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController codeTextController = TextEditingController();
  bool codeVerified = false;
  bool emailSent = false;

  Widget logoHead() {
    return const Padding(
      padding: EdgeInsets.all(48.0),
      child: Center(
        child: Image(
          image: AssetImage('assets/images/visitor_power_logo_white.png'),
        ),
      ),
    );
  }

  Widget resetPassword() {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reset Your Password',
            style: titleHeadTextWhiteBold,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Text(
            'Enter New Password',
            style: fieldHeadTextWhite,
          ),
          TextFormField(
            decoration: textFormStyle('New Password'),
            controller: pw1TextController,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Text(
            'Confirm New Password',
            style: fieldHeadTextWhite,
          ),
          TextFormField(
            decoration: textFormStyle('Confirm New Password'),
            controller: pw2TextController,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          InkWell(
            onTap: () {
              _resetPassword();
            },
            child: Container(
              width: double.infinity, height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: altColour
              ),
              child: Center(
                child: Text(
                  'Reset Password',
                  style: titleHeadText,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget verifyEmail() {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify Email',
            style: titleHeadTextWhiteBold,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Text(
            'Enter Email Address',
            style: fieldHeadTextWhite,
          ),
          TextFormField(
            decoration: textFormStyle('Email Address'),
            controller: emailTextController,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          InkWell(
            onTap: () async {
              if (emailTextController.text.isEmpty) {
                showSnackBar(context, 'Please input an email address!');
                return;
              }
              var code = generateRandomString();
              await _sendVerificationLink(context, code.toString(), emailTextController.text);
              loadingDialog(context);
              bool sent = await sendEmail(emailTextController.text, code.toString(), context);
              Navigator.pop(context);

              if (sent) {
                setState(() {
                  emailSent = true;
                });
              }
              else {
                showSnackBar(context, 'Error, please try again.');
              }
            },
            child: Container(
              width: double.infinity, height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: altColour
              ),
              child: Center(
                child: Text(
                  'Reset Password',
                  style: titleHeadText,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          emailSent? verifyCodeBlock() : Container(),
        ],
      ),
    );
  }

  Widget verifyCodeBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify Code',
          style: titleHeadTextWhiteBold,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
        Text(
          'Enter the code sent to ${emailTextController.text}.',
          style: fieldHeadTextWhite,
        ),
        TextFormField(
          decoration: textFormStyle('Reset Code'),
          controller: codeTextController,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
        InkWell(
          onTap: () async {
            if (codeTextController.text.isEmpty) {
              showSnackBar(context, 'Please input a reset code!');
              return;
            }
            await _checkResetCode(context, emailTextController.text, codeTextController.text);
          },
          child: Container(
            width: double.infinity, height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: altColour
            ),
            child: Center(
              child: Text(
                'Verify Code',
                style: titleHeadText,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget activeWidget() {
    if (!codeVerified) {
      return verifyEmail();
    } else {
      return resetPassword();
    }
  }

  Future _checkResetCode(BuildContext context, String email, String code) async {
    log('Tapped check reset code!');
    loadingDialog(context);

    var result = await checkPasswordResetCode(email, code);

    if (result.body.contains('Success')) {
      Navigator.pop(context);
      setState(() {
        codeVerified = !codeVerified;
      });
    }
    else {
      showSnackBar(context, 'Invalid reset code!');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: blueGradientBack
        ),
        child: ListView(
          children: [
            logoHead(),
            activeWidget(),
          ],
        ),
      ),
    );
  }
}



//Methods for page functionality
void _resetPassword() {
  log('Tapped Reset Password');
}

Future _sendVerificationLink(BuildContext context, String code, String email) async {
  log('Tapped Send Verification Link');
  loadingDialog(context);

  var result = await setPasswordResetCode(email, code.toString());
  Navigator.pop(context);
}



//TODO
//________________________
//