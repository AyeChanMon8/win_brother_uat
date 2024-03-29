// @dart=2.9

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:winbrother_hr_app/controllers/approval_controller.dart';
import 'package:winbrother_hr_app/my_class/my_app_bar.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';

import '../localization.dart';
import 'leave_detail.dart';

class ApprovedSuspensionDetails extends StatefulWidget {
  @override
  _ApprovedSuspensionDetailsState createState() => _ApprovedSuspensionDetailsState();
}

class _ApprovedSuspensionDetailsState extends State<ApprovedSuspensionDetails> {
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
      appBar: appbar(context, labels.suspensionDetails,image),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: scrollController,
        thickness: 5,
        radius: Radius.circular(10),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            margin: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    controller.suspensionApprovedList.value[index].name,
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
                      Obx(
                            () => Container(
                          child: Text(
                            controller.suspensionApprovedList.value[index].employeeId.name,
                            style: subtitleStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: 10),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         child: Text(
                //           labels.employeeContract,
                //           // ("position"),
                //           style: datalistStyle(),
                //         ),
                //       ),
                //       Obx(
                //             () => Container(
                //           child: controller.suspensionApprovedList.value[index].employeeContract !=
                //               null
                //               ? Text(
                //             controller.suspensionApprovedList.value[index].employeeContract,
                //             style: subtitleStyle(),
                //           )
                //               : Text('-'),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          labels?.company,
                          // ("date"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          (labels.branch),
                          style: datalistStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                      () => Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex:1,
                          child: Container(
                            child: Text(
                              AppUtils.removeNullString(controller.suspensionApprovedList.value[index].company_id.name),
                              style: subtitleStyle(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex:1,
                          child: Align(
                            alignment:Alignment.topRight,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left:50.0),
                                child: Text(
                                  AppUtils.removeNullString(controller.suspensionApprovedList.value[index].branch_id.name),
                                  style: subtitleStyle(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          labels.department,
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Obx(
                            () => Container(
                          child: controller.suspensionApprovedList.value[index].departmentId !=
                              null
                              ? Text(
                            controller.suspensionApprovedList.value[index].departmentId.name,
                            style: subtitleStyle(),
                          )
                              : Text('-'),
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Job Position',
                          // ("date"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Job Grade',
                          style: datalistStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                      () => Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex:1,
                          child: Container(
                            child: Text(
                              AppUtils.removeNullString(controller.suspensionApprovedList.value[index].job_id.name),
                              style: subtitleStyle(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex:1,
                          child: Align(
                            alignment:Alignment.topRight,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left:50.0),
                                child: Text(
                                  AppUtils.removeNullString(controller.suspensionApprovedList.value[index].job_grade_id.name),
                                  style: subtitleStyle(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          labels.joiningDate,
                          // ("date"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          (labels.submittedDate),
                          style: datalistStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                      () => Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            AppUtils.changeDateFormat(controller.suspensionApprovedList.value[index].joinedDate),
                            style: subtitleStyle(),
                          ),
                        ),
                        Container(
                          child: Text(
                            AppUtils.changeDateFormat(controller.suspensionApprovedList.value[index].suspension_submit_date),
                            style: subtitleStyle(),
                          ),
                        ),
                      ],
                    ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          labels.lastDayOfEmployee,
                          // ("loan_amount"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          labels.approvedLastDayOfEmployee,
                          // ("no_of_installments"),
                          style: datalistStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                      () => Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   child: Text(
                        //     AppUtils.changeDateFormat(controller.suspensionApprovedList.value[index].expectedRevealingDate.toString()),
                        //     style: subtitleStyle(),
                        //   ),
                        // ),
                        Container(
                          child: Text(
                            AppUtils.changeDateFormat(controller.suspensionApprovedList.value[index].approvedRevealingDate.toString()),
                            style: subtitleStyle(),
                          ),
                        ),
                      ],
                    ),
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
                      Expanded(
                        flex:1,
                        child: Container(
                          child: Text(
                            labels.reason,
                            // ("position"),
                            style: datalistStyle(),
                          ),
                        ),
                      ),
                      Obx(
                            () => Expanded(
                              flex:1,
                              child: Align(
                                alignment:Alignment.topRight,
                                child: Container(
                          child: controller.suspensionApprovedList.value[index].suspension_reason !=
                                  null
                                  ? Text(
                                controller.suspensionApprovedList.value[index].suspension_reason,
                                style: subtitleStyle(),
                          )
                                  : Text('-'),
                        ),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Divider(
                //   thickness: 1,
                // ),
                // Container(
                //   margin: EdgeInsets.only(top: 10),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         child: Text(
                //           labels.type,
                //           // ("position"),
                //           style: datalistStyle(),
                //         ),
                //       ),
                //       Obx(
                //             () => Container(
                //           child: controller.suspensionApprovedList.value[index].resignationType !=
                //               null
                //               ? Text(
                //             controller.suspensionApprovedList.value[index].resignationType,
                //             style: subtitleStyle(),
                //           )
                //               : Text('-'),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
