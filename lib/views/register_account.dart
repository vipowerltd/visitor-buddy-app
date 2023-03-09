import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:visitor_power_buddy/api/account_management_apis.dart';
import 'package:visitor_power_buddy/api/env.dart';
import 'package:visitor_power_buddy/models/user.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';
import 'package:visitor_power_buddy/resources/styles/formstyles.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';

import '../resources/widgets/shared_tools.dart';
import 'login_page.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({super.key,});

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  TextEditingController fullNameController = TextEditingController();
  FocusNode fnFN = FocusNode();
  TextEditingController emailAddressController = TextEditingController();
  FocusNode eaFN = FocusNode();
  TextEditingController tenantIDController = TextEditingController();
  FocusNode tidFN = FocusNode();
  TextEditingController pw1Controller = TextEditingController();
  FocusNode pw1FN = FocusNode();
  TextEditingController pw2Controller = TextEditingController();
  FocusNode pw2FN = FocusNode();

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

  Widget registrationForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 48.0, right: 48.0, bottom: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Account',
            style: titleHeadTextWhiteBold,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Text(
            'Fill in all below fields to create your account for VisitorPower!',
            style: titleHeadTextWhiteSmall
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Text(
            'Full Name',
            style: fieldHeadTextWhite,
          ),
          TextFormField(
            decoration: textFormStyle('Full Name'),
            controller: fullNameController,
            focusNode: fnFN,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Text(
            'Email Address',
            style: fieldHeadTextWhite,
          ),
          TextFormField(
            decoration: textFormStyle('Email Address'),
            controller: emailAddressController,
            focusNode: eaFN,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Text(
            'Password',
            style: fieldHeadTextWhite,
          ),
          TextFormField(
            decoration: textFormStyle('Password'),
            controller: pw1Controller,
            focusNode: pw1FN,
            obscureText: true,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Text(
            'Confirm Password',
            style: fieldHeadTextWhite,
          ),
          TextFormField(
            decoration: textFormStyle('Confirm Password'),
            controller: pw2Controller,
            focusNode: pw2FN,
            obscureText: true,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tenant ID',
                style: fieldHeadTextWhite,
              ),
              InkWell(
                onTap: () {
                  _showTenantIDInfo(context);
                },
                child: Icon(Icons.info_outline_rounded, color: Colors.white,),
              )
            ],
          ),
          TextFormField(
            decoration: textFormStyle('Tenant ID'),
            controller: tenantIDController,
            focusNode: tidFN,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          InkWell(
            onTap: () {
              validateFields();
            },
            child: Container(
              width: double.infinity, height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: altColour
              ),
              child: Center(
                child: Text(
                  'Confirm',
                  style: titleHeadText,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void validateFields() {
    log('Tapped to validate form');
    //Move this method to controllers file?
    //
    //Confirm that all fields have been interacted with and filled in
    //Validate that input data is in the correct format
    //
    //Open Modal to display all input data compiled
    if (fullNameController.text.isEmpty) {
      //Show snackbar telling the user to fill the field, and auto focus the correct field
      showSnackBar(context, 'Full name is required!');
      FocusScope.of(context).requestFocus(fnFN);
      return;
    }
    else if (emailAddressController.text.isEmpty) {
      showSnackBar(context, 'Email Address is required!');
      FocusScope.of(context).requestFocus(eaFN);
      return;
    }
    else if (!emailValid(emailAddressController.text)) {
      showSnackBar(context, 'You must enter a valid email address!');
      FocusScope.of(context).requestFocus(eaFN);
      return;
    }
    else if (pw1Controller.text.isEmpty) {
      showSnackBar(context, 'Password is required!');
      FocusScope.of(context).requestFocus(pw1FN);
      return;
    }
    else if (pw2Controller.text.isEmpty) {
      showSnackBar(context, 'Password is required!');
      FocusScope.of(context).requestFocus(pw2FN);
      return;
    }
    else if (pw2Controller.text != pw1Controller.text) {
      showSnackBar(context, 'Passwords must match!');
      FocusScope.of(context).requestFocus(pw1FN);
      return;
    }
    else if (tenantIDController.text.isEmpty) {
      showSnackBar(context, 'Tenant ID is required!');
      FocusScope.of(context).requestFocus(tidFN);
      return;
    }

    callAddUserAPI();

  }

  //Consult the other registration form you made where verification refocuses to the empty field
  void callAddUserAPI() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(child: const CircularProgressIndicator(),);
        }
    );

    String fullName = fullNameController.text;
    String email = emailAddressController.text;
    String password = encryptPassword(pw1Controller.text);
    int tenant_id = int.parse(tenantIDController.text);

    User user = User(
        user_id: generateRandomString(), email: email,
        password: password, user_type: 'user',
        created_by: 111111, created_on: DateTime.now(),
        updated_on: DateTime.now(), last_login: DateTime.now(),
        image_url: '', status: true,
        is_first_login: true, reset_code: '',
        tenant_id: tenant_id, building_id: null,
        account_id: null
    );

    var response = await addUser(user);

    if (response.body.contains('tenant_id does not match') ) {
      _accountCreationFailure(context, tidFN, 'No matching tenant ID found!');
    }
    else if (response.body.contains('tenant_id is already used')) {
      _accountCreationFailure(context, tidFN, 'Account already created with this tenant ID!');
    }
    else {
      _accountCreationSuccess(context);
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
            registrationForm()
          ],
        ),
      ),
    );
  }
}

void _accountCreationSuccess(BuildContext context) {
  Navigator.pop(context);
  showSnackBar(context, 'Account created!');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const LoginPage(),
    ),
  );
}

void _accountCreationFailure(BuildContext context, FocusNode tidFN, String reason) {
  Navigator.pop(context);
  showSnackBar(context, reason);
  FocusScope.of(context).requestFocus(tidFN);
}

//Methods for page functionality
void _resetPassword() {
  log('Tapped Reset Password');
}

void _sendVerificationLink() {
  log('Tapped Send Verification Link');
}

void _showTenantIDInfo(BuildContext context) {
  showSnackBar(context, 'Your tenant ID links your account on the VisitorPower buddy app with your tenant information stored in your building. '
      'Ask at reception in your building to receive it!');
}



//TODO
//________________________
//