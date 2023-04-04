// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:winbrother_hr_app/localization.dart';
import 'package:winbrother_hr_app/models/overtime_request_response.dart';
import 'package:winbrother_hr_app/models/overtime_response.dart';
import 'package:winbrother_hr_app/models/remark.dart';
import 'package:winbrother_hr_app/pages/over_time.dart';
import 'package:winbrother_hr_app/pages/overtime_list.dart';
import 'package:winbrother_hr_app/pages/overtime_list_tabbar.dart';
import 'package:winbrother_hr_app/routes/app_pages.dart';
import 'package:winbrother_hr_app/services/employee_service.dart';
import 'package:winbrother_hr_app/services/overtime_service.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OverTimeResponseListController extends GetxController {
  TextEditingController remarkController;

  static OverTimeResponseListController to = Get.find();
  OvertimeService overtimeService;
  var otcList = List<OvertimeResponse>().obs;
  var otAcceptedList = List<OvertimeResponse>().obs;
  var otDeclinedList = List<OvertimeResponse>().obs;
  var otDraftList = List<OvertimeResponse>().obs;
  var button_show = false.obs;
  final box = GetStorage();

  @override
  void onReady(){
    super.onReady();
  }

  @override
  void onInit() async{
    remarkController = TextEditingController();
    this.overtimeService = await OvertimeService().init();
   // getOtResponseList();
    super.onInit();
  }

  getOtResponseList() async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    //fetch emp_id from GetX Storage
    var employee_id = box.read('emp_id');
    var role = box.read('role_category');
    //if (role == 'employee') {
    if(this.overtimeService == null)
    this.overtimeService = await OvertimeService().init();
      await overtimeService
          .getEmployeeOvertimeResponseList(employee_id)
          .then((data) {
              otcList.value = data;
              _getOtAcceptedList(otcList.value);
              _getOtDeclinedList(otcList.value);
              _getOtDraftList(otcList.value);
        Get.back();
      });
   /* } else {
      await overtimeService
          .getManagerOvertimeResponseList(employee_id)
          .then((data) {
        otcList.value = data;
        _getOtAcceptedList(otcList.value);
        _getOtDeclinedList(otcList.value);
        _getOtDraftList(otcList.value);
        Get.back();
      });
    }*/
  }

  approveOvertime(int id) async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await overtimeService.overtimeAccept(id).then((value) {
      Get.back();
      if (value == "true") {
        button_show.value = false;
        AppUtils.showConfirmDialog('Overtime request', 'Successfully Approved!',(){
          getOtResponseList();
          Get.back();
          Get.back();
      });
        //Get.toNamed(Routes.OVER_TIME_LIST_PAGE);
      }else{
        AppUtils.showDialog('Overtime request', value);
      }
    });
  }

  declineOvertime(int id) async {
    var remarktext = remarkController.text;
    var remark =
        Remark(remark: remarktext, remark_line: remarktext, state: "cancel");
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await overtimeService.overtimeDecline(id, remark).then((value) {
      getOtResponseList();
      Get.back();
      Get.back();
      Get.back();
     // Get.offNamed(Routes.OVER_TIME_LIST_PAGE);
    });
  }

  _getOtAcceptedList(List<OvertimeResponse> data) async {
    var list = List<OvertimeResponse>();
    for (int i = 0; i < data.length; i++) {
      if (data[i].state == 'accept') {
        list.add(data[i]);
      }
    }
    otAcceptedList.value = list.reversed.toList();
  }

  _getOtDeclinedList(List<OvertimeResponse> data) async {
    var list = List<OvertimeResponse>();
    for (int i = 0; i < data.length; i++) {
      if (data[i].state == 'cancel') {
        list.add(data[i]);
      }
    }
    otDeclinedList.value = list.reversed.toList();
  }

  _getOtDraftList(List<OvertimeResponse> data) async {
    var list = List<OvertimeResponse>();
    for (int i = 0; i < data.length; i++) {
      if (data[i].state == 'draft') {
        list.add(data[i]);
      }
    }
    otDraftList.value = list;
  }

  @override
  void dispose() {
    remarkController.dispose();
    //super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
