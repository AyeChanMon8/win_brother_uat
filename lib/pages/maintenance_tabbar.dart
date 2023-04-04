// @dart=2.9

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:winbrother_hr_app/controllers/maintenance_controller.dart';
import 'package:winbrother_hr_app/localization.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/pages/maintenance_list.dart';

class MaintenanceTabBar extends StatefulWidget {


  @override
  _StatePlanTripTabBar createState() => _StatePlanTripTabBar();
}

class _StatePlanTripTabBar extends State<MaintenanceTabBar> {
  final box = GetStorage();
  final MaintenanceController controller = Get.put(MaintenanceController());
  List expansionlistdata = [];
  List arrayList = [];
  List doneList = [];
  List data = [];
  int tabbar = 3;
  String role = '';
  @override
  void initState() {
    print("initState");
    super.initState();
    role = box.read('role_category');
  }

  @override
  Widget build(BuildContext context) {
    final index = Get.arguments;
    print('index info $index');

    final labels = AppLocalizations.of(context);
    return DefaultTabController(
      initialIndex: 0,
      length: tabbar,
      child: Scaffold(
        appBar: AppBar(
            title: Text(labels?.maintenanceList, style: appbarTextStyle()),
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
            bottom: TabBar(
              onTap: (index){
                if(index==0){
                  controller.getMaintenanceList('planned');
                }else if(index==1){
                  controller.getMaintenanceList('maintenance');
                }else{
                  controller.getMaintenanceList('done');
                }
              },
              labelColor: Colors.white,
              indicatorColor: Color.fromRGBO(216, 181, 0, 1),
              indicatorWeight: 5,
              tabs: [
                Tab(
                  text: labels.planned,
                ),
                Tab(text: labels.maintenance),
                Tab(text: labels.done),
              ],
            )
        ),
        // appBar: GradientAppBar(
        //     gradient: LinearGradient(
        //       colors: [backgroundIconColor, backgroundIconColor],
        //     ),
        //     title: Text(labels?.maintenanceList, style: appbarTextStyle()),
        //     leading: IconButton(
        //         icon: Icon(
        //           Icons.arrow_back_ios,
        //           color: Colors.white,
        //         ),
        //         onPressed: () {
        //           Get.back();
        //         }),
        //     actions: <Widget>[],
        //     automaticallyImplyLeading: true,
        //     bottom: TabBar(
        //       onTap: (index){
        //         if(index==0){
        //           controller.getMaintenanceList('planned');
        //         }else if(index==1){
        //           controller.getMaintenanceList('maintenance');
        //         }else{
        //           controller.getMaintenanceList('done');
        //         }
        //       },
        //       labelColor: Colors.white,
        //       indicatorColor: Color.fromRGBO(216, 181, 0, 1),
        //       indicatorWeight: 5,
        //       tabs: [
        //         Tab(
        //           text: 'PLANNED',
        //         ),
        //         Tab(text: 'MAINTENANCE'),
        //         Tab(text: 'DONE'),
        //       ],
        //     )
        //
        // ),

        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            MaintenanceListPage('planned'),
            MaintenanceListPage('maintenance'),
            MaintenanceListPage('done')
          ],
        ),

      ),
    );
  }
}