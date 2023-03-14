import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/models/delivery.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:visitor_power_buddy/resources/widgets/shared_tools.dart';

import '../api/delivery_apis.dart';
import '../resources/styles/colours.dart';
import '../resources/styles/formstyles.dart';
import '../resources/widgets/drawer.dart';
import '../resources/widgets/user.dart';
double opacity = 0.0;

class DeliveryLog extends StatefulWidget {
  const DeliveryLog({super.key,});

  @override
  State<DeliveryLog> createState() => _DeliveryLogState();
}

class _DeliveryLogState extends State<DeliveryLog> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        opacity = 1.0;
      });
    });
    super.initState();
  }

  List<Delivery> allDeliveriesList = [];

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
    List<Widget> unclaimedDeliveriesWidgetList = [];
    for (Delivery i in allDeliveriesList) {
      if (i.claim_status == false) {
        unclaimedDeliveriesWidgetList.add(unclaimedCard(i));
      }
    }
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
            child: unclaimedDeliveriesWidgetList.length != 0? ListView(
              padding: const EdgeInsets.all(8.0),
              children: unclaimedDeliveriesWidgetList,
            ) : Center(child: Text('Your unclaimed deliveries will appear here!', style: fieldHeadText))
          )
        ],
      ),
    );
  }

  Widget allDeliveries() {
    List<Widget> allDeliveriesWidgetList = [];
    for (Delivery i in allDeliveriesList) {
      if (i.claim_status == true) {
        allDeliveriesWidgetList.add(claimedCard(i));
      }
    }
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
            child: allDeliveriesWidgetList.length != 0? ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(8.0),
              children: allDeliveriesWidgetList,
            ) : Center(child: Text('Your deliveries will appear listed here!', style: fieldHeadText))
          ),
        ],
      ),
    );
  }

  Widget unclaimedCard(Delivery delivery) {
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
                child: delivery.delivery_image == null? Image(
                  image: AssetImage('assets/images/package.png'),
                ) : CircleAvatar(backgroundImage: NetworkImage(delivery.delivery_image!),)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  delivery.delivery_id.toString(),
                  style: titleHeadTextSmallBold,
                ),
                Text(
                  'Arrived:',
                  style: formHintText,
                ),
                const SizedBox(width: 12.0),
                Text(
                  formatter.format(delivery.arrival_time),
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
                    _showQRModal(delivery);
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

  Widget claimedCard(Delivery delivery) {
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
                child: delivery.delivery_image == null? Image(
                  image: AssetImage('assets/images/package.png'),
                ) : CircleAvatar(backgroundImage: NetworkImage(delivery.delivery_image!),)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  delivery.delivery_id.toString(),
                  style: titleHeadTextSmallBold,
                ),
                Text(
                  'Arrived:',
                  style: formHintText,
                ),
                Text(
                  formatter.format(delivery.arrival_time),
                  style: titleHeadTextSmall,
                ),
                Text(
                  'Claimed',
                  style: formHintText,
                ),
                Text(
                  formatter.format(delivery.collected_time!),
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

  void _showQRModal(Delivery delivery) {
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
                                  data: delivery.qr_code_value!,
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
                                    delivery.delivery_id.toString(),
                                    style: titleHeadText,
                                  ),
                                  Text(
                                    'Arrived',
                                    style: formHintText,
                                  ),
                                  Text(
                                    formatter.format(delivery.arrival_time),
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
    return FutureBuilder(
      future: getAllDeliveries(),
      builder: (context, AsyncSnapshot snapshot) {

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            allDeliveriesList = snapshot.data;
          }
          return Scaffold(
            drawer: drawer(context),
            key: drawerKey,
            resizeToAvoidBottomInset: true,
            body: Center(
              child: ListView(
                children: [
                  headRow(),
                  pageTitle(),
                  animateOpacity(unclaimedDeliveries()),
                  animateOpacity(allDeliveries()),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

//Opacity animation widget
Widget animateOpacity(Widget child) {
  return AnimatedOpacity(
    opacity: opacity,
    duration: const Duration(milliseconds: 500),
    child: child,
  );
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
//Retrieve all delivery data from the database
//
//Properly filter delivery results based on the selected DateTime
//
//The QR code displayed on unclaimed deliveries should encrypt a string taken
//from the database for that delivery. The user will need to validate the QR code
//shown when they want to collect their item.
//
//Displaying the QR code modal on smaller display sizes causes overflow -- NEEDS FIX