import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visitor_power_buddy/resources/styles/formstyles.dart';
import 'package:visitor_power_buddy/resources/widgets/buttons.dart';
import 'package:visitor_power_buddy/resources/widgets/drawer.dart';
import 'package:visitor_power_buddy/resources/widgets/shared_tools.dart';

import '../resources/styles/colours.dart';
import '../resources/styles/textstyles.dart';
import '../resources/widgets/user.dart';

class PreRegistration extends StatefulWidget {
  const PreRegistration({super.key,});

  @override
  State<PreRegistration> createState() => _PreRegistrationState();
}

class _PreRegistrationState extends State<PreRegistration> {

  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  DateTime finalDate = DateTime.now();
  DateFormat dateFormat = DateFormat('HH:mm dd-MM-yyyy');
  File selectedImage = File('');
  bool imageUploaded = false;

  TextEditingController fullNameController = TextEditingController();
  FocusNode fnFN = FocusNode();
  TextEditingController emailAddressController = TextEditingController();
  FocusNode eaFN = FocusNode();
  TextEditingController phoneNoController = TextEditingController();
  FocusNode pnFN = FocusNode();
  TextEditingController companyNameController = TextEditingController();
  FocusNode cnFN = FocusNode();
  TextEditingController uploadedImagePath = TextEditingController();
  TextEditingController datePickerController = TextEditingController();
  TextEditingController timePickerController = TextEditingController();
  //Need to create more controllers based on how many more fields we need to accommodate for

  Widget headRow() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: mainColour, size: 50,),
            padding: EdgeInsets.zero,
            onPressed: () {
              _openDrawer(drawerKey);
            },
          ),
          userWidget()
        ],
      ),
    );
  }

  Widget pageTitle() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          gradient: blueGradientBack,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            const Icon(Icons.library_books_outlined, color: Colors.white, size: 40,),
            const SizedBox(width: 12.0),
            Text(
              'Guest Pre-Registration',
              style: titleHeadTextWhite,
            )
          ],
        ),
      ),
    );
  }

  Widget registrationForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Guest Details',
            style: titleHeadText,
          ),
          guestFields(),
          const SizedBox(height: 12.0),
          Text(
            'Upload Guest Photo',
            style: titleHeadText,
          ),
          Text(
            '(Optional)',
            style: titleHeadTextSmall,
          ),
          uploadPhoto(),
          const SizedBox(height: 12.0),
          Text(
            'Select Arrival Date/Time',
            style: titleHeadText,
          ),
          dateTimePicker(),
        ],
      ),
    );
  }
  
  Widget guestFields() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          TextFormField(
            decoration: textFormStyle('Full Name'),
            controller: fullNameController,
            focusNode: fnFN,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            decoration: textFormStyle('Email Address'),
            controller: emailAddressController,
            focusNode: eaFN,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            decoration: textFormStyle('Phone Number'),
            controller: phoneNoController,
            focusNode: pnFN,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            decoration: textFormStyle('Company Name'),
            controller: companyNameController,
            focusNode: cnFN,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget uploadPhoto() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () {
          _uploadGuestPhoto();
        },
        child: TextFormField(
          style: formHintText,
          enabled: false,
          controller: uploadedImagePath,
          decoration: uploadForm(),
        ),
      )
    );
  }

  Widget dateTimePicker() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                _openDatePicker();
              },
              child: TextFormField(
                enabled: false,
                controller: datePickerController,
                decoration: calendarForm(),
                style: formHintText,
              ),
            ),
          ),
          const SizedBox(width: 12.0,),
          Expanded(
            child: InkWell(
              onTap: () {
                _openTimePicker();
              },
              child: TextFormField(
                enabled: false,
                controller: timePickerController,
                decoration: timeForm(),
                style: formHintText,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget confirmButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 48.0, right: 48.0, top: 24.0, bottom: 24.0),
      child: Center(
        child: InkWell(
          onTap: () {
            _validateForm();
            //openConfirmationDialog();
          },
          child: mainButton('Confirm')
        ),
      ),
    );
  }
  
  void openConfirmationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are These Details Correct?', style: titleHeadText,),
            content: Container(
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 100, width: 100,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                spreadRadius: 5,
                                blurRadius: 9,
                                offset: Offset(0, 3),
                              )
                            ],
                            border: Border.all(color: mainColour, width: 2.0),
                            borderRadius: BorderRadius.circular(125),
                            image: DecorationImage(
                              image: imageUploaded? FileImage(selectedImage) : Image.asset('assets/images/default_user.png').image,
                              fit: BoxFit.cover,
                            ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        fullNameController.text,
                        style: titleHeadText,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'Email Address',
                    style: formHintText,
                  ),
                  Text(
                    emailAddressController.text,
                    style: titleHeadTextSmall,
                  ),
                  Text(
                    'Phone Number',
                    style: formHintText,
                  ),
                  Text(
                    phoneNoController.text,
                    style: titleHeadTextSmall,
                  ),
                  Text(
                    'Company',
                    style: formHintText,
                  ),
                  Text(
                    companyNameController.text,
                    style: titleHeadTextSmall,
                  ),
                  const Divider(),
                  Text(
                    'Due',
                    style: formHintText,
                  ),
                  Text(
                    dateFormat.format(finalDate),
                    style: titleHeadTextSmall,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _cancelGuestSubmission(context);
                        },
                        child: mainButton('Cancel'),
                      ),
                      InkWell(
                        onTap: () {
                          _guestSubmission();
                        },
                        child: mainButton('Submit'),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void _validateForm() {
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
    else if (phoneNoController.text.isEmpty) {
      showSnackBar(context, 'Phone Number is required!');
      FocusScope.of(context).requestFocus(pnFN);
      return;
    }
    else if (companyNameController.text.isEmpty) {
      showSnackBar(context, 'Company Name is required!');
      FocusScope.of(context).requestFocus(cnFN);
      return;
    }
    else if (datePickerController.text.isEmpty) {
      showSnackBar(context, 'Select a date for your guest to arrive!');
      return;
    }
    else if (timePickerController.text.isEmpty) {
      showSnackBar(context, 'Select a time for your guest to arrive!');
      return;
    }

    //Create the DateTime object for the selected time the visitor will arrive
    setState(() {
      finalDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute,);
    });

    //If validated, open the confirmation dialog
    openConfirmationDialog();
  }

  void _uploadGuestPhoto() async {
    log('Tapped upload guest photo');
    final ImagePicker _picker = ImagePicker();
    XFile? chosenImage = await _picker.pickImage(source: ImageSource.gallery);
    if (chosenImage != null) {
      showSnackBar(context, 'Guest Photo set!');

      setState(() {
        uploadedImagePath.text = chosenImage.name;
        selectedImage = File(chosenImage.path);
        imageUploaded = true;
      });
    }
  }

  Future<void> _openDatePicker() async {
    log('Tapped to open date picker');

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        datePickerController.text = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      });
    }
  }

  Future<void> _openTimePicker() async {
    log('Tapped to open time picker');

    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: selectedTime
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        timePickerController.text = '${selectedTime.hour}:${selectedTime.minute}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: drawer(context),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: ListView(
          children: [
            headRow(),
            pageTitle(),
            registrationForm(),
            confirmButton(),
          ],
        ),
      ),
    );
  }
}

//Methods for page functionality
void _openDrawer(GlobalKey<ScaffoldState> drawerKey) {
  log('Opened Drawer Menu');
  drawerKey.currentState?.openDrawer();
}

void _cancelGuestSubmission(BuildContext context) {
  Navigator.pop(context);
}

void _guestSubmission() {
  log('Tapped Guest Submission!');
}


//TODO
//________________________
//Form validation and interactivity is in a good spot
//
//Need to compile the input data on the confirmation dialog into a guest model and
//send to the database as a future pre-registered guest
