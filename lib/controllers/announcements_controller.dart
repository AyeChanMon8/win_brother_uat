// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:winbrother_hr_app/models/announcement.dart';
import 'package:winbrother_hr_app/services/employee_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AnnouncementsController extends GetxController {
  EmployeeService employeeService;
  static AnnouncementsController to = Get.find();
  var announcementList = List<Announcement>().obs;
  final box = GetStorage();
  var isLoading = false.obs;
  var offset = 0.obs;
  @override
  void onReady() async {
    super.onReady();
    this.employeeService = await EmployeeService().init();
    getAnnouncementsList();
  }

  @override
  void onInit() {
    super.onInit();

  }
  void getAnnouncementsList() async {
    try {
      if (this.employeeService == null) {
        this.employeeService = await EmployeeService().init();
      }
      var employee_id = box.read('emp_id');
      Future.delayed(
          Duration.zero,
              () => Get.dialog(
              Center(
                  child: SpinKitWave(
                    color: Color.fromRGBO(63, 51, 128, 1),
                    size: 30.0,
                  )),
              barrierDismissible: false));
      // fetch emp_id from GetX Storage
      await employeeService
          .announcement(employee_id,offset.toString())
          .then((data) {
            if(offset!=0){
              isLoading.value = false;
              //announcementList.addAll(data.reversed.toList());
              data.forEach((element) {
                announcementList.add(element);
              });
            }else{
              announcementList.value = data.reversed.toList();
            }
            update();
            Get.back();
      });
    } catch (error) {
      print(error);
      Get.snackbar("Error ", "Error , $error");
    }
  }


  // getFile(int index, int fileid) async {
  //   Future.delayed(
  //       Duration.zero,
  //       () => Get.dialog(
  //           Center(
  //               child: SpinKitWave(
  //             color: Color.fromRGBO(63, 51, 128, 1),
  //             size: 30.0,
  //           )),
  //           barrierDismissible: false));
  //   //fetch emp_id from GetX Storage
  //   var employee_id = box.read('emp_id');
  //   await this.docService.getDocD(documentId.toString()).then((data) {
  //     doc.value = data;
  //     _createFileFromString(index, fileid);
  //     Get.back();
  //   });
  // }



  
   getFile(int index, int fileid) async {
    String encodedStr = announcementList[index].attachment_id[fileid].datas;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fullPath = "$dir/${announcementList[index].attachment_id[fileid].name}";
    final File file = File(fullPath);
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  @override
  void onClose() {
    super.onClose();
  }

}
