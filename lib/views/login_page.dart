import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:visitor_power_buddy/api/account_management_apis.dart';
import 'package:visitor_power_buddy/resources/widgets/shared_tools.dart';
import 'package:visitor_power_buddy/views/forgot_password.dart';
import 'package:visitor_power_buddy/views/home_page.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';
import 'package:visitor_power_buddy/resources/styles/formstyles.dart';
import 'package:visitor_power_buddy/views/register_account.dart';

import '../resources/styles/textstyles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key,});

  @override
  State<LoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginPage> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  double startPos = 0.0;
  double endPosFields = 0.0;
  double endPosTitle = 0.0;
  bool tapped = false;

  Widget logoHead() {
    return TweenAnimationBuilder(
        tween: Tween<Offset>(begin: Offset(0, startPos), end: Offset(0, endPosTitle),),
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 200),
        builder: (context, offset, child) {
          return FractionalTranslation(
            translation: offset,
            child: child,
          );
        },
        child: const Padding(
          padding: EdgeInsets.all(48.0),
          child: Center(
            child: Image(
              image: AssetImage('assets/images/visitor_power_logo.png'),
            ),
          ),
        ),
    );
  }

  Widget loginFields() {

    return TweenAnimationBuilder(
        tween: Tween<Offset>(begin: Offset(0, startPos), end: Offset(0, endPosFields),),
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 250),
        builder: (context, offset, child) {
          return FractionalTranslation(
            translation: offset,
            child: child,
          );
        },
        onEnd: () {
          if (tapped) {
            //This needs to happen when returning to this page with device back button
            setState(() {
              tapped = false;
              endPosFields = 0.0;
              endPosTitle = 0.0;
            });
          }
        },
        child: Padding(
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
                  keyboardType: TextInputType.emailAddress,
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
                  obscureText: true,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                InkWell(
                  onTap: () async {
                    if (emailTextController.text.isEmpty || passwordTextController.text.isEmpty) {
                      showSnackBar(context, 'Both fields must be filled!');
                      return;
                    }

                    _login(context, emailTextController.text, encryptPassword(passwordTextController.text));

                    setState(() {
                      tapped = true;
                      endPosFields = 2.0;
                      endPosTitle = -2;
                    });
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
                        _createAccount(context);
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

void _login(BuildContext context, String email, String password) async {
  loadingDialog(context);
  Response result = await validateLogin(email, password);

  if (result.body.contains('Success')) {
    Navigator.pop(context);
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: const HomePage(),
      ),
    );
  }
  else {
    Navigator.pop(context);
    showSnackBar(context, 'Login failed!');
  }
  
}

void _createAccount(BuildContext context) {
  log('Tapped Create Account');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const RegisterAccount(),
    ),
  );
}


//TODO
//________________________
//- Add animation to login button that shrinks and grows the button on click
//- Write logic for each button function