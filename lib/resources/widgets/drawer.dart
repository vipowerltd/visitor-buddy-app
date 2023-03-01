import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:visitor_power_buddy/views/create_booking.dart';
import 'package:visitor_power_buddy/views/delivery_log.dart';
import 'package:visitor_power_buddy/views/guest_pre_registration.dart';
import 'package:visitor_power_buddy/views/home_page.dart';
import 'package:visitor_power_buddy/views/login_page.dart';
import 'package:visitor_power_buddy/views/my_bookings.dart';
import 'package:visitor_power_buddy/views/visitor_log.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';

import '../../views/create_booking.dart';
import '../styles/colours.dart';

Widget drawer(BuildContext context) {
  return Drawer(
    child: Container(
      decoration: BoxDecoration(
        color: mainColour
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const DrawerHeader(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Image(
                        image: AssetImage('assets/images/visitor_power_logo_white.png'),
                      ),
                    )
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: blueGradientLight,
                  ),
                  child: ListTile(
                    title: Text('Home', style: titleHeadTextWhite,),
                    onTap: () async {
                      _goHome(context);
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    gradient: blueGradientLight,
                  ),
                  child: ListTile(
                    title: Text('Pre-Register a Guest', style: titleHeadTextWhite,),
                    onTap: () async {
                      _preRegisterAGuest(context);
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    gradient: blueGradientLight,
                  ),
                  child: ListTile(
                    title: Text('Visitor Logs', style: titleHeadTextWhite,),
                    onTap: () {
                      _visitorLogs(context);
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    gradient: blueGradientLight,
                  ),
                  child: ListTile(
                    title: Text('Delivery Logs', style: titleHeadTextWhite,),
                    onTap: () {
                      _deliveryLogs(context);
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    gradient: blueGradientLight,
                  ),
                  child: ListTile(
                    title: Text('Book Meeting Room', style: titleHeadTextWhite,),
                    onTap: () {
                      _bookMeetingRoom(context);
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    gradient: blueGradientLight,
                  ),
                  child: ListTile(
                    title: Text('My Bookings', style: titleHeadTextWhite,),
                    onTap: () async {
                      _myBookings(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.power_settings_new_outlined, color: Colors.white, size: 30),
            title: Text('Logout', style: titleHeadTextWhite,),
            onTap: () async {
              _logOut(context);
            },
          ),
          const SizedBox(height: 24.0)
        ],
      )
    ),
  );
}

//Methods for navigation
void _goHome(BuildContext context) {
  log('Tapped Home');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const HomePage(),
    ),
  );
}

void _preRegisterAGuest(BuildContext context) {
  log('Tapped Pre Register a Guest');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const PreRegistration(),
    ),
  );
}

void _visitorLogs(BuildContext context) {
  log('Tapped Visitor Logs');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const VisitorLogPage(),
    ),
  );
}

void _deliveryLogs(BuildContext context) {
  log('Tapped Delivery Logs');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const DeliveryLog(),
    ),
  );
}

void _bookMeetingRoom(BuildContext context) {
  log('Tapped Book Meeting Room');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const BookMeeting(),
    ),
  );
}

void _myBookings(BuildContext context) {
  log('Tapped My Bookings');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const MyBookings(),
    ),
  );
}

void _logOut(BuildContext context) {
  log('Tapped Logout');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const LoginPage(),
    ),
  );
}