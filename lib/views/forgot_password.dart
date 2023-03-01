import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';
import 'package:visitor_power_buddy/resources/styles/formstyles.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key,});

  @override
  State<ForgotPasswordPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ForgotPasswordPage> {
  TextEditingController pw1TextController = TextEditingController();
  TextEditingController pw2TextController = TextEditingController();

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
            controller: pw1TextController,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          InkWell(
            onTap: () {
              _sendVerificationLink();
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
            //resetPassword(),
            verifyEmail()
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

void _sendVerificationLink() {
  log('Tapped Send Verification Link');
}


//TODO
//________________________
//