// @dart=2.9
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:winbrother_hr_app/controllers/travel_list_controller.dart';
import 'package:winbrother_hr_app/models/travel_expense.dart';
import 'package:winbrother_hr_app/models/travel_expense_category.dart';
import 'package:winbrother_hr_app/models/travel_line.dart';
import 'package:winbrother_hr_app/models/travel_request.dart';
import 'package:winbrother_hr_app/models/travel_request_list_response.dart';
import 'package:winbrother_hr_app/models/travel_type.dart';
import 'package:winbrother_hr_app/routes/app_pages.dart';
import 'package:winbrother_hr_app/services/master_service.dart';
import 'package:winbrother_hr_app/services/travel_request_service.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TravelRequestUpdateController extends GetxController {
  TravelRequestService _travelRequestService;
  TextEditingController fromDateTextController;
  TextEditingController toDateTextController;
  TextEditingController traveldateController;
  TextEditingController destinationTextController;
  TextEditingController purposeTextController;
  TextEditingController fromPlaceTextController;
  TextEditingController toPlaceController;
  TextEditingController durationController;
  TextEditingController destinationController;
  var traveltype_list = List<TravelType>().obs;
  final TravelListController travelListController = Get.find();
  Rx<TravelType> _selectedTravelType = TravelType().obs;
  TravelType get selectedTravelType => _selectedTravelType.value;
  set selectedTravelType(TravelType type) => _selectedTravelType.value = type;

  var travelLineList = List<TravelLine>().obs;
  var travelRequestListResponse = TravelRequestListResponse();
  final RxString duration = "".obs;
  final is_add_travel = false.obs;
  final is_show_auto_generate = false.obs;
  final is_show_expense = true.obs;
  final box = GetStorage();
  final RxBool save_btn_show = true.obs;
  final RxBool submit_btn_show = false.obs;
  var amount = 0;
  Rx<TravelExpenseCategory> _selectedExpenseType = TravelExpenseCategory().obs;
  TravelExpenseCategory get selectedExpenseType => _selectedExpenseType.value;
  set selectedExpenseType(TravelExpenseCategory type) =>
      _selectedExpenseType.value = type;

  dynamic expenseList = List<TravelExpense>().obs;
  var expenseCategoryList = List<TravelExpenseCategory>().obs;
  TextEditingController quantityTextController;
  TextEditingController unitPriceController;
  TextEditingController amountController;
  TextEditingController remarkTextController;
  @override
  void onInit() {
    fromDateTextController = TextEditingController();
    toDateTextController = TextEditingController();
    fromPlaceTextController = TextEditingController();
    toPlaceController = TextEditingController();
    destinationTextController = TextEditingController();
    purposeTextController = TextEditingController();
    traveldateController = TextEditingController();
    durationController = TextEditingController();
    destinationController = TextEditingController();
    quantityTextController = TextEditingController(text: '1');
    unitPriceController = TextEditingController();
    amountController = TextEditingController();
    remarkTextController = TextEditingController();

    super.onInit();
  }

  clearTravelRequest() {
    fromDateTextController.clear();
    toDateTextController.clear();
    fromPlaceTextController.clear();
    toPlaceController.clear();
    destinationController.clear();
    purposeTextController.clear();
    traveldateController.clear();
    durationController.clear();
    destinationTextController.clear();
    quantityTextController.text = '1';
    unitPriceController.clear();
    amountController.clear();
    remarkTextController.clear();
    save_btn_show.value = true;
    expenseList.clear();
    clearTravelLine();
  }

  @override
  void onReady() async {
    this._travelRequestService = await TravelRequestService().init();
    getExpenseCategory();
    // getTravelType();
  }

  void onChangeExpenseDropdown(TravelExpenseCategory expense) async {
    this.selectedExpenseType = expense;
    update();
  }

  void onChangeTravelTypeDropdown(TravelType travelType) async {
    this.selectedTravelType = travelType;
    update();
  }

  setTravelRequestListResponse(
      TravelRequestListResponse _travelRequestListResponse) {
    travelRequestListResponse = _travelRequestListResponse;
    showTravelRequestInformation();
  }

  showTravelRequestInformation() {
    dynamic newexpenseList = List<TravelExpense>();
    if (travelRequestListResponse != null) {
      fromPlaceTextController.text = travelRequestListResponse.city_from;
      fromDateTextController.text = travelRequestListResponse.start_date;
      toPlaceController.text = travelRequestListResponse.city_to;
      toDateTextController.text = travelRequestListResponse.end_date;
      durationController.text = travelRequestListResponse.duration.toString();
      travelLineList.value = travelRequestListResponse.travel_line;
      travelRequestListResponse.request_allowance_lines.forEach((element) {
        newexpenseList.add(TravelExpense(
            expense_categ_id: element.expense_categ_id.id,
            total_amount: element.total_amount,
            quantity: element.quantity.toInt(),
            amount: element.amount.toInt(),
            remark: element.remark,
            expense_name: element.expense_categ_id.name));
      });
      expenseList.value = newexpenseList;
    }
  }

  getExpenseCategory() async {
    var company_id = box.read('emp_company');
    await _travelRequestService.getExpenseCategory(int.tryParse(company_id)).then((data) {
      this.selectedExpenseType = data[0];
      expenseCategoryList.value = data;
    });
  }
  // updateTravelType(TravelType value) {
  //   // leaveTypeObj.update((val) {
  //   //   val.id = value.id;
  //   //   val.name =value.name;
  //   // });
  // }

  // getTravelType() async {
  //   await masterService.getTravelType().then((data) {
  //     this.selectedTravelType = data[0];
  //     traveltype_list.value = data;
  //   });
  // }

  addTravelLine(TravelLine travelLine) {
    travelLineList.add(travelLine);
  }

  addExpenseLine() {
    var expense = TravelExpense(
        expense_name: selectedExpenseType.display_name,
        expense_categ_id: selectedExpenseType.id,
        total_amount: double.tryParse(amount.toString()),
        quantity: int.tryParse(quantityTextController.text),
        amount: int.tryParse(unitPriceController.text),
        remark: remarkTextController.text);
    expenseList.add(expense);
  }

  deleteExpenseLine(TravelExpense expense) {
    expenseList.remove(expense);
  }

  updateLineData() {
    //MyController.value = TextEditingValue(text: "ANY TEXT");
  }
  clearTravelLine() {
    travelLineList.clear();
  }
  updateTravelRequest(String duration, int id) async {
    var employee_id = int.tryParse(box.read('emp_id'));
    var from_date = fromDateTextController.text;
    var to_date = toDateTextController.text;
    // var duration = int.tryParse(durationController.text);
    double durationValue = double.parse(duration.toString());
    var from_des = fromPlaceTextController.text;
    var to_des = toPlaceController.text;
    if (from_date.isNotEmpty &&
        to_date.isNotEmpty &&
        !durationValue.isNull &&
        from_des.isNotEmpty &&
        to_des.isNotEmpty &&
        travelLineList.length != 0) {
      Future.delayed(
          Duration.zero,
          () => Get.dialog(
              Center(
                  child: SpinKitWave(
                color: Color.fromRGBO(63, 51, 128, 1),
                size: 30.0,
              )),
              barrierDismissible: false));
      TravelRequest travelRequest = TravelRequest(
          employee_id: employee_id,
          start_date: from_date,
          end_date: to_date,
          city_from: from_des,
          city_to: to_des,
          duration: durationValue,
          travel_line: travelLineList,
          request_allowance_lines: expenseList);
      await _travelRequestService.deleteTravel(id).then((data) async{

        await _travelRequestService
            .travelRequest(travelRequest,1)
            .then((value) {
          //Get.back();
          if (value != 0) {
            save_btn_show.value = false;
            //submit_btn_show.value = true;
            Get.back();
            AppUtils.showConfirmDialog('Information', 'Successfully Updated!', () {
              clearTravelRequest();
              Get.back();
              Get.back();
              Get.back(result: true);
            });
          } 
          // else {
          //   AppUtils.showDialog('Information', 'Update Failed!');
          // }
        });
      });
    } else {
      AppUtils.showDialog('Warning!', "Fill Required Data!");
    }
  }

  @override
  void onClose() {
    fromDateTextController?.dispose();
    toDateTextController?.dispose();
    destinationTextController?.dispose();
    purposeTextController?.dispose();
    traveldateController?.dispose();
    fromPlaceTextController?.dispose();
    toPlaceController?.dispose();
    durationController?.dispose();
    duration.value = "";
    clearTravelLine();
    is_show_auto_generate.value = false;
    is_add_travel.value = false;
    super.onClose();
  }

  void calculateinterval(DateTime selectedFromDate, DateTime selectedToDate) {
    final fromdatetime = DateTime(
        selectedFromDate.year, selectedFromDate.month, selectedFromDate.day);
    final todatetime =
        DateTime(selectedToDate.year, selectedToDate.month, selectedToDate.day);
    final difference = todatetime.difference(fromdatetime).inDays + 1;
    // durationController.value = TextEditingValue(text: difference.toString());
  }

  void updateTravelineDestination() {
    //is_show_auto_generate.value = true;
    /* travelLineList.update((val) {
      val.forEach((element) {
        element.destination =
            fromPlaceTextController.text + "-" + toPlaceController.text;
        print(element);
      });
    });*/

    dynamic travelLineListUpdate = List<TravelLine>();

    travelLineList.forEach((val) {
      val.destination =
          fromPlaceTextController.text + "-" + toPlaceController.text;
      travelLineListUpdate.add(val);

    });

    travelLineList.value = travelLineListUpdate;
  }

  void updateAddTravelLineButtonState() {
    is_add_travel.value = true;
  }

  void updateTravelLineDestination(int index, String dest) {
    travelLineList.value[index].destination = dest;
  }

  void updateTravelLinePurpose(int index, String purpose) {
    travelLineList.value[index].purpose = purpose;
  }

  fetchTravelLine(DateTime formdate, DateTime endDate) async {
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
    String formattedFromDate = formatter.format(formdate);
    String formattedToDate = formatter.format(endDate);
    TravelRequest travel = TravelRequest(
      employee_id: employee_id,
      start_date: formattedFromDate,
      end_date: formattedToDate,
    );

    await _travelRequestService.getTravelLine(travel).then((value) {
      if(value!=null && value.length>0){
travelLineList.value = value;
      var num = 0;
      double days = 0;

      for (var i = num; i < travelLineList.length; i++) {
        if (travelLineList[i].full == true) {
          days++;
        }
        if (travelLineList[i].first == true) {
          days = days + 0.5;
        }
        if (travelLineList[i].second == true) {
          days = days + 0.5;
        }
      }
      durationController.text = days.toString();
      // durationController.value = TextEditingValue(text: days.toString());

      Get.back();
      }
    });
  }

  void updateTravelInterval(int index, int value) async {

    if (value == 1) {
      if (travelLineList.value[index].allow_full_edit) {
        travelLineList.value[index].full = true;
        travelLineList.value[index].first = false;
        travelLineList.value[index].second = false;
      } else {
        AppUtils.showDialog('Warning!', "Invalid");
      }
    } else if (value == 2) {
      if (travelLineList.value[index].allow_first_edit) {
        travelLineList.value[index].full = false;
        travelLineList.value[index].first = true;
        travelLineList.value[index].second = false;
      } else {
        AppUtils.showDialog('Warning!', "Invalid");
      }
    } else {
      if (travelLineList.value[index].allow_second_edit) {
        travelLineList.value[index].full = false;
        travelLineList.value[index].first = false;
        travelLineList.value[index].second = true;
      } else {
        AppUtils.showDialog('Warning!', "Invalid");
      }
    }
    //travelLineList.refresh();

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
    travelLineList.value[index].employee_id = employee_id;
    await _travelRequestService
        .updateTravelLine(travelLineList.value[index])
        .then((value) {
          if(value!=null){
travelLineList.removeAt(index);
      travelLineList.insert(index, value);
      var num = 0;
      double days = 0;

      for (var i = num; i < travelLineList.length; i++) {
        if (travelLineList[i].full == true) {
          days++;
        }
        if (travelLineList[i].first == true) {
          days = days + 0.5;
        }
        if (travelLineList[i].second == true) {
          days = days + 0.5;
        }
        if(i==index){
            travelLineList[i].update_status = true;
          }else{
            travelLineList[i].update_status = false;
          }
      }
      durationController.text = days.toString();
      Get.back();
          }
      
    });
  }

  // @override
  // // TODO: implement onDelete
  // get onDelete => super.onDelete;

  bool checkIsNotEmptyPurpose(){
    List<TravelLine> travelline = travelLineList.value;
    if(travelline.where((element) => element.purpose.isEmpty).toList().length>0)
      return false;

    return true;
  }
  bool checkIsNotEmptyDestination(){
    List<TravelLine> travelline = travelLineList.value;
    if(travelline.where((element) => element.destination.isEmpty).toList().length>0)
      return false;

    return true;
  }

  void calculateAmount() {
    var qty = quantityTextController.text;
    var unit_price = unitPriceController.text;
    amount = int.tryParse(qty) * int.tryParse(unit_price);
    amountController.text =
        NumberFormat.currency(name: '', decimalDigits: 0).format(amount);
    // amountController.text = amount.toString();
  }
}
