import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';
import 'package:visitor_power_buddy/resources/styles/formstyles.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';

import '../resources/widgets/shared_tools.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({super.key,});

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController tenantIDController = TextEditingController();

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
      padding: const EdgeInsets.all(48.0),
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
            keyboardType: TextInputType.emailAddress,
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
            controller: emailAddressController,
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