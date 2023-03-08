import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/resources/styles/formstyles.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';
import 'package:visitor_power_buddy/resources/widgets/drawer.dart';

import '../resources/styles/colours.dart';
import '../resources/widgets/user.dart';

class VisitorLogPage extends StatefulWidget {
  const VisitorLogPage({super.key,});

  @override
  State<VisitorLogPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<VisitorLogPage> {

  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  double opacity = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        opacity = 1.0;
      });
    });
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
            const Icon(Icons.supervised_user_circle_sharp, color: Colors.white, size: 40,),
            const SizedBox(width: 24.0),
            Text(
              'Visitor Log',
              style: titleHeadTextWhite,
            )
          ],
        ),
      ),
    );
  }

  Widget activeVisitorList() {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Visitors',
                  style: titleHeadText,
                ),
                InkWell(
                  onTap: () {
                    _seeAllActiveVisitors();
                  },
                  child: Text(
                    'See All',
                    style: titleHeadTextSmall,
                  ),
                )
              ],
            ),
            const SizedBox(height: 12.0,),
            visitorCard(),
            visitorCard(),
          ],
        ),
      ),
    );
  }

  Widget visitorCard() {
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
              height: 60,
              child: Image(
                image: AssetImage(userImagePath),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Smith',
                  style: titleHeadTextSmallBold,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Arrived:',
                      style: titleHeadTextSmall,
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      'March 04, 09:30 AM',
                      style: titleHeadTextSmall,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Departed:',
                      style: titleHeadTextSmall,
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      'March 04, 12:30 AM',
                      style: titleHeadTextSmall,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(width: 32.0,),
            InkWell(
              onTap: () {
                _seeMoreVisitorDetails(context, false);
              },
              child: Icon(Icons.more_horiz, color: mainColour, size: 40,),
            )
          ],
        ),
      ),
    );
  }

  Widget visitorSearch() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            //Open date picker and change 'Today' to whatever the chosen date is
            _openDatePicker();
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
            decoration: visitorSearchStyle('Search for a visitor...'),
          ),
        )
      ],
    );
  }

  Widget allVisitorsList() {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Visitors',
                  style: titleHeadText,
                ),
                InkWell(
                  onTap: () {
                    _seeAllVisitors();
                  },
                  child: Text(
                    'See All',
                    style: titleHeadTextSmall,
                  ),
                )
              ],
            ),
            const SizedBox(height: 12.0,),
            visitorSearch(),
            const SizedBox(height: 12.0,),
            Container(
              color: appBackgroundColour,
              height: MediaQuery.of(context).size.height * 0.35,
              child: ListView(
                children: [
                  visitorCard(),
                  visitorCard(),
                  visitorCard(),
                  visitorCard(),
                  visitorCard(),
                  visitorCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: drawer(context),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: ListView(
          //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            headRow(),
            pageTitle(),
            activeVisitorList(),
            allVisitorsList(),
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

void _seeMoreVisitorDetails(BuildContext context, bool returned) {
  log('Attempting to open visitor details modal');
  showModal(context, returned);
}

void _seeAllActiveVisitors() {
  log('Tapped See All Active visitors');
}

void _seeAllVisitors() {
  log('Tapped See All visitors');
}

void _openDatePicker() {
  log('Tapped Date Picker');
}

void _closeVisitorModal(BuildContext context) {
  Navigator.pop(context);
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
                          _closeVisitorModal(context);
                        },
                        child: Icon(Icons.arrow_drop_down_rounded, color: fadedColour, size: 40,),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      height: 325,
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
                                      'John Smith',
                                      style: titleHeadText,
                                    ),
                                    const SizedBox(height: 12.0),
                                    Text(
                                      'Email Address',
                                      style: formHintText,
                                    ),
                                    Text(
                                      'johnsmith@gmail.com',
                                      style: titleHeadTextSmall,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Phone Number',
                                      style: formHintText,
                                    ),
                                    Text(
                                      '02495829302',
                                      style: titleHeadTextSmall,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Company',
                                      style: formHintText,
                                    ),
                                    Text(
                                      'ViPower Limited',
                                      style: titleHeadTextSmall
                                    ),
                                  ],
                                ),
                              ),
                              const Flexible(
                                flex: 1,
                                child: Center(
                                  child: Image(
                                    image: AssetImage('assets/images/default_user.png'),
                                  )
                                )
                              )
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Arrived',
                                      style: formHintText,
                                    ),
                                    Text(
                                      'March 04, 9:30 AM',
                                      style: titleHeadTextSmall,
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: returned? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Departed',
                                      style: formHintText,
                                    ),
                                    Text(
                                      'March 04, 11:30 AM',
                                      style: titleHeadTextSmall,
                                    ),
                                  ],
                                ) : Container(),
                              )
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.circle, color: returned? Colors.deepOrange : Colors.green, size: 12.0,),
                              const SizedBox(width: 12.0),
                              Text(
                                returned? 'Departed' : 'On Site',
                                style: formHintText,
                              )
                            ],
                          )
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
//Need to retrieve all visitors details from the database for this user.
//
//Need to differentiate the design of the All Visitors cards to distinguish them
//from the active visitors cards.
//
//Need to implement working filtered search based on both DateTime + Visitor Name.
//
//Opening Visitor details Modal on smaller display sizes causes overflow -- NEEDS FIX