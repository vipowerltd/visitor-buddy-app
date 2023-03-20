import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:visitor_power_buddy/api/booking_apis.dart';
import 'package:visitor_power_buddy/models/meeting_room_booking.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';
import 'package:visitor_power_buddy/resources/widgets/shared_tools.dart';

import '../api/env.dart';
import '../models/meeting_room.dart';
import '../resources/styles/colours.dart';
import '../resources/styles/formstyles.dart';
import '../resources/widgets/drawer.dart';
import '../resources/widgets/user.dart';
import 'create_booking.dart';
double opacity = 0.0;

class MyBookings extends StatefulWidget {
  const MyBookings({super.key,});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  TextEditingController searchController = TextEditingController();
  DateTime searchDate = DateTime.now();
  List<MeetingRoomBooking> bookings = [];
  List<MeetingRoomBooking> searchResults = [];
  late Future getAllBookingsFuture;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        opacity = 1.0;
      });
    });
    getAllBookingsFuture = getAllBookings();
    searchController.addListener(onSearchChanged);
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        searchResults = List.from(bookings);
      });
    });
    super.initState();
  }

  onSearchChanged() {
    log('Search changed');
    searchResultsList();
  }

  searchResultsList() {
    List<MeetingRoomBooking> showResults = [];
    if (searchController.text.isNotEmpty) {
      for (var booking in bookings) {
        var name = booking.booking_name.toLowerCase();

        if (name.contains(searchController.text.toLowerCase())) {
          showResults.add(booking);
          log('Record added to list');
        }
      }
    }
    else {
      showResults = List.from(bookings);
    }

    setState(() {
      searchResults = showResults;
    });
  }

  filterDate(DateTime date) {
    searchResultsList();
    List<MeetingRoomBooking> showResults = [];
    for (var booking in searchResults) {
      var day = booking.start_time.day;
      var selDay = date.day;
      log('Day: $day');
      log('SelDay: $selDay');

      if (day == selDay) {
        log('Added visitor today');
        showResults.add(booking);
      }
    }

    setState(() {
      searchResults = showResults;
    });
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
    List<Widget> widgetList = [];
    for (MeetingRoomBooking i in bookings) {
      if (i.start_time.isAfter(DateTime.now())) {
        widgetList.add(upcomingBookingCard(i));
      }
    }
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
            child: widgetList.isNotEmpty? ListView(
              padding: const EdgeInsets.all(8.0),
              children: widgetList,
            ) : Center(child: Text('Your upcoming bookings will appear here!', style: fieldHeadText)),
          )
        ],
      ),
    );
  }

  Widget bookingSearch() {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            //Open date picker and change 'Today' to whatever the chosen date is
            var picked = (await _openDatePicker(context))!;
            setState(() {
            searchDate = picked;
            });
            filterDate(searchDate);
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
            controller: searchController,
          ),
        )
      ],
    );
  }

  Widget previousBookings() {
    List<Widget> widgetList = [];
    for (MeetingRoomBooking booking in bookings) {
      if (booking.end_time.isBefore(DateTime.now())) {
        widgetList.add(prevBookingsCard(booking));
      }
    }
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
            child: widgetList.isNotEmpty? ListView(
              padding: const EdgeInsets.all(8.0),
              children: widgetList,
            ) : Center(child: Text('Your previous bookings will appear here!', style: fieldHeadText)),
          )
        ],
      ),
    );
  }

  Widget upcomingBookingCard(MeetingRoomBooking booking) {
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
                  booking.booking_name,
                  style: titleHeadTextSmallBold,
                ),
                Text(
                  'Location',
                  style: formHintText,
                ),
                Text(
                  booking.room_id.toString(),
                  style: titleHeadTextSmall,
                ),
                Text(
                  'Date/Time',
                  style: formHintText,
                ),
                Text(
                  formatter.format(booking.start_time),
                  style: titleHeadTextSmall,
                )
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                _seeMoreBookingDetails(context, booking);
              },
              child: Icon(Icons.more_horiz, color: mainColour, size: 40,),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }

  Widget prevBookingsCard(MeetingRoomBooking booking) {
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
                  booking.booking_name,
                  style: titleHeadTextSmallBold,
                ),
                Text(
                  'Location',
                  style: formHintText,
                ),
                Text(
                  booking.room_id.toString(),
                  style: titleHeadTextSmall,
                ),
                Text(
                  'Date/Time',
                  style: formHintText,
                ),
                Text(
                  formatter.format(booking.start_time),
                  style: titleHeadTextSmall,
                )
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                _seeMoreBookingDetails(context, booking);
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

  Widget testButton() {
    return InkWell(
      onTap: () {
        log(bookings.length.toString());
        log(searchResults.length.toString());
      },
      child: Text('Booking Length'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllBookingsFuture,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            bookings = snapshot.data;
          }
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
                  animateOpacity(upcomingBookings()),
                  animateOpacity(previousBookings()),
                  testButton(),
                ],
              ),
            ),
          );
        }
        else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    );
  }
}

//Methods for page functionality
void _openDrawer(GlobalKey<ScaffoldState> drawerKey) {
  log('Opened Drawer Menu');
  drawerKey.currentState?.openDrawer();
}

void _tapFAB(BuildContext context) async {
  log('FAB tapped!');
  loadingDialog(context);
  List<MeetingRoom> meetingRooms = await getMeetingRooms(context, userID);
  Navigator.pop(context);
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.leftToRight,
      child: BookMeeting(meetingRooms: meetingRooms,),
    ),
  );
}

void _seeAllPrevBookings() {
  log('See All Previous Bookings Tapped');
}

Future<DateTime?> _openDatePicker(BuildContext context) async {
  log('Tapped Date Picker');
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025));

  return picked;
}

void _seeMoreBookingDetails(BuildContext context, MeetingRoomBooking booking) {
  log('Tapped see more booking details');
  showModal(context, true, booking);
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

//Opacity animation widget
Widget animateOpacity(Widget child) {
  return AnimatedOpacity(
    opacity: opacity,
    duration: const Duration(milliseconds: 500),
    child: child,
  );
}

//Modal Menu
void showModal(BuildContext context, bool returned, MeetingRoomBooking booking) {
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
                                      booking.booking_name,
                                      style: titleHeadText,
                                    ),
                                    const SizedBox(height: 12.0),
                                    Text(
                                      'Location',
                                      style: formHintText,
                                    ),
                                    Text(
                                      booking.room_id.toString(),
                                      style: titleHeadTextSmall,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Date/Time',
                                      style: formHintText,
                                    ),
                                    Text(
                                      formatter.format(booking.start_time),
                                      style: titleHeadTextSmall,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Duration',
                                      style: formHintText,
                                    ),
                                    Text(
                                        booking.end_time.difference(booking.start_time).toString(),
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
//Retrieve booking data from the database and populate the listviews appropriately.
//
//Implement proper filtered search based on selected date and input booking name.
//
//Implement booking editing for upcoming bookings. Clicking Cogwheel icon should
//enable editing for each piece of data. Cogwheel icon swaps into a Checkmark
//icon which attempts to commit changes when pressed again.
//
//Implement process for deleting this booking, raise an alert dialog to confirm intent.
//
//Opening Booking details Modal causes overflow on smaller display sizes -- NEEDS FIX