// @dart=2.9
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:winbrother_hr_app/controllers/leave_list_controller.dart';
import 'package:winbrother_hr_app/models/leave.dart';
import 'package:winbrother_hr_app/models/leave_line.dart';
import 'package:winbrother_hr_app/models/leave_type.dart';
import 'package:winbrother_hr_app/routes/app_pages.dart';
import 'package:winbrother_hr_app/services/leave_service.dart';
import 'package:winbrother_hr_app/services/master_service.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LeaveRequestUpdateController extends GetxController {
  LeaveService leaveService;
  MasterService masterService;
  TextEditingController fromDateTextController;
  TextEditingController toDateTextController;
  TextEditingController purposeTextController;
  TextEditingController durationController;
  TextEditingController descriptionController;
  var leavelLineList = List<LeaveLine>().obs;
  var leavetype_list = List<LeaveType>().obs;
  final is_add_leavelist = false.obs;
  final Rx<File> selectedImage = File('').obs;
  final RxBool isShowImage = false.obs;
  final RxBool save_btn_show = true.obs;
  final RxBool submit_btn_show = false.obs;

  Rx<LeaveType> _selectedLeaveType = LeaveType().obs;
  LeaveType get selectedLeaveType => _selectedLeaveType.value;
  set selectedLeaveType(LeaveType type) => _selectedLeaveType.value = type;
  final RxBool change_date = true.obs;
  final box = GetStorage();
  final leaveInterval = 1.obs;
  String image_base64 = "";
  var weekday_arr = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];
  final LeaveListController leavelist_controller = Get.find();
  @override
  void onReady() async {
    super.onReady();
    this.leaveService = await LeaveService().init();
    this.masterService = await MasterService().init();
    getLeaveType();
  }

  @override
  void onInit() {
    super.onInit();
    fromDateTextController = TextEditingController();
    toDateTextController = TextEditingController();
    purposeTextController = TextEditingController();
    durationController = TextEditingController();
    descriptionController = TextEditingController();
  }

  void onChangeLeaveTypeDropdown(LeaveType leaveType) async {
    this.selectedLeaveType = leaveType;
    update();
  }

  updateLeaveLine(LeaveLine leaveline) {
    leavelLineList.value.add(leaveline);
  }

  fetchLeaveLine(DateTime formdate, DateTime endDate) async {

    Future.delayed(
        Duration.zero,
            () => Get.dialog(
            Center(
                child: SpinKitWave(
                  color: Color.fromRGBO(63, 51, 128, 1),
                  size: 30.0,
                )),
            barrierDismissible: false));
    var employee_id = int.tryParse(box.read('emp_id'));
    var formatter = new DateFormat('yyyy-MM-dd');
    var now = new DateTime.now();
    int days;
    String formattedFromDate = formatter.format(formdate);
    String formattedToDate = formatter.format(endDate);

    Leave leave = Leave(
      employee_id: employee_id,
      start_date: formattedFromDate,
      end_date: formattedToDate,
    );
    await leaveService.getLeaveLine(leave).then((value) {
      Get.back();
      if (value != null) {
        if (value[0].message == null) {
          leavelLineList.value = value;
          var num = 0;
          double days = 0;

          for (var i = num; i < leavelLineList.length; i++) {
            if (leavelLineList[i].full == true) {
              days++;
            }
            if (leavelLineList[i].first == true) {
              days = days + 0.5;
            }
            if (leavelLineList[i].second == true) {
              days = days + 0.5;
            }
          }
          durationController.text = days.toString();
          updateState();
        } else {
          AppUtils.showDialog('Information', value[0].message);
          leavelLineList.clear();
        }
      } else {
        leavelLineList.clear();
      }
    });
  }

  createLeaveLine(DateTime formdate, DateTime endDate) {
    var formatter = new DateFormat('yyyy-MM-dd');
    var now = new DateTime.now();
    String formattedDate = formatter.format(now); // 2016-01-25
    clearLeaveLine();
    var days = AppUtils.getDaysInBeteween(formdate, endDate);
    for (int i = 0; i < days.length; i++) {
      var day_split = days[i].toString();
      var split_date = day_split.split(' ')[0];
      var weekday = weekday_arr[days[i].weekday - 1];

      var leaveLine = LeaveLine(
        // day: weekday,
          date: formattedDate,
          full: true,
          first: false,
          second: false,
          start_date: split_date,
          end_date: toDateTextController.text);
      updateLeaveLine(leaveLine);
    }
  }

  updateLeaveType(LeaveType value) {
    // leaveTypeObj.update((val) {
    //   val.id = value.id;
    //   val.name =value.name;
    // });
  }
  requestUpdateLeave(String duration, String id) async {
    var employee_id = int.tryParse(box.read('emp_id'));
    var from_date = fromDateTextController.text;
    var to_date = toDateTextController.text;
    var duration = int.tryParse(durationController.text);
    double durationValue = 0.0;
    if (!duration.isNull) {
      double durationValue = double.parse(duration.toString());
    }

    var description = descriptionController.text;
    bool valid = false;

    if (from_date.isEmpty) {
      AppUtils.showDialog('Information', 'Please Choose Start Date!');
    } else if (to_date.isEmpty) {
      AppUtils.showDialog('Information', 'Please Choose End Date!');
    } else if (from_date.isEmpty && to_date.isEmpty) {
      DateTime startDate = DateTime.parse(from_date);
      DateTime endDate = DateTime.parse(to_date);
      if (endDate.isBefore(startDate)) {
        valid = false;
        AppUtils.showDialog('Information',
            'End Date should be grater than or equal Start Date');
      } else {
        valid = true;
      }
    } else if (description.isEmpty) {
      AppUtils.showDialog('Information', 'Please Fill Description!');
    } else {
      if (selectedLeaveType.name == 'Sick Leaves') {
        if (image_base64.isNotEmpty) {
          valid = true;
        } else {
          valid = false;
          AppUtils.showDialog(
              'Information', 'Please Attach File for Sick Leave!');
        }
      } else {
        valid = true;
      }
    }
    if (valid) {
      Future.delayed(
          Duration.zero,
              () => Get.dialog(
              Center(
                  child: SpinKitWave(
                    color: Color.fromRGBO(63, 51, 128, 1),
                    size: 30.0,
                  )),
              barrierDismissible: false));
      Leave leaveRequest = Leave(
          employee_id: employee_id,
          holiday_status_id: selectedLeaveType.id,
          start_date: from_date,
          end_date: to_date,
          duration: durationValue,
          description: description,
          attachment: image_base64,
          leave_line: leavelLineList);

      await leaveService.deleteLeave(int.tryParse(id)).then((data) async{
        if(data){
        await leaveService.createLeave(leaveRequest,1).then((data) {
          Get.back();
          if (data.contains("ERROR")) {
            AppUtils.showDialog('Information', data);
          } else {
            //save_btn_show.value = false;
            // leavelist_controller.getLeaveList();
            //  AppUtils.showDialog('Information', 'Successfully Saved!');
            isShowImage.value = false;
            AppUtils.showConfirmDialog('Information', 'Successfully Updated!', (){
              Get.back();
              Get.back();
              Get.back(result: true);
            });
          }
          //Get.back(result: 'success');
        });
        }
      });

    }
  }

  requestLeave(String duration) async {
    var employee_id = int.tryParse(box.read('emp_id'));
    var from_date = fromDateTextController.text;
    var to_date = toDateTextController.text;
    var duration = int.tryParse(durationController.text);
    double durationValue = 0.0;
    if (!duration.isNull) {
      double durationValue = double.parse(duration.toString());

    }

    var description = descriptionController.text;
    bool valid = false;

    if (from_date.isEmpty) {
      AppUtils.showDialog('Information', 'Please Choose Start Date!');
    } else if (to_date.isEmpty) {
      AppUtils.showDialog('Information', 'Please Choose End Date!');
    } else if (from_date.isEmpty && to_date.isEmpty) {
      DateTime startDate = DateTime.parse(from_date);
      DateTime endDate = DateTime.parse(to_date);
      if (endDate.isBefore(startDate)) {
        valid = false;
        AppUtils.showDialog('Information',
            'End Date should be grater than or equal Start Date');
      } else {
        valid = true;
      }
    } else if (description.isEmpty) {
      AppUtils.showDialog('Information', 'Please Fill Description!');
    } else {
      if (selectedLeaveType.name == 'Sick Leaves') {
        if (image_base64.isNotEmpty) {
          valid = true;
        } else {
          valid = false;
          AppUtils.showDialog(
              'Information', 'Please Attach File for Sick Leave!');
        }
      } else {
        valid = true;
      }
    }
    if (valid) {
      Future.delayed(
          Duration.zero,
              () => Get.dialog(
              Center(
                  child: SpinKitWave(
                    color: Color.fromRGBO(63, 51, 128, 1),
                    size: 30.0,
                  )),
              barrierDismissible: false));
      Leave leaveRequest = Leave(
          employee_id: employee_id,
          holiday_status_id: selectedLeaveType.id,
          start_date: from_date,
          end_date: to_date,
          duration: durationValue,
          description: description,
          attachment: image_base64,
          leave_line: leavelLineList);

      await leaveService.createLeave(leaveRequest,0).then((data) {
        
        if (data.contains("ERROR")) {
          AppUtils.showDialog('Information', data);
        } else {
          Get.back();
          //save_btn_show.value = false;
          leavelist_controller.getLeaveList();
          AppUtils.showDialog('Information', 'Successfully Saved!');
          isShowImage.value = false;
          Get.offNamed(Routes.LEAVE_TRIP_TAB_BAR);
        }
        //Get.back(result: 'success');
      });
    }
  }

  getLeaveType() async {
    await masterService.getLeaveType().then((data) {
      //this.selectedLeaveType = LeaveType(id: 0,name:"Leave Type");
     // this.selectedLeaveType = data[0];
      leavetype_list.value = data;
    });
  }

  updateLeaveInterval(int index, int value) async {

    bool valid = false;
    if (value == 1) {
      if (leavelLineList.value[index].allow_full_edit) {
        valid = true;
        leavelLineList.value[index].full = true;
        leavelLineList.value[index].first = false;
        leavelLineList.value[index].second = false;
      } else {
        AppUtils.showToast("Invalid");
      }
    } else if (value == 2) {
      if (leavelLineList.value[index].allow_first_edit) {
        valid = true;
        leavelLineList.value[index].full = false;
        leavelLineList.value[index].first = true;
        leavelLineList.value[index].second = false;
      } else {
        AppUtils.showToast("Invalid");
      }
    } else {
      if (leavelLineList.value[index].allow_second_edit) {
        valid = true;
        leavelLineList.value[index].full = false;
        leavelLineList.value[index].first = false;
        leavelLineList.value[index].second = true;
      } else {
        AppUtils.showToast("Invalid");
      }
    }
    if (valid) {
      Future.delayed(
          Duration.zero,
              () => Get.dialog(
              Center(
                  child: SpinKitWave(
                    color: Color.fromRGBO(63, 51, 128, 1),
                    size: 30.0,
                  )),
              barrierDismissible: false));
               var employee_id = int.tryParse(box.read('emp_id'));
      leavelLineList.value[index].employee_id = employee_id;
      await leaveService
          .updateLeaveLine(leavelLineList.value[index])
          .then((value) {
        if(value!=null){
          change_date.value = false;
  leavelLineList.removeAt(index);
        leavelLineList.insert(index, value);
        var num = 0;
        double days = 0;

        for (var i = num; i < leavelLineList.length; i++) {
          if (leavelLineList[i].full == true) {
            days++;
          }
          if (leavelLineList[i].first == true) {
            days = days + 0.5;
          }
          if (leavelLineList[i].second == true) {
            days = days + 0.5;
          }
          var employee_id = int.tryParse(box.read('emp_id'));
          if(i==index){
            leavelLineList[i].update_status = true;
            leavelLineList[i].employee_id = employee_id;
          }else{
            leavelLineList[i].update_status = false;
            leavelLineList[i].employee_id = employee_id;
          }
        }
        durationController.text = '$days';
        Get.back();
        }else{
          change_date.value = false;
        }
      });
    }
  }

  @override
  void onClose() {
    // fromDateTextController?.dispose();
    // toDateTextController?.dispose();
    // purposeTextController?.dispose();
    // durationController?.dispose();
    // descriptionController?.dispose();
    clearLeaveLine();
    isShowImage.value = false;
    is_add_leavelist.value = false;
    leaveInterval.value = 1;
    super.onClose();
  }

  clearLeaveLine() {
    leavelLineList.clear();
  }

  nullPhoto() {
    isShowImage.value = false;
    selectedImage.value = null;
  }

  void updateState() {
    is_add_leavelist.value = true;
  }

  void calculateinterval(DateTime selectedFromDate, DateTime selectedToDate) {
    final fromdatetime = DateTime(
        selectedFromDate.year, selectedFromDate.month, selectedFromDate.day);
    final todatetime =
    DateTime(selectedToDate.year, selectedToDate.month, selectedToDate.day);
    final difference = todatetime.difference(fromdatetime).inDays + 1;
    // var num = 0;
    //   double days = 0;

    //   for (var i = num; i < leavelLineList.length; i++) {
    //     if (leavelLineList[i].full == true) {
    //       days++;
    //     }
    //     if (leavelLineList[i].first == true) {
    //       days = days + 0.5;
    //     }
    //     if (leavelLineList[i].second == true) {
    //       days = days + 0.5;
    //     }
    //   }
    // print(difference);
    // durationController.text = days.toString();
    updateState();
  }

  void setCameraImage(File image, String image64) {
    image_base64 = image64;
    isShowImage.value = true;
    selectedImage.value = image;
  }
}
