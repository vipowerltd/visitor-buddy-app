import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:visitor_power_buddy/api/booking_apis.dart';
import 'package:visitor_power_buddy/api/env.dart';
import 'package:visitor_power_buddy/models/meeting_room_booking.dart';
import 'package:visitor_power_buddy/resources/styles/formstyles.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';
import 'package:visitor_power_buddy/resources/widgets/shared_tools.dart';

import '../models/meeting_room.dart';
import '../resources/styles/colours.dart';
import '../resources/widgets/buttons.dart';
import '../resources/widgets/drawer.dart';
import '../resources/widgets/user.dart';
import 'home_page.dart';

class BookMeeting extends StatefulWidget {
  const BookMeeting({super.key, required this.meetingRooms});
  final List<MeetingRoom> meetingRooms;

  @override
  State<BookMeeting> createState() => _BookMeetingState();
}

class _BookMeetingState extends State<BookMeeting> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController meetingNameController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  late MeetingRoom selectedRoom;
  List<MeetingRoom> meetingRooms = [];
  List<DropdownMenuItem<MeetingRoom>> meetingRoomList = [];
  //This count will represent how many meeting rooms that are available for this office
  int availableRoomCount = 0;

  @override
  void initState() {
    for (MeetingRoom i in widget.meetingRooms) {
      if (i.is_open_room && i.status) {
        meetingRoomList.add(DropdownMenuItem(value: i, child: Text(i.room_name),));
      }
    }
    selectedRoom = meetingRoomList[0].value!;
    super.initState();
  }

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
    //availableRoomCount = roomList.length - 1;

    //Iterate through the meetingRooms list to turn them into dropdownbuttonmenuitems
    availableRoomCount = meetingRoomList.length;

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
              items: meetingRoomList,
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
              _openDatePicker(context);
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


  Future<void> _openDatePicker(BuildContext context) async {
    log('Opened Date Picker');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      });
    }
  }

  Future<void> _openTimePicker() async {
    log('Tapped to open time picker');

    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay.now()
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        timeController.text = '${selectedTime.hour}:${selectedTime.minute}';
      });
    }
  }

  void _validateForm() {
    log('Tapped Confirm');
    if (dateController.text.isEmpty) {
      showSnackBar(context, 'You must select a date for your booking!');
      return;
    }
    else if (timeController.text.isEmpty) {
      showSnackBar(context, 'You must select a time for your booking!');
      return;
    }
    else if (meetingNameController.text.isEmpty) {
      showSnackBar(context, 'You must give your booking a name!');
      return;
    }
    DateTime finalDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute,);
    DateTime endDate = finalDate.add(const Duration(minutes: 30));

    MeetingRoomBooking booking = MeetingRoomBooking(
        booking_id: generateRandomString(), start_time: finalDate,
        end_time: endDate, room_id: selectedRoom.room_id,
        user_id: int.parse(userID), booked_on: DateTime.now(),
        booking_name: meetingNameController.text,
        room_name: '',
    );
    addNewBooking(context, booking);
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

Future<void> addNewBooking(BuildContext context, MeetingRoomBooking booking) async {
  loadingDialog(context);
  bool res = await addMeetingBooking(context, booking);
  Navigator.pop(context);

  if (res) {
    //Show a snack bar and redirect back to homepage
    showSnackBar(context, 'Booking created!');
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.leftToRight,
        child: HomePage(),
      ),
    );
  }
  else {
    showSnackBar(context, 'Error, please try again.');
  }
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