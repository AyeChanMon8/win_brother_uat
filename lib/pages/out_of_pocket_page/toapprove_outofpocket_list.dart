// @dart=2.9

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:winbrother_hr_app/constants/globals.dart';
import 'package:winbrother_hr_app/controllers/approval_controller.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/routes/app_pages.dart';
class ToApproveOutOfPocketList extends StatefulWidget {
  @override
  _ToApproveOutOfPocketListState createState() => _ToApproveOutOfPocketListState();
}
class _ToApproveOutOfPocketListState extends State<ToApproveOutOfPocketList> {
  final ApprovalController controller = Get.put(ApprovalController());
  final box = GetStorage();
  String image;
  @override
  void initState() {
    super.initState();
      controller.offset.value = 0;
      controller.getExpenseToApprove();
  }
  Future _loadData() async {
    controller.getExpenseToApprove();
   
  }
  @override
  Widget build(BuildContext context) {
    image = box.read('emp_image');
    var limit = Globals.pag_limit;
    return Scaffold(
      body:Obx(()=>NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!controller.isLoading.value && scrollInfo.metrics.pixels ==
              scrollInfo.metrics.maxScrollExtent) {
            // start loading data
            controller.offset.value +=limit;
            controller.isLoading.value = true;
            _loadData();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: controller.outofpocketExpenseToApproveList.value.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Container(
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.OUT_OF_POCKET_APPROVAL,
                        arguments: index);
                  },
                  child: ListTile(
                    // leading: CircleAvatar(
                    //   backgroundColor: Color.fromRGBO(216, 181, 0, 1),
                    //   child: ClipRRect(
                    //     borderRadius: new BorderRadius.circular(50.0),
                    //     child: Image.network(
                    //       "https://machinecurve.com/wp-content/uploads/2019/07/thispersondoesnotexist-1-1022x1024.jpg",
                    //       fit: BoxFit.contain,
                    //     ),
                    //   ),
                    // ),
                    // leading:
                      leading: Text(controller.outofpocketExpenseToApproveList[index].number),
                      title: Text(
                        // "Approval 1",
                        controller.outofpocketExpenseToApproveList
                            .value[index].company_id.name),
                      subtitle: Text(
                          controller.outofpocketExpenseToApproveList
                              .value[index].employee_id.name),
                      trailing: arrowforwardIcon),
                ),
              ),
            );
          },
        ),
      ),
      )
    );
  }
}