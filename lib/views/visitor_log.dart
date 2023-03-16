import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/api/visitor_apis.dart';
import 'package:visitor_power_buddy/resources/styles/formstyles.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';
import 'package:visitor_power_buddy/resources/widgets/drawer.dart';
import 'package:visitor_power_buddy/resources/widgets/shared_tools.dart';

import '../models/visitor.dart';
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
  TextEditingController searchController = TextEditingController();
  List<Visitor> visitors = [];
  List<Visitor> searchResults = [];
  DateTime searchDate = DateTime.now();
  late Future getAllVisitorsFuture;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        opacity = 1.0;
      });
    });
    getAllVisitorsFuture = getAllVisitors();
    searchController.addListener(onSearchChanged);
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        searchResults = List.from(visitors);
      });
    });
    super.initState();
  }

  onSearchChanged() {
    log('Search changed');
    searchResultsList();
  }

  searchResultsList() {
    List<Visitor> showResults = [];
    if (searchController.text.isNotEmpty) {
      for (var visitor in visitors) {
        var name = visitor.name.toLowerCase();

        if (name.contains(searchController.text.toLowerCase())) {
          showResults.add(visitor);
          log('Record added to list');
        }
      }
    }
    else {
      showResults = List.from(visitors);
    }

    setState(() {
      searchResults = showResults;
    });
  }

  filterDate(DateTime date) {
    searchResultsList();
    List<Visitor> showResults = [];
    for (var visitor in searchResults) {
      var day = visitor.sign_in_time.day;
      var selDay = date.day;
      log('Day: $day');
      log('SelDay: $selDay');

      if (day == selDay) {
        log('Added visitor today');
        showResults.add(visitor);
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
    List<Visitor> activeVisitors = [];
    for (Visitor i in visitors) {
      if (i.sign_in_time.day == DateTime.now().day && i.sign_out_time == null) {
        activeVisitors.add(i);
      }
    }

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
                //InkWell(
                //  onTap: () {
                //    _seeAllActiveVisitors();
                //  },
                //  child: Text(
                //    'See All',
                //    style: titleHeadTextSmall,
                //  ),
                //)
              ],
            ),
            const SizedBox(height: 12.0,),
            Container(
              color: appBackgroundColour,
              height: MediaQuery.of(context).size.height * 0.2,
              child: activeVisitors.isNotEmpty? ListView.builder(
                  itemCount: activeVisitors.length,
                  itemBuilder: (BuildContext context, int index) {
                    return activeVisitorCard(activeVisitors[index]);
                  }
              ) : Center(child: Text('Your active visitors will appear here!', style: fieldHeadText))
            )
          ],
        ),
      ),
    );
  }

  Widget activeVisitorCard(Visitor visitor) {
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
              child: visitor.visitor_image == null? Image(
                image: AssetImage(userImagePath),
              ) : CircleAvatar(backgroundImage: NetworkImage(visitor.visitor_image!),)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visitor.name,
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
                      formatter.format(visitor.sign_in_time),
                      style: titleHeadTextSmall,
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(width: 32.0,),
            InkWell(
              onTap: () {
                _seeMoreVisitorDetails(context, visitor);
              },
              child: Icon(Icons.more_horiz, color: mainColour, size: 40,),
            )
          ],
        ),
      ),
    );
  }

  Widget visitorCard(Visitor visitor) {
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
              child: visitor.visitor_image == null? Image(
                image: AssetImage(userImagePath),
              ) : CircleAvatar(backgroundImage: NetworkImage(visitor.visitor_image!),)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visitor.name,
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
                      formatter.format(visitor.sign_in_time),
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
                      visitor.sign_out_time == null? 'ON SITE' : formatter.format(visitor.sign_out_time!),
                      style: titleHeadTextSmall,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(width: 32.0,),
            InkWell(
              onTap: () {
                _seeMoreVisitorDetails(context, visitor);
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
            decoration: visitorSearchStyle('Search for a visitor...'),
            controller: searchController
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
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
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
            ),
            const SizedBox(height: 12.0,),
            Padding(padding: const EdgeInsets.only(left: 12.0, right: 12.0), child: visitorSearch()),
            const SizedBox(height: 12.0,),
            Container(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              color: appBackgroundColour,
              height: MediaQuery.of(context).size.height * 0.35,
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return visitorCard(searchResults[index]);
                }
              )
            )
          ],
        ),
      ),
    );
  }

  void _seeAllVisitors() {
    log('Tapped See All visitors');
    setState(() {
      searchResults = List.from(visitors);
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllVisitorsFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            visitors = snapshot.data;
          }
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
        else {
          return Center(child: CircularProgressIndicator());
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

void _seeMoreVisitorDetails(BuildContext context, Visitor visitor) {
  log('Attempting to open visitor details modal');
  showModal(context, visitor);
}

void _seeAllActiveVisitors() {
  log('Tapped See All Active visitors');
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

void _closeVisitorModal(BuildContext context) {
  Navigator.pop(context);
}

//Modal Menu
void showModal(BuildContext context, Visitor visitor) {
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
                                      visitor.name,
                                      style: titleHeadText,
                                    ),
                                    const SizedBox(height: 12.0),
                                    Text(
                                      'Email Address',
                                      style: formHintText,
                                    ),
                                    Text(
                                      visitor.email,
                                      style: titleHeadTextSmall,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Phone Number',
                                      style: formHintText,
                                    ),
                                    Text(
                                      visitor.phone,
                                      style: titleHeadTextSmall,
                                    ),
                                    const SizedBox(height: 8.0),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Center(
                                  child: visitor.visitor_image == null? Image(
                                    image: AssetImage('assets/images/default_user.png'),
                                  ) : Center(child: Container(
                                    height: 100, width: 100,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            spreadRadius: 5,
                                            blurRadius: 9,
                                            offset: const Offset(0, 3),
                                          )
                                        ],
                                        border: Border.all(color: Colors.orange),
                                        borderRadius: BorderRadius.circular(125),
                                        image: DecorationImage(
                                          image: NetworkImage(visitor.visitor_image!),
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                  ),),
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
                                      formatter.format(visitor.sign_in_time),
                                      style: titleHeadTextSmall,
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: visitor.sign_out_time != null? Column(
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
                              Icon(Icons.circle, color: visitor.sign_out_time != null? Colors.deepOrange : Colors.green, size: 12.0,),
                              const SizedBox(width: 12.0),
                              Text(
                                visitor.sign_out_time != null? 'Departed' : 'On Site',
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