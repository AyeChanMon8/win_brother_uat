// @dart=2.9
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:winbrother_hr_app/controllers/expense_travel_list/out_of_pocket_list.dart';
import 'package:winbrother_hr_app/models/fleet_model.dart';
import 'package:winbrother_hr_app/models/leave.dart';
import 'package:winbrother_hr_app/models/leave_line.dart';
import 'package:winbrother_hr_app/models/leave_type.dart';
import 'package:winbrother_hr_app/models/outof_pocket_update.dart';
import 'package:winbrother_hr_app/models/travel_expense/category_model.dart';
import 'package:winbrother_hr_app/models/travel_expense/create/out_of_pocket_expnese_line.dart';
import 'package:winbrother_hr_app/models/travel_expense/edit_pocketModle.dart';
import 'package:winbrother_hr_app/models/travel_expense/out_of_pocket_model.dart';
import 'package:winbrother_hr_app/models/travel_expense/out_of_pocket_response.dart';
import 'package:winbrother_hr_app/models/travel_expense/pocket_model.dart';
import 'package:winbrother_hr_app/models/travel_expense/travel_expense_category.dart';
import 'package:winbrother_hr_app/models/travel_expense/create/travel_expense_model.dart';
import 'package:winbrother_hr_app/models/travel_expense/travel_expense_product.dart';
import 'package:winbrother_hr_app/pages/out_of_pocket_list.dart';
import 'package:winbrother_hr_app/routes/app_pages.dart';
import 'package:winbrother_hr_app/services/fleet_service.dart';
import 'package:winbrother_hr_app/services/leave_service.dart';
import 'package:winbrother_hr_app/services/master_service.dart';
import 'package:winbrother_hr_app/services/travel_request_service.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OutOfPocketUpdateController extends GetxController {
  var formatter = new NumberFormat("###,###", "en_US");
  var amount = 0.0.obs;
  TravelRequestService travelRequestService;
  MasterService masterService;
  FleetService fleetService;
  TextEditingController fromDateTextController;
  TextEditingController toDateTextController;
  TextEditingController purposeTextController;
  TextEditingController durationController;
  TextEditingController descriptionController;
  final is_show_expense = true.obs;
  TextEditingController dateController;
  TextEditingController qtyController = TextEditingController(text: "1");
  TextEditingController priceController;
  TextEditingController expenseproductController;
  TextEditingController totalAmountController;
  TextEditingController quantityTextController =
  TextEditingController(text: "1");
  TextEditingController totalAmount;
  TextEditingController unitPriceController;
  TextEditingController amountController;
  TextEditingController remarkTextController;
  var leavelLineList = List<LeaveLine>().obs;
  var leavetype_list = List<LeaveType>().obs;
  var category_ids = List<CategoryModel>();
  final is_add_leavelist = false.obs;
  final Rx<File> selectedImage = File('').obs;
  var travel_expense_category_list = List<TravelExpenseCategory>().obs;
  var travel_expense_product_list = List<TravelExpenseProduct>().obs;
  final RxBool isShowImage = false.obs;
  TravelRequestService _travelRequestService;
  var travelExpenseList = List<OutofPocketResponse>().obs;
  Rx<OutofPocketModel> _selectedLeaveType = OutofPocketModel().obs;
  final OutofPocketList outofpocketlistController = Get.find();
  OutofPocketModel get selectedLeaveType => _selectedLeaveType.value;
  set selectedLeaveType(OutofPocketModel type) =>
      _selectedLeaveType.value = type;
  dynamic outofpocketList = List<PockectModel>().obs;
  dynamic pocketList = List<PockectModel>().obs;
  var indexnumber = 0.obs;
  Rx<TravelExpenseModel> travelExpenseModel = TravelExpenseModel().obs;
  TravelExpenseModel get selectedtravelExpense => travelExpenseModel.value;
  var outofpocketExpenseList = List<OutofPocketResponse>().obs;
  set selectedtravelExpense(TravelExpenseModel type) =>
      travelExpenseModel.value = type;
  final RxBool save_btn_show = true.obs;
  Rx<TravelExpenseCategory> _selectedExpenseCategory =
      TravelExpenseCategory().obs;
  TravelExpenseCategory get selectedExpenseCategory =>
      _selectedExpenseCategory.value;
  set selectedExpenseCategory(TravelExpenseCategory type) =>
      _selectedExpenseCategory.value = type;
  Rx<Fleet_model> _selectedVehicle =
      Fleet_model().obs;
  Fleet_model get selectedVehicle =>
      _selectedVehicle.value;
  set selectedVehicle(Fleet_model type) =>
      _selectedVehicle.value = type;
  Rx<TravelExpenseProduct> _selectedExpenseProduct = TravelExpenseProduct().obs;
  TravelExpenseProduct get selectedExpenseProduct =>
      _selectedExpenseProduct.value;
  set selectedExpenseProduct(TravelExpenseProduct type) =>
      _selectedExpenseProduct.value = type;
  final box = GetStorage();
  final leaveInterval = 1.obs;
  String image_base64;
  var totalExpenseAmount = 0.0.obs;
  var isLoading = false.obs;
  var offset = 0.obs;
  var fleetList = List<Fleet_model>().obs;
  var fleetModel = Fleet_model().obs;
  var price_value = 0.0;
  var amount_value = 0.0;
  @override
  void onReady() async {
    super.onReady();
    this.masterService = await MasterService().init();
    this.travelRequestService = await TravelRequestService().init();
    fleetService = await FleetService().init();
    getTravelExpenseCategory();
    getTotalAmount();
    var empId = box.read('emp_id');
    getFleetList(empId);
  }

  void onChangeExpenseProductDropdown(
      TravelExpenseProduct travelExpenseProduct) async {
    this.selectedExpenseProduct = travelExpenseProduct;
    update();
  }
  void onChangeVehicleDropdown(
      Fleet_model fleet_model) async {
    this.selectedVehicle = fleet_model;
    update();
  }

  @override
  void onInit() {
    super.onInit();

    fromDateTextController = TextEditingController();
    toDateTextController = TextEditingController();
    purposeTextController = TextEditingController();
    durationController = TextEditingController();
    descriptionController = TextEditingController();
    dateController = TextEditingController();
    qtyController = TextEditingController();
    priceController = TextEditingController();
    expenseproductController = TextEditingController();
    totalAmountController = TextEditingController();
    totalAmount = TextEditingController();
    quantityTextController = TextEditingController();
    unitPriceController = TextEditingController();
    amountController = TextEditingController();
    remarkTextController = TextEditingController();
  }

  void calculateAmount() {

    if(qtyController.text.isNotEmpty&&priceController.text.isNotEmpty){
      amount.value = double.tryParse(qtyController.text) * double.tryParse(priceController.text);
      amount_value = amount.value;
      totalAmountController.text = amount.value.toString();
      totalAmount = totalAmountController;
      update();
    }else if(qtyController.text.isNotEmpty&&totalAmountController.text.isNotEmpty){
      amount.value = double.tryParse(totalAmountController.text)/double.tryParse(qtyController.text);
      priceController.text = amount.value.toStringAsFixed(2);
      update();
    }else{
      priceController.text = "";
    }

  }
  void calculateUnitAmount() {

    if(totalAmountController.text.isNotEmpty&&qtyController.text.isNotEmpty){
      amount.value = double.tryParse(totalAmountController.text)/double.tryParse(qtyController.text);
      priceController.text = amount.value.toStringAsFixed(2);
      update();
    }else{
      priceController.text = "";
    }

  }
  addExpenseLine(int lineId) async{
    if(priceController.text==0||totalAmountController.text==0){
      AppUtils.showToast('Can not add zero value!');
    }else{
      var attach_include = false;
      if(image_base64!=null&&image_base64.isNotEmpty){
         attach_include = true;
      }
      var vehicleID = 0;
      selectedExpenseCategory.is_vehicle_selected!=null?vehicleID=selectedVehicle.id:vehicleID=0;
      var travelExpense = PockectModel(
          id: 0,
          date: fromDateTextController.text,
          categ_id: selectedExpenseCategory.id,
          expense_category: selectedExpenseCategory.display_name,
          // category_name: selectedExpenseCategory.display_name,
          product_id: selectedExpenseProduct.id,
          description: descriptionController.text,
          qty: double.tryParse(qtyController.text),
          price_unit: double.tryParse(priceController.text),
          price_subtotal: double.tryParse(totalAmountController.text),
          attached_file: image_base64,
          vehicle_id:vehicleID,
          line_id: lineId,attachment_include: attach_include
      );
      outofpocketList.add(travelExpense);
      //pocketList.add(travelExpense);
      getTotalAmount();
      priceController.text = "";
      qtyController.text = "";
      totalAmountController.text = "";
      descriptionController.text = "";
      image_base64 = null;

      // Future.delayed(
      //     Duration.zero,
      //         () => Get.dialog(
      //         Center(
      //             child: SpinKitWave(
      //               color: Color.fromRGBO(63, 51, 128, 1),
      //               size: 30.0,
      //             )),
      //         barrierDismissible: false));
      // travelRequestService.addOutOfPocketExpense(travelExpense).then((value){
      //   Get.back();
      //   getTotalAmount();
      //   var travelExpense = PockectModel(
      //       id: value,
      //       date: fromDateTextController.text,
      //       categ_id: selectedExpenseCategory.id,
      //       expense_category: selectedExpenseCategory.display_name,
      //       // category_name: selectedExpenseCategory.display_name,
      //       product_id: selectedExpenseProduct.id,
      //       description: descriptionController.text,
      //       qty: double.tryParse(qtyController.text),
      //       price_unit: double.tryParse(priceController.text),
      //       price_subtotal: double.tryParse(totalAmountController.text),
      //       attached_file: image_base64,
      //       vehicle_id:vehicleID,
      //       line_id: lineId
      //   );
      //   outofpocketList.add(travelExpense);
      //
      //   priceController.text = "";
      //   qtyController.text = "";
      //   totalAmountController.text = "";
      //   descriptionController.text = "";
      //   image_base64 = null;
      // });
     // fromDateTextController.text = "";
    }

  }

  void removeRow(int index,int id){
    if(id!=null){
      travelRequestService.deleteExpenseLine(id);
    }
    outofpocketList.removeAt(index);
    getTotalAmount();
  }


  getTravelExpenseCategory() async {
    var company_id = box.read('emp_company');
    await masterService.getOutofPocketExpenseCategory(int.tryParse(company_id)).then((data) {
      this.selectedExpenseCategory = data[0];
      travel_expense_category_list.value = data;
      int id = selectedExpenseCategory.id;
      getTravelExpenseProduct(id);
    });
  }

  getTravelExpenseProduct(int id) async {
    var company_id = box.read('emp_company');
    Future.delayed(
        Duration.zero,
            () => Get.dialog(
            Center(
                child: SpinKitWave(
                  color: Color.fromRGBO(63, 51, 128, 1),
                  size: 30.0,
                )),
            barrierDismissible: false));
    await masterService.getTravelExpenseProduct(id,company_id.toString()).then((data) {
      Get.back();
      if(data.length!=0){
        this.selectedExpenseProduct = data[0];
      }
      travel_expense_product_list.value = data;
    });
  }

  void onChangeExpenseCategoryDropdown(
      TravelExpenseCategory travelExpenseCategory) async {
    this.selectedExpenseCategory = travelExpenseCategory;
    int id = selectedExpenseCategory.id;
    this.travel_expense_product_list.value.clear();
    getTravelExpenseProduct(id);
    update();
  }

  void onChangeLeaveTypeDropdown(OutofPocketModel leaveType) async {
    this.selectedLeaveType = leaveType;
    update();
  }

  updateLeaveLine(LeaveLine leaveline) {
    leavelLineList.value.add(leaveline);
  }

  getExpenseListForEmp() async {
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
    await travelRequestService.getOutofPocketModel(employee_id,offset.toString()).then((data) {

      if(offset!=0){
        isLoading.value = false;
        //outofpocketExpenseList.addAll(data);
        data.forEach((element) {
          outofpocketExpenseList.add(element);
        });
      }else{
        outofpocketExpenseList.value = data;
      }
      update();
      Get.back();
    });
  }

  getExpenseOutOfPocketForEmp() async {
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
    await _travelRequestService.getOutofPocketModel(employee_id,offset.toString()).then((data) {
      if(offset!=0){
        isLoading.value = false;
        //outofpocketExpenseList.addAll(data);
        data.forEach((element) {
          outofpocketExpenseList.add(element);
        });
      }else{
        outofpocketExpenseList.value = data;
      }
      update();
      Get.back();
    });
  }


  requestOutOfPocket(int id,String code) async {
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
    var employee_company = box.read('emp_company');
    var date = new DateTime.now().toString();

    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}";

    OutofPocketUpdateModel outRequest = OutofPocketUpdateModel(
        id: id,
        pocket_line: outofpocketList
    );
    await travelRequestService.updateOutOfPocket(id,outRequest).then((data) async{
      Get.back();

      if (data != 0) {
        save_btn_show.value = false;
        outofpocketlistController.offset.value = 0;
        await outofpocketlistController.getExpenseListForEmp();
        AppUtils.showConfirmDialog('Information', 'Successfully Update!',(){
          Get.back();
          Get.back();
          Get.back();
        });
        // Get.offNamed(Routes.CREATE_EXPENSE);
      } else {
        AppUtils.showDialog('Information', 'Updating Failed!');
      }
      //Get.back(result: 'success');
    });
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
    durationController.text = difference.toString();
    updateState();
  }
  void getTotalAmount(){
    double totalAmount = 0.0;
    outofpocketList.forEach((value) =>
    totalAmount +=value.price_subtotal
    );
    totalExpenseAmount.value = totalAmount;
  }
  void setCameraImage(File image, String image64) {
    image_base64 = image64;
    isShowImage.value = true;
    selectedImage.value = image;
  }

  getFleetList(var empId) async{
    Future.delayed(
        Duration.zero,
            () => Get.dialog(
            Center(
                child: SpinKitWave(
                  color: Color.fromRGBO(63, 51, 128, 1),
                  size: 30.0,
                )),
            barrierDismissible: false));
    fleetList.value = await fleetService.getFleetList(empId);
    if(fleetList.value.length>0){
      selectedVehicle = fleetList[0];

    }

    Get.back();
  }
}