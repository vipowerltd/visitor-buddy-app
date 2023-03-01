import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';

import '../resources/styles/colours.dart';
import '../resources/styles/formstyles.dart';
import '../resources/widgets/drawer.dart';
import '../resources/widgets/user.dart';
import 'create_booking.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key,});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

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
            const Icon(Icons.menu_book, color: Colors.white, size: 40,),
            const SizedBox(width: 24.0),
            Text(
              'My Bookings',
              style: titleHeadTextWhite,
            )
          ],
        ),
      ),
    );
  }

  Widget upcomingBookings() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Bookings',
            style: titleHeadText,
          ),
          const SizedBox(height: 8.0),
          Container(
            height: 200,
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                upcomingBookingCard(),
                upcomingBookingCard(),
                upcomingBookingCard(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bookingSearch() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            //Open date picker and change 'Today' to whatever the chosen date is

          },
          child: Container(
            width: 125,
            child: TextFormField(
              enabled: false,
              decoration: calendarForm(),
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: TextFormField(
            decoration: visitorSearchStyle('Search for a booking...'),
          ),
        )
      ],
    );
  }

  Widget previousBookings() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Previous Bookings',
                style: titleHeadText,
              ),
              InkWell(
                onTap: () {
                  _seeAllPrevBookings();
                },
                child: Text(
                  'See All',
                  style: titleHeadTextSmall,
                ),
              )
            ],
          ),
          const SizedBox(height: 12.0,),
          bookingSearch(),
          const SizedBox(height: 12.0,),
          Container(
            color: appBackgroundColour,
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                prevBookingsCard(),
                prevBookingsCard(),
                prevBookingsCard(),
                prevBookingsCard(),
                prevBookingsCard()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget upcomingBookingCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: paleBlue,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 9,
                offset: const Offset(0, 3),
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.groups_rounded, color: mainColour, size: 40,)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Group Conference 04',
                  style: titleHeadTextSmallBold,
                ),
                Text(
                  'Location',
                  style: formHintText,
                ),
                Text(
                  'Main Conference Hall',
                  style: titleHeadTextSmall,
                ),
                Text(
                  'Date/Time',
                  style: formHintText,
                ),
                Text(
                  'February 28, 09:45 AM',
                  style: titleHeadTextSmall,
                )
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                _seeMoreBookingDetails(context);
              },
              child: Icon(Icons.more_horiz, color: mainColour, size: 40,),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }

  Widget prevBookingsCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 9,
                offset: const Offset(0, 3),
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(12.0),
                child: Icon(Icons.groups_rounded, color: mainColour, size: 40,)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Group Conference 04',
                  style: titleHeadTextSmallBold,
                ),
                Text(
                  'Location',
                  style: formHintText,
                ),
                Text(
                  'Main Conference Hall',
                  style: titleHeadTextSmall,
                ),
                Text(
                  'Date/Time',
                  style: formHintText,
                ),
                Text(
                  'February 28, 09:45 AM',
                  style: titleHeadTextSmall,
                )
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                _seeMoreBookingDetails(context);
              },
              child: Icon(Icons.more_horiz, color: mainColour, size: 40,),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }

  Widget newBookingFAB() {
    return FloatingActionButton(
        onPressed: () {
          _tapFAB(context);
        },
        backgroundColor: mainColour,
        child: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 40,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      key: drawerKey,
      resizeToAvoidBottomInset: true,
      floatingActionButton: newBookingFAB(),
      body: Center(
        child: ListView(
          children: [
            headRow(),
            pageTitle(),
            upcomingBookings(),
            previousBookings()
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

void _tapFAB(BuildContext context) {
  log('FAB tapped!');
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: const BookMeeting(),
    ),
  );
}

void _seeAllPrevBookings() {
  log('See All Previous Bookings Tapped');
}

void _seeMoreBookingDetails(BuildContext context) {
  log('Tapped see more booking details');
  showModal(context, true);
}

void _closeBookingModal(BuildContext context) {
  Navigator.pop(context);
}

void _enableEditing() {
  log('Tapped to enable editing!');
  //Using setModalState, set a predefined boolean to TRUE which will trigger textfields
  //to become enabled where the data is currently displayed.
  //
  //This should also swap the icon on display from the settings cog to a check mark.
  //Upon tapping the checkmark the changes will attempt to be committed.
}

void _deleteBooking() {
  log('Tapped to delete booking!');
}

//Modal Menu
void showModal(BuildContext context, bool returned) {
  showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            decoration: BoxDecoration(
                color: appBackgroundColour
            ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          _closeBookingModal(context);
                        },
                        child: Icon(Icons.arrow_drop_down_rounded, color: fadedColour, size: 40,),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      height: 350,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 9,
                              offset: const Offset(0, 3),
                            )
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Visitor Details
                                    Text(
                                      'Group Conference 04',
                                      style: titleHeadText,
                                    ),
                                    const SizedBox(height: 12.0),
                                    Text(
                                      'Location',
                                      style: formHintText,
                                    ),
                                    Text(
                                      'Main Conference Hall',
                                      style: titleHeadTextSmall,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Date/Time',
                                      style: formHintText,
                                    ),
                                    Text(
                                      'February 28, 09:45 AM',
                                      style: titleHeadTextSmall,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Duration',
                                      style: formHintText,
                                    ),
                                    Text(
                                        '30 Minutes',
                                        style: titleHeadTextSmall
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                  flex: 1,
                                  child: Center(
                                      child: Icon(Icons.groups_rounded, color: mainColour, size: 100,)
                                  )
                              )
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  _enableEditing();
                                },
                                child: Icon(Icons.settings, color: mainColour, size: 40,),
                              ),
                              InkWell(
                                onTap: () {
                                  _deleteBooking();
                                },
                                child: Text(
                                  'Delete Booking',
                                  style: formHintText,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  });
}

//TODO
//________________________
//