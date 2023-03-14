import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/api/delivery_apis.dart';
import 'package:visitor_power_buddy/api/visitor_apis.dart';
import 'package:visitor_power_buddy/models/visitor.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';
import 'package:visitor_power_buddy/resources/widgets/drawer.dart';

import '../api/call_api.dart';
import '../models/delivery.dart';
import '../resources/widgets/shared_tools.dart';
import '../resources/widgets/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  List<Visitor> visitors = [];
  List<Delivery> deliveries = [];

  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  bool anim = false;
  Duration animDuration = const Duration(milliseconds: 250);

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

  Widget upcomingVisitorsBlock() {
    //Upcoming visitors count is the number of visitors that preregistered and due soon
    int upcomingVisitorsCount = 0;
    for (Visitor i in visitors) {
      if (i.is_pre_registered && i.sign_out_time == null && i.sign_in_time.isAfter(DateTime.now())) {
        upcomingVisitorsCount++;
      }
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: mainColour,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Upcoming Visitors',
            style: titleHeadTextWhiteSmall,
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.person_add, color: Colors.white, size: 40,),
              Text(
                upcomingVisitorsCount.toString(),
                style: titleHeadTextWhiteBold,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget totalVisitorsBlock() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: lightGreen,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Total Visitors',
            style: titleHeadTextWhiteSmall,
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.supervised_user_circle_sharp, color: Colors.white, size: 40,),
              Text(
                visitors.length.toString(),
                style: titleHeadTextWhiteBold,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget totalParcelsBlock() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: mainBlue,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Total Parcels',
            style: titleHeadTextWhiteSmall,
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 30,
                child: Image(
                  image: AssetImage('assets/images/package_white.png'),
                ),
              ),
              Text(
                deliveries.length.toString(),
                style: titleHeadTextWhiteBold,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget statisticsBlock() {
    //This block animates on screen from the right
    //On ending it triggers the remaining animations to begin

    double startPos = -1;
    double endPos = 0;

    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: Offset(startPos, 0), end: Offset(endPos, 0),),
      duration: animDuration,
      builder: (context, offset, child) {
        return FractionalTranslation(
          translation: offset,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: upcomingVisitorsBlock(),
                ),
                const SizedBox(width: 12.0,),
                Flexible(
                  flex: 1,
                  child: totalVisitorsBlock(),
                )
              ],
            ),
            const SizedBox(height: 12.0),
            totalParcelsBlock(),
          ],
        ),
      ),
      onEnd: () {
        setState(() {
          anim = true;
        });
      },
    );
  }

  Widget UVList() {
    List upcoming = [];
    for (Visitor i in visitors) {
      if (i.sign_in_time.isAfter(DateTime.now()) && i.sign_in_time.day != DateTime.now().day) {
        upcoming.add(i);
      }
    }

    return AnimatedOpacity(
      opacity: anim? 1.0 : 0.0,
      duration: animDuration,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Visitors',
                    style: titleHeadText,
                  ),
                  InkWell(
                    onTap: () {
                      _seeUpcomingVisitors();
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
            Container(
                width: double.infinity, height: 100,
                child: upcoming.isNotEmpty? ListView.builder(
                  itemCount: upcoming.length,
                  itemBuilder: (BuildContext context, int index) {
                    return visitorCard(upcoming[index]);
                  },
                ) : Center(child: Text('Your upcoming visitors will appear here!', style: fieldHeadText))
            )
          ],
        ),
      ),
    );
  }

  Widget TVList() {
    List todays = [];
    for (Visitor i in visitors) {
      if (i.sign_in_time.day == DateTime.now().day) {
        todays.add(i);
      }
    }
    return AnimatedOpacity(
      opacity: anim? 1.0 : 0.0,
      duration: animDuration,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Visitors',
                    style: titleHeadText,
                  ),
                  InkWell(
                    onTap: () {
                      _seeTodayVisitors();
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
            Container(
              width: double.infinity, height: 100,
              child: todays.isNotEmpty? ListView.builder(
                itemCount: todays.length,
                itemBuilder: (BuildContext context, int index) {
                  return visitorCard(todays[index]);
                },
              ) : Center(child: Text('Visitors you have due today will appear here!', style: fieldHeadText))
            )
          ],
        ),
      ),
    );
  }

  Widget visitorCard(Visitor visitor) {
    if (visitor.visitor_image == null) {
      log('It is null');
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
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
              ) : CircleAvatar(backgroundImage: NetworkImage(visitor.visitor_image!),),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visitor.name,
                  style: titleHeadTextSmallBold,
                ),
                Text(
                  formatter.format(visitor.sign_in_time).toString(),
                  style: titleHeadTextSmall,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget recentDeliveriesList() {
    double startPos = 1;
    double endPos = 0;

    //Take the two most recent deliveries to display on the page
    List<Delivery> recentDeliveries = [];
    for (Delivery i in deliveries) {
      if (recentDeliveries.length < 2) {
        if (i.arrival_time.isAfter(DateTime.now().subtract(Duration(days: 2)))) {
          recentDeliveries.add(i);
        }
      }
    }

    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: Offset(0, startPos), end: Offset(0, endPos)),
      duration: animDuration,
      builder: (context, offset, child) {
        return FractionalTranslation(
          translation: offset,
          child: child,
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: blueGradientBack,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Deliveries',
                    style: titleHeadTextWhiteBold,
                  ),
                  InkWell(
                    onTap: () {
                      _seeRecentDeliveries();
                    },
                    child: Text(
                      'See All',
                      style: titleHeadTextWhiteSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Expanded(
                child: recentDeliveries.isNotEmpty? ListView.builder(
                    itemCount: recentDeliveries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return deliveryRow(recentDeliveries[index]);
                    }
                ) : Center(child: Text('Your recent deliveries will appear here.', style: fieldHeadTextWhite,)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget deliveryRow(Delivery delivery) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 30,
            child: Image(
              image: AssetImage('assets/images/package_white.png'),
            ),
          ),
          const SizedBox(width: 12.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                delivery.delivery_id.toString(),
                style: titleHeadTextWhite,
              ),
              Row(
                children: [
                  Icon(Icons.circle, color: delivery.claim_status? Colors.green : Colors.deepOrange, size: 15,),
                  const SizedBox(width: 8.0,),
                  Text(
                    delivery.claim_status? 'Collected' : 'In Reception',
                    style: titleHeadTextWhiteSmall,
                  )
                ],
              )
            ]
          )
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHomeContent(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['visitors'] != null) {
            visitors = snapshot.data['visitors'];
          }
          if (snapshot.data['deliveries'] != null) {
            deliveries = snapshot.data['deliveries'];
          }

          return Scaffold(
            key: drawerKey,
            drawer: drawer(context),
            resizeToAvoidBottomInset: true,
            body: Center(
              child: ListView(
                children: [
                  headRow(),
                  statisticsBlock(),
                  TVList(),
                  UVList(),
                  recentDeliveriesList(),
                ],
              ),
            ),
          );
        }
        else {
          return Center(child: const CircularProgressIndicator());
        }
      }
    );
  }
}

//Methods for page functionality
void _openDrawer(GlobalKey<ScaffoldState> drawerKey) {
  log('Opened Drawer Menu');
  drawerKey.currentState?.openDrawer();
}

void _seeUpcomingVisitors() {
  log('Tapped See All Upcoming Visitors');
}

void _seeTodayVisitors() {
  log('Tapped See Today\'s Visitors');
}

void _seeRecentDeliveries() {
  log('Tapped See Recent Deliveries');
}


//TODO
//________________________
//Add functionality to each 'SEE ALL' button
//
//Use newly acquired delivery data to populate the recent deliveries widget
//with the correct information