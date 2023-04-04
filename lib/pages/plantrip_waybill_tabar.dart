// @dart=2.9

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:winbrother_hr_app/controllers/plan_trip_controller.dart';
import 'package:winbrother_hr_app/localization.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/pages/plantrip_with_waybill_list.dart';

class PlanTripWayBillTabBar extends StatefulWidget {
  @override
  _StatePlanTripWayBillTabBar createState() => _StatePlanTripWayBillTabBar();
}

class _StatePlanTripWayBillTabBar extends State<PlanTripWayBillTabBar> {
  final box = GetStorage();
  final PlanTripController controller = Get.put(PlanTripController());
  List expansionlistdata = [];
  List arrayList = [];
  List doneList = [];
  List data = [];
  String role = '';
  int tabbar = 4;
  @override
  void initState() {
    super.initState();
    role = box.read('role_category');
    // tabbar = role == 'manager'||role == 'dotted_line_manager' ? 2 : 1;
  }

  @override
  Widget build(BuildContext context) {
    final index = Get.arguments;

    final labels = AppLocalizations.of(context);
    return DefaultTabController(
      initialIndex: 0,
      length: tabbar,
      child: Scaffold(
          appBar: AppBar(
            shadowColor: Colors.white,
            title: Text(labels?.planTrip, style: appbarTextStyle()),
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
              isScrollable: true,
              onTap: (index) {
                if (index == 0) {
                  controller.offset.value = 0;
                  controller.getPlantripWithWayBillList('open');
                } else if (index == 1) {
                  controller.offset.value = 0;
                  controller.getPlantripWithWayBillList('running');
                }
                else if (index == 2) {
                  controller.offset.value = 0;
                  controller.getPlantripWithWayBillList('expense_claim');
                }else {
                  controller.offset.value = 0;
                  controller.getPlantripWithWayBillList('close');
                }
              },
              labelColor: Colors.white,
              indicatorColor: Color.fromRGBO(216, 181, 0, 1),
              indicatorWeight: 5,
              tabs: [
                Tab(
                  text: labels.open,
                ),
                Tab(text: labels.running),
                Tab(text: "Expense Claim"),
                Tab(text: labels.close),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              PlantripWithWayBillListPage('open'),
              PlantripWithWayBillListPage('running'),
              PlantripWithWayBillListPage('expense_claim'),
              PlantripWithWayBillListPage('close'),
            ],
          )),
    );
  }
}
