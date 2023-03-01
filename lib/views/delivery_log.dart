import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../resources/styles/colours.dart';
import '../resources/styles/formstyles.dart';
import '../resources/widgets/drawer.dart';
import '../resources/widgets/user.dart';

class DeliveryLog extends StatefulWidget {
  const DeliveryLog({super.key,});

  @override
  State<DeliveryLog> createState() => _DeliveryLogState();
}

class _DeliveryLogState extends State<DeliveryLog> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  List<Widget> unclaimedDeliveriesList = [];
  List<Widget> allDeliveriesList = [];

  String qrData = '295102958102958';

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
            Container(
              height: 40,
              child: const Image(
                image: AssetImage('assets/images/package_white.png'),
              ),
            ),
            const SizedBox(width: 24.0),
            Text(
              'Delivery Log',
              style: titleHeadTextWhite,
            )
          ],
        ),
      ),
    );
  }

  Widget unclaimedDeliveries() {
    unclaimedDeliveriesList = [unclaimedCard(), unclaimedCard(), unclaimedCard()];

    return Padding(
      padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unclaimed Deliveries',
            style: titleHeadText,
          ),
          const SizedBox(height: 12.0),
          Container(
            height: 200,
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: unclaimedDeliveriesList,
            ),
          )
        ],
      ),
    );
  }

  Widget allDeliveries() {
    allDeliveriesList = [claimedCard(), claimedCard(), claimedCard(), claimedCard()];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'All Deliveries',
            style: titleHeadText,
          ),
          const SizedBox(height: 12.0),
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
          const SizedBox(height: 12.0),
          Container(
            height: 275,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(8.0),
              children: allDeliveriesList,
            ),
          ),
        ],
      ),
    );
  }

  Widget unclaimedCard() {
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
                spreadRadius: 2,
                blurRadius: 9,
                offset: const Offset(0, 3),
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              height: 60,
              child: const Image(
                image: AssetImage('assets/images/package.png'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PC141',
                  style: titleHeadTextSmallBold,
                ),
                Text(
                  'Arrived:',
                  style: formHintText,
                ),
                const SizedBox(width: 12.0),
                Text(
                  'March 04, 09:30 AM',
                  style: titleHeadTextSmall,
                ),
              ],
            ),
            const SizedBox(width: 64.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.circle, color: Colors.deepOrange, size: 10,),
                const SizedBox(height: 12.0),
                InkWell(
                  onTap: () {
                    _showQRModal();
                  },
                  child: Icon(Icons.more_horiz, color: mainColour, size: 40,),
                )
              ],
            ),
            const SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }

  Widget claimedCard() {
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
                spreadRadius: 2,
                blurRadius: 9,
                offset: const Offset(0, 3),
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              height: 60,
              child: const Image(
                image: AssetImage('assets/images/package.png'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PC141',
                  style: titleHeadTextSmallBold,
                ),
                Text(
                  'Arrived:',
                  style: formHintText,
                ),
                Text(
                  'March 04, 09:30 AM',
                  style: titleHeadTextSmall,
                ),
                Text(
                  'Claimed',
                  style: formHintText,
                ),
                Text(
                  'March 04, 10:15 AM',
                  style: titleHeadTextSmall,
                )
              ],
            ),
            const SizedBox(width: 64.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.circle, color: Colors.green, size: 10,),
                const SizedBox(height: 48.0),
                InkWell(
                  onTap: () {

                  },
                  child: Icon(Icons.more_horiz, color: mainColour, size: 40,),
                )
              ],
            ),
            const SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }

  void _showQRModal() {
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
                            _closeDeliveryModal(context);
                          },
                          child: Icon(Icons.arrow_drop_down_rounded, color: fadedColour, size: 40,),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        width: double.infinity,
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
                            Text(
                              'Claim Delivery',
                              style: titleHeadText,
                            ),
                            Text(
                              'To claim your delivery, present this QR code at reception.',
                              style: titleHeadTextSmall,
                            ),
                            const SizedBox(height: 12.0),
                            Center(
                              child: Container(
                                height: 100, width: 100,
                                child: QrImage(
                                  data: qrData,
                                  version: QrVersions.auto,
                                )
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PC141',
                                    style: titleHeadText,
                                  ),
                                  Text(
                                    'Arrived',
                                    style: formHintText,
                                  ),
                                  Text(
                                    'March 04, 09:30 AM',
                                    style: titleHeadTextSmall,
                                  )
                                ],
                              ),
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
            unclaimedDeliveries(),
            allDeliveries(),
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
  log('Tapped Date Picker');
}

void _closeDeliveryModal(BuildContext context) {
  Navigator.pop(context);
}

//TODO
//________________________
//Create delivery cards for claimed and unclaimed deliveries