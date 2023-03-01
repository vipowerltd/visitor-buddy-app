import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/resources/styles/formstyles.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';

import '../resources/styles/colours.dart';
import '../resources/widgets/buttons.dart';
import '../resources/widgets/drawer.dart';
import '../resources/widgets/user.dart';

class BookMeeting extends StatefulWidget {
  const BookMeeting({super.key,});

  @override
  State<BookMeeting> createState() => _BookMeetingState();
}

class _BookMeetingState extends State<BookMeeting> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController meetingNameController = TextEditingController();

  String selectedRoom = 'None';
  //This list will be replaced by the list of room retrieved from the database for this office
  List<DropdownMenuItem<String>> roomList = [
    const DropdownMenuItem(value: 'None', child: Text('None'),),
    const DropdownMenuItem(value: 'Room 1',child: Text('Room 1'),),
    const DropdownMenuItem(value: 'Room 2',child: Text('Room 2'),),
    const DropdownMenuItem(value: 'Room 3',child: Text('Room 3'),),
    const DropdownMenuItem(value: 'Room 4',child: Text('Room 4'),),
    const DropdownMenuItem(value: 'Room 5',child: Text('Room 5'),),
  ];
  //This count will represent how many meeting rooms that are available for this office
  int availableRoomCount = 0;

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
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          gradient: blueGradientBack,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            const Icon(Icons.book, color: Colors.white, size: 40,),
            const SizedBox(width: 24.0),
            Text(
              'Book a Meeting',
              style: titleHeadTextWhite,
            )
          ],
        ),
      ),
    );
  }

  Widget formContent() {
    availableRoomCount = roomList.length - 1;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'There are $availableRoomCount available meeting rooms.',
            style: titleHeadTextSmall,
          ),
          const SizedBox(height: 8.0),
          DropdownButtonFormField(
              style: titleHeadTextLight,
              decoration: textFormStyle(''),
              items: roomList,
              value: selectedRoom,
              onChanged: (value) {
                setState(() {
                  selectedRoom = value!;
                });
              },
          ),
          const SizedBox(height: 24.0),
          Text(
            'Select a date for your meeting.',
            style: titleHeadTextSmall,
          ),
          const SizedBox(height: 8.0),
          InkWell(
            onTap: () {
              _openDatePicker();
            },
            child: TextFormField(
              enabled: false,
              decoration: calendarForm(),
              controller: dateController,
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            'Select an available timeslot for your meeting.',
            style: titleHeadTextSmall,
          ),
          const SizedBox(height: 8.0),
          InkWell(
            onTap: () {
              _openTimePicker();
            },
            child: TextFormField(
              enabled: false,
              decoration: timeForm(),
              controller: timeController,
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            'Give your meeting a name.',
            style: titleHeadTextSmall,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            decoration: textFormStyle('Meeting Name...'),
            controller: meetingNameController,
          )
        ],
      ),
    );
  }

  Widget confirmButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: InkWell(
        onTap: () {
          _validateForm();
        },
        child: mainButton('Confirm'),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      key: drawerKey,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: ListView(
          children: [
            headRow(),
            pageTitle(),
            formContent(),
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

void _openDatePicker() {
  log('Opened Date Picker');
}

void _openTimePicker() {
  log('Opened Time Picker');
}

void _validateForm() {
  log('Tapped Confirm');
}


//TODO
//________________________
//Retrieve meeting room data from the database
// - Convert meeting room names from String into DropdownMenuItems so they can be used in the dropdown menu.
//
//Implement date/time pickers properly in their respective fields.
//
//Create a method to validate each field on Confirm pressed.
//
//Display input data arranged in a Modal for final confirmation of booking.