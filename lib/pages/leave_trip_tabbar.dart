// @dart=2.9

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:winbrother_hr_app/localization.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/pages/bottom_navigation.dart';
import 'package:winbrother_hr_app/pages/leave_list.dart';
import 'package:winbrother_hr_app/pages/travel_list.dart';
import 'package:winbrother_hr_app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LeaveTripTabBar extends StatefulWidget {
  @override
  _StateLeaveTripTabBar createState() => _StateLeaveTripTabBar();
}

class _StateLeaveTripTabBar extends State<LeaveTripTabBar> {
  final box = GetStorage();

  List expansionlistdata = [];
  List arrayList = [];
  List doneList = [];
  List data = [];
  int tabbar;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final travel_request = box.read("allow_travel_request");
    final index = Get.arguments;
    final labels = AppLocalizations.of(context);
    return DefaultTabController(
      initialIndex: index == "travel" ? 1 : 0,
      length: travel_request != null ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(labels?.leaveTravelRequest, style: appbarTextStyle()),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
              }),
          actions: <Widget>[],
          automaticallyImplyLeading: true,
          bottom: travel_request != null
              ? TabBar(
            labelColor: Colors.white,
            indicatorColor: Color.fromRGBO(216, 181, 0, 1),
            indicatorWeight: 5,
            tabs: [
              Tab(
                text: labels?.leaveForm,
              ),
              Tab(text: labels?.travelForm),
            ],
          )
              : TabBar(
            labelColor: Colors.white,
            indicatorColor: Color.fromRGBO(216, 181, 0, 1),
            indicatorWeight: 5,
            tabs: [
              Tab(
                text: labels?.leaveForm,
              ),
            ],
          ),
        ),
        // appBar: GradientAppBar(
        //   gradient: LinearGradient(
        //     colors: [backgroundIconColor, backgroundIconColor],
        //   ),
        //   title: Text(labels?.leaveTravelRequest, style: appbarTextStyle()),
        //   leading: IconButton(
        //       icon: Icon(
        //         Icons.arrow_back_ios,
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         Get.back();
        //       }),
        //   actions: <Widget>[],
        //   automaticallyImplyLeading: true,
        //   bottom: travel_request != null
        //       ? TabBar(
        //           labelColor: Colors.white,
        //           indicatorColor: Color.fromRGBO(216, 181, 0, 1),
        //           indicatorWeight: 5,
        //           tabs: [
        //             Tab(
        //               text: labels?.leaveForm,
        //             ),
        //             Tab(text: labels?.travelForm),
        //           ],
        //         )
        //       : TabBar(
        //           labelColor: Colors.white,
        //           indicatorColor: Color.fromRGBO(216, 181, 0, 1),
        //           indicatorWeight: 5,
        //           tabs: [
        //             Tab(
        //               text: labels?.leaveForm,
        //             ),
        //           ],
        //         ),
        // ),
        body: travel_request != null
            ? TabBarView(
                children: [
                  LeaveListPage(),
                  TravelListPage(),
                ],
              )
            : TabBarView(
                children: [
                  LeaveListPage(),
                ],
              ),
      ),
    );
  }
}
