// @dart=2.9

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:winbrother_hr_app/constants/globals.dart';
import 'package:winbrother_hr_app/controllers/employee_change_controller.dart';
import 'package:winbrother_hr_app/controllers/employee_document_controller.dart';
import 'package:winbrother_hr_app/models/leave_list_response.dart';
import 'package:winbrother_hr_app/models/travel_expense/out_of_pocket_response.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/routes/app_pages.dart';
import 'package:winbrother_hr_app/services/employee_service.dart';
import 'package:winbrother_hr_app/services/leave_service.dart';
import 'package:winbrother_hr_app/services/travel_request_service.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../localization.dart';

class EmployeeDocumentList extends StatefulWidget {
  @override
  _EmployeeDocumentListState createState() => _EmployeeDocumentListState();
}

class _EmployeeDocumentListState extends State<EmployeeDocumentList> {
  EmployeeDocumentController controller =
  Get.put(EmployeeDocumentController());

  Future _loadData() async {
    print("****load more****");
    controller.getDocumentList();
    // perform fetching data delay
    //await new Future.delayed(new Duration(seconds: 2));
  }
  @override
  void initState() {
    super.initState();
    controller.offset.value = 0;
  }
  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    var limit = Globals.pag_limit;

    return Scaffold(
      appBar: AppBar(
        title:  Text(labels?.employeeDocument),
      ),
      body: Obx(
            () => NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.isLoading.value &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                print("*****BottomOfemployeeChangesApprovalList*****");
                // start loading data
                controller.offset.value += limit;
                controller.isLoading.value = true;
                _loadData();
              }
              return true;
            },
            child: ListView.builder(
              itemCount: controller.docList.value.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.grey[100],
                  child: Container(
                    margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.EMPLOYEE_DOCEMENT_DETAILS_PAGE,
                            arguments: index);
                      },
                      child: ListTile(
                          leading: Container(
                            width: 120,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppUtils.removeNullString(controller.docList[index].documentType.name
                              )),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    AppUtils.removeNullString(controller.docList.value[index].name),
                                    style: TextStyle(color: backgroundIconColor)

                                ),
                              ),
                            ],
                          ),
                          // subtitle: Align(
                          //   alignment: Alignment.topLeft,
                          //   child: Container(
                          //     child: Column(
                          //       children: [
                          //         SizedBox(height: 5),
                          //         Text(AppUtils.changeDateFormat(controller.docList.value[index].date)),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          trailing: arrowforwardIcon),
                    ),
                  ),
                );
              },
            )),
      ),

    );
  }
}
