// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:winbrother_hr_app/controllers/day_trip_expense_controller.dart';
import 'package:winbrother_hr_app/controllers/daytrip_plantrip_fuel_advance_controller.dart';
import 'package:winbrother_hr_app/models/daytrip_advance_expense_category.dart';
import 'package:winbrother_hr_app/my_class/my_app_bar.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';

class AddAdvancePage extends StatelessWidget {
//final DayTripExpenseController day_trip_controller = Get.find();
DayTripPlanTripGeneralController day_trip_controller = Get.put(DayTripPlanTripGeneralController());
var from_where = "";
var arg_id = 0;
var advanceTotal = 0.0;
var advanceLineTotal = 0.0;
AddAdvancePage(String from,int daytrip_id , double advanceTotal,double advanceLineTotal){
  arg_id = daytrip_id;
  from_where = from;
  this.advanceTotal = advanceTotal;
  this.advanceLineTotal = advanceLineTotal;
  day_trip_controller.quantityTextController.clear();
  day_trip_controller.amountTextController.clear();
  day_trip_controller.remarkTextController.clear();
  day_trip_controller.totalAmountController.clear();
  day_trip_controller.getAdvanceExpenseCategoryList();
}
@override
Widget build(BuildContext context) {
  //arg = Get.arguments;
  return Scaffold(
    appBar: appbar(context, 'Add Advance', ''),
    body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            expenseCategoryDropDown(),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Theme(
                  data: new ThemeData(
                    primaryColor: textFieldTapColor,
                  ),
                  child: TextField(
                    enabled: true,
                    controller: day_trip_controller.quantityTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: (("Quantity")),
                    ),
                    onChanged: (text) {
                      day_trip_controller.calculateAdvanceAmount();
                    },
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Theme(
                  data: new ThemeData(
                    primaryColor: textFieldTapColor,
                  ),
                  child: TextField(
                    enabled: true,
                    controller: day_trip_controller.amountTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: (("Amount")),
                    ),
                    onChanged: (text) {
                      day_trip_controller.calculateAdvanceAmount();
                    },
                  ),
                )),
            SizedBox(
              height: 20,
            ),

            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Theme(
                  data: new ThemeData(
                    primaryColor: textFieldTapColor,
                  ),
                  child: TextField(
                    enabled: true,
                    controller: day_trip_controller.totalAmountController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: (("Total Amount")),
                    ),
                    onChanged: (text) {
                      day_trip_controller.calculateAdvancePriceUnit();
                    },
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Theme(
                  data: new ThemeData(
                    primaryColor: textFieldTapColor,
                  ),
                  child: TextField(
                    enabled: true,
                    controller: day_trip_controller.remarkTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: (("Remark")),
                    ),
                    onChanged: (text) {},
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              child:  GFButton(
                color: textFieldTapColor,
                onPressed: () {
                  advanceLineTotal = double.tryParse(day_trip_controller.totalAmountController.text.toString());
                  if(advanceTotal>=advanceLineTotal)
                  day_trip_controller.addAdvance(from_where,arg_id);
                  else
                  AppUtils.showDialog('Warning!','Total advance must not exceed allowed advance!');
                },
                text: "Save",
                blockButton: true,
                size: GFSize.LARGE,
              ),
            ),


          ],
        ),
      ),
    ),
  );
}

Widget expenseCategoryDropDown() {
  return Container(
    margin: EdgeInsets.only(left: 10, right: 10),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            // color: Colors.white,
            // height: 50,
            // margin: EdgeInsets.only(right: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[350], width: 2),
                // Border.all(color: Colors.white, width: 2),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(1),
                ),
              ),
              child: Theme(
                data: new ThemeData(
                  primaryColor: Color.fromRGBO(60, 47, 126, 1),
                  primaryColorDark: Color.fromRGBO(60, 47, 126, 1),
                ),
                child: Obx(
                      () => DropdownButtonHideUnderline(
                    child: DropdownButton<Daytrip_advance_expense_category>(
                        hint: Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Expense Category",
                            )),
                        value: day_trip_controller.selectedExpenseCategory,
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 30,
                        isExpanded: true,
                        onChanged: (Daytrip_advance_expense_category value) {
                          day_trip_controller.onChangeExpenseCategoryForAdvanceDropdown(value);
                        },
                        items: day_trip_controller.exp_category_list
                            .map((Daytrip_advance_expense_category category) {
                          return DropdownMenuItem<Daytrip_advance_expense_category>(
                            value: category,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                category.displayName,
                                style: TextStyle(),
                              ),
                            ),
                          );
                        }).toList()),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}
