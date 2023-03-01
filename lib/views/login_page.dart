import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:visitor_power_buddy/views/forgot_password.dart';
import 'package:visitor_power_buddy/views/home_page.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';
import 'package:visitor_power_buddy/resources/styles/formstyles.dart';

import '../resources/styles/textstyles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key,});

  @override
  State<LoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginPage> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  Widget logoHead() {
    return const Padding(
      padding: EdgeInsets.all(48.0),
      child: Center(
        child: Image(
          image: AssetImage('assets/images/visitor_power_logo.png'),
        ),
      ),
    );
  }

  Widget loginFields() {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login',
            style: titleHeadText,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Text(
            'Email Address',
            style: fieldHeadText,
          ),
          TextFormField(
            decoration: textFormStyle('Email Address'),
            controller: emailTextController,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password',
                style: fieldHeadText,
              ),
              InkWell(
                onTap: () {
                  _forgotPassword(context);
                },
                child: Text(
                  'Forgot Password?',
                  style: hyperLinkText,
                ),
              )
            ],
          ),
          TextFormField(
            decoration: textFormStyle('Password'),
            controller: passwordTextController,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          InkWell(
            onTap: () {
              _login(context);
            },
            child: Container(
              width: double.infinity, height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: mainColour
              ),
              child: Center(
                child: Text(
                  'Login',
                  style: buttonText,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: fieldHeadText,
              ),
              InkWell(
                onTap: () {
                  _createAccount();
                },
                child: Text(
                  'Create Account',
                  style: hyperLinkText,
                ),
              )
            ],
          )
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: ListView(
          children: [
            logoHead(),
            loginFields(),
          ],
        ),
      ),
    );
  }
}



//Methods for page functionality
void _forgotPassword(BuildContext context) {
  log('Tapped Forgot Password');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const ForgotPasswordPage(),
    ),
  );
}

void _login(BuildContext context) {
  log('Tapped Login, for now it will simply redirect to the home page. Later will'
      'need to add in account verification and saving authentication token');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const HomePage(),
    ),
  );
}

void _createAccount() {
  log('Tapped Create Account');
}


//TODO
//________________________
//- Add animation to login button that shrinks and grows the button on click
//- Write logic for each button function