import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';
import 'package:visitor_power_buddy/resources/widgets/drawer.dart';

import '../resources/widgets/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  //This image string should be swapped with the image this user has uploaded for their profile
  String userImagePath = 'assets/images/default_user.png';
  //This string is replaced by the name of the logged in user retrieved from the database
  String userName = 'John Doe';
  //This string is replaced by the count of upcoming visitors to the building
  String uvCount = '01';
  //This string is replaced by the count of total visitors to the building
  String tvCount = '12';
  //This string is replaced by the count of total parcels to the building
  String tpCount = '04';
  //----------------------------------------------------------------------------

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

  Widget upcomingVisitorsBlock() {
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
                uvCount,
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
                tvCount,
                style: titleHeadTextWhiteBold,
              )
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
                tpCount,
                style: titleHeadTextWhiteBold,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget statisticsBlock() {
    return Padding(
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
    );
  }

  Widget UVList() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          const SizedBox(height: 12.0,),
          visitorCard()
        ],
      ),
    );
  }

  Widget TVList() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          const SizedBox(height: 12.0,),
          visitorCard()
        ],
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
                Text(
                  'March 04, 09:30 AM',
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
    return Container(
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
              child: ListView(
                children: [
                  deliveryRow(true),
                  deliveryRow(false),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget deliveryRow(bool collected) {
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
                'PC141 - Feb 20, 2:00 PM',
                style: titleHeadTextWhite,
              ),
              Row(
                children: [
                  Icon(Icons.circle, color: collected? Colors.green : Colors.deepOrange, size: 15,),
                  const SizedBox(width: 8.0,),
                  Text(
                    collected? 'Collected' : 'In Reception',
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
//