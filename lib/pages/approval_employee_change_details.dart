// @dart=2.9

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:winbrother_hr_app/controllers/approval_controller.dart';
import 'package:winbrother_hr_app/my_class/my_app_bar.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/routes/app_pages.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';

import '../localization.dart';
import 'leave_detail.dart';

class ApprovalEmployeeChangeDetails extends StatefulWidget {
  @override
  _ApprovalEmployeeChangeDetailsState createState() => _ApprovalEmployeeChangeDetailsState();
}

class _ApprovalEmployeeChangeDetailsState extends State<ApprovalEmployeeChangeDetails> {
  final ApprovalController controller = Get.put(ApprovalController());
  final box = GetStorage();
  String image;
  int index;
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    image = box.read('emp_image');
    index = Get.arguments;
    return Scaffold(
      appBar: appbar(context, labels.employeeChangeDetails,image),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: scrollController,
        thickness: 5,
        radius: Radius.circular(10),
        child: SingleChildScrollView(
          controller: scrollController,
          child: controller.employeeChangesApprovalList.value.length > 0 ?Container(
            margin: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    controller.employeeChangesApprovalList.value[index].name,
                    style: subtitleStyle(),
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          labels?.employeeName,
                          // ("employee_name"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                          child: Text(
                            controller.employeeChangesApprovalList.value[index].employeeId.name,
                            style: subtitleStyle(),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Company',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                          child: controller.employeeChangesApprovalList.value[index].companyId.name !=
                              null
                              ? Text(
                            controller.employeeChangesApprovalList.value[index].companyId.name,
                            style: subtitleStyle(),
                          )
                              : Text('-'),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Branch',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                          child: controller.employeeChangesApprovalList.value[index].branchId.name !=
                              null
                              ? Text(
                            controller.employeeChangesApprovalList.value[index].branchId.name,
                            style: subtitleStyle(),
                          )
                              : Text('-'),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Department',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                          child: controller.employeeChangesApprovalList.value[index].departmentId.name !=
                              null
                              ? Text(
                            controller.employeeChangesApprovalList.value[index].departmentId.name,
                            style: subtitleStyle(),
                          )
                              : Text('-'),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          labels?.position,
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),Container(
                          child: controller.employeeChangesApprovalList.value[index].jobId.name !=
                              null
                              ? Text(
                            controller.employeeChangesApprovalList.value[index].jobId.name,
                            style: subtitleStyle(),
                          )
                              : Text('-'),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Job Grade',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),Container(
                          child: controller.employeeChangesApprovalList.value[index].jobGradeId.name !=
                              null
                              ? Text(
                            controller.employeeChangesApprovalList.value[index].jobGradeId.name,
                            style: subtitleStyle(),
                          )
                              : Text('-'),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Salary Level',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),Container(
                          child: controller.employeeChangesApprovalList.value[index].salaryLevelId.name !=
                              null
                              ? Text(
                            controller.employeeChangesApprovalList.value[index].salaryLevelId.name,
                            style: subtitleStyle(),
                          )
                              : Text('-'),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Wage',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                          child: controller.employeeChangesApprovalList.value[index].wage!=
                              null
                              ? Text(AppUtils.addThousnadSperator(controller.employeeChangesApprovalList.value[index].wage)
                            ,
                            style: subtitleStyle(),
                          )
                              : Text('-'),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Effective Date',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          AppUtils.changeDateFormat(controller.employeeChangesApprovalList.value[index].date),
                          style: subtitleStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'New Company',
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          AppUtils.removeNullString(controller.employeeChangesApprovalList.value[index].newCompanyId.name),
                          style: subtitleStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'New Branch',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          AppUtils.removeNullString(controller.employeeChangesApprovalList.value[index].newBranchId.name),
                          style: subtitleStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'New Department',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          AppUtils.removeNullString(controller.employeeChangesApprovalList.value[index].newDepartmentId.name),
                          style: subtitleStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'New Job Position',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          AppUtils.removeNullString(controller.employeeChangesApprovalList.value[index].newJobId.name),
                          style: subtitleStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'New Job Grade',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          AppUtils.removeNullString(controller.employeeChangesApprovalList.value[index].newJobGradeId.name),
                          style: subtitleStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'New Salary Level',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          AppUtils.removeNullString(controller.employeeChangesApprovalList.value[index].newSalaryLevelId.name),
                          style: subtitleStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'New Wage',
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          AppUtils.addThousnadSperator(controller.employeeChangesApprovalList.value[index].newWage),
                          style: subtitleStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Note',
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Text(
                            AppUtils.removeNullString(controller.employeeChangesApprovalList.value[index].note),
                            style: subtitleStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                approveButton(context)
              ],
            ),
          ):Container(),
        ),
      ),
    );
  }

  Widget approveButton(BuildContext context) {
    final labels = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: GFButton(
              onPressed: () {
                controller
                    .approveEmployeeChange(controller.employeeChangesApprovalList.value[index].id);
                print("Loan approved");
              },
              text: labels?.approve,
              blockButton: true,
              size: GFSize.LARGE,
              color: textFieldTapColor,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: GFButton(
              onPressed: () {
                controller.declinedEmployeeChange(
                    controller.employeeChangesApprovalList.value[index].id);
              },
              type: GFButtonType.outline,
              text: labels?.decline,
              textColor: textFieldTapColor,
              blockButton: true,
              size: GFSize.LARGE,
              color: textFieldTapColor,
            ),
          ),
        ],
      ),
    );
  }

}
