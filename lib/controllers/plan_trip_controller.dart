// @dart=2.9
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:winbrother_hr_app/models/base_route.dart';
import 'package:winbrother_hr_app/models/daytrip_advance_expense_category.dart';
import 'package:winbrother_hr_app/models/daytrip_expense.dart';
import 'package:winbrother_hr_app/models/plan_trip_product.dart';
import 'package:winbrother_hr_app/models/plantrip_fuel_consumption.dart';
import 'package:winbrother_hr_app/models/plantrip_product_expense_line.dart';
import 'package:winbrother_hr_app/models/plantrip_waybill.dart';
import 'package:winbrother_hr_app/models/plantrip_waybill_expense_line.dart';
import 'package:winbrother_hr_app/models/stock_location.dart';
import 'package:winbrother_hr_app/pages/plantrip_waybill_details.dart';
import 'package:winbrother_hr_app/routes/app_pages.dart';
import 'package:winbrother_hr_app/services/master_service.dart';

import 'package:winbrother_hr_app/services/plan_trip_service.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';
import 'package:winbrother_hr_app/widgets/alert_widget.dart';

class PlanTripController extends GetxController {
  PlanTripServie planTripServie;
  MasterService masterService;
  TextEditingController actualAmountTextController;
  TextEditingController descriptionTextController;
  TextEditingController expenseActualTextController;
  TextEditingController expenseDescriptionTextController;
  TextEditingController wayBillexpenseActualTextController;
  String  routeName;
  TextEditingController wayBillexpenseDescriptionTextController;
  TextEditingController productQtyController;
  final box = GetStorage();
  var plantrip_with_product_list = List<Plan_trip_product>().obs;
  var plantrip_with_waybill_list = List<Plantrip_waybill>().obs;
  var plantrip_with_product_toapprove_list = List<Plan_trip_product>().obs;
  var plantrip_with_waybill_topprove_list = List<Plantrip_waybill>().obs;
  var showDetails = true.obs;
  var arg_index = 0.obs;
//plantrip product
  Plan_trip_product planTripModel;
  var expense_list = List<Expense_ids>().obs;
  var fuel_list = List<Fuelin_ids>().obs;
  var product_ids_list = List<Product_ids>().obs;
  var advance_allowance_ids_list = List<Request_allowance_lines>().obs;
  var route_ids_list = List<PlanTrip_Consumption_ids>().obs;
  var plantrip_id = 0;
//plantrip waybill
  Plantrip_waybill planTripWayBillModel;
  var waybill_expense_list = List<WayBill_Expense_ids>().obs;
  var waybill_fuel_list = List<WayBill_Fuelin_ids>().obs;
  var waybill_product_ids_list = List<Commission_ids>().obs;
  var waybill_advance_allowance_ids_list =
      List<WayBill_Request_allowance_lines>().obs;
  var waybill_route_plan_ids_list = List<WayBill_Route_plan_ids>().obs;
  var route_plan_ids_list = List<Route_plan_ids>().obs;
  var waybill_ids_list = List<Waybill_ids>().obs;
  var waybill_route_ids_list = List<Consumption_ids>().obs;
  var plantrip_waybill_id = 0;

  Rx<Stock_location> _selectedLocation = Stock_location().obs;
  Stock_location get selectedLocation => _selectedLocation.value;
  set selectedLocation(Stock_location type) => _selectedLocation.value = type;
  var location_list = List<Stock_location>().obs;

  Rx<Daytrip_expense> _selectedProduct = Daytrip_expense().obs;
  Daytrip_expense get selectedProduct => _selectedProduct.value;
  set selectedProduct(Daytrip_expense type) => _selectedProduct.value = type;
  var product_list = List<Daytrip_expense>().obs;
  var isLoading = false.obs;
  var offset = 0.obs;
  var waybill_isLoading = false.obs;
  var waybill_offset = 0.obs;
  var current_page = 'open'.obs;
  var selectedExpensePlanTripProductImage = "";
  var selectedExpensePlanTripWayBillImage = "";
  final Rx<File> selectedPlantripImage = File('').obs;
  final RxBool isShowImage = false.obs;
  final Rx<File> selectedPlantripWayBillImage = File('').obs;

  Rx<PlanTrip_Consumption_ids> _selectedRoute = PlanTrip_Consumption_ids().obs;
  PlanTrip_Consumption_ids get selectedRoute => _selectedRoute.value;
  set selectedRoute(PlanTrip_Consumption_ids route) =>
      _selectedRoute.value = route;

  Rx<Consumption_ids> _selectedWayBillRoute = Consumption_ids().obs;
  Consumption_ids get selectedWayBillRoute => _selectedWayBillRoute.value;
  set selectedWayBillRoute(Consumption_ids route) =>
      _selectedWayBillRoute.value = route;

  //Expense Category Dropdown for Advance
  Rx<Daytrip_advance_expense_category> _selectedExpenseCategory =
      Daytrip_advance_expense_category().obs;
  Daytrip_advance_expense_category get selectedExpenseCategory =>
      _selectedExpenseCategory.value;
  set selectedExpenseCategory(Daytrip_advance_expense_category type) =>
      _selectedExpenseCategory.value = type;
  var exp_category_list = List<Daytrip_advance_expense_category>().obs;

  //plantrip expense route dropdown
  Rx<Expense_ids> _selectedExpenseRouteCategory = Expense_ids().obs;
  Expense_ids get selectedExpenseRouteCategory =>
      _selectedExpenseRouteCategory.value;
  set selectedExpenseRouteCategory(Expense_ids type) =>
      _selectedExpenseRouteCategory.value = type;
  //waybill expense route dropdown
  Rx<WayBill_Expense_ids> _selectedWayBillExpenseRouteCategory =
      WayBill_Expense_ids().obs;
  WayBill_Expense_ids get selectedWayBillExpenseRouteCategory =>
      _selectedWayBillExpenseRouteCategory.value;
  set selectedWayBillExpenseRouteCategory(WayBill_Expense_ids type) =>
      _selectedWayBillExpenseRouteCategory.value = type;

  var show_standard_liter = true.obs;
  var show_standard_amount = true.obs;
  var consumption_ids_list = List<PlanTrip_Consumption_ids>().obs;
  TextEditingController fromDateTextController;
  TextEditingController toDateTextController;

  Rx<BaseRoute> _selectedBaseRoute = BaseRoute().obs;
  BaseRoute get selectedBaseRoute => _selectedBaseRoute.value;
  set selectedBaseRoute(BaseRoute type) => _selectedBaseRoute.value = type;
  var base_route_list = List<BaseRoute>().obs;
  var expense_status = ''.obs;
  var expenseStandardAmount = 0.0.obs;
  var expenseActualAmount = 0.0.obs;
  var expenseOverAmount = 0.0.obs;
  @override
  void onInit() {
    super.onInit();
    actualAmountTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    expenseActualTextController = TextEditingController();
    expenseDescriptionTextController = TextEditingController();
    wayBillexpenseActualTextController = TextEditingController();
    wayBillexpenseDescriptionTextController = TextEditingController();
    productQtyController = TextEditingController();
    fromDateTextController = TextEditingController();
    toDateTextController = TextEditingController();
  }

  @override
  void onReady() async {
    super.onReady();
    this.planTripServie = await PlanTripServie().init();
    this.masterService = await MasterService().init();
    // getPlantripList();
    //getPlantripWithWayBillList();
    getAddFuelLocation();
    getProductForFuelTab();
    getAdvanceExpenseCategoryList();

    //getPlantripToApproveList();
    // getPlantripWithWayBillToApproveList();
  }

  fetchExpenseStatusData(int tripID, String state) async {
    print('fetchExpenseStatusData');
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie
        .fetchExpenseStatusDayTipPlantrip(tripID, state)
        .then((data) {
      print('fetchExpenseStatusData##');
      print(data);
      Get.back();
      expense_status.value = data;
    });
  }

  Future<void> getPlantripList(String state) async {
    this.planTripServie = await PlanTripServie().init();
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
    await planTripServie
        .getPlanTripWithProductList(
            int.tryParse(employee_id), offset.toString(), state)
        .then((data) {
      if (offset != 0) {
        // update data and loading status
        isLoading.value = false;
        //plantrip_with_product_list.addAll(data);
        data.forEach((element) {
          plantrip_with_product_list.add(element);
        });
      } else {
        plantrip_with_product_list.value = data;
      }
      update();
      Get.back();
    });
  }

  Future<void> getPlantripWithWayBillList(String state) async {
    this.planTripServie = await PlanTripServie().init();
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

    await planTripServie
        .getPlanTripWithWayBillList(
            int.tryParse(employee_id), waybill_offset.toString(), state)
        .then((data) {
      plantrip_with_waybill_list.value.clear();
      if (waybill_offset != 0) {
        // update data and loading status
        waybill_isLoading.value = false;
        //plantrip_with_waybill_list.addAll(data);
        print("Data: ${waybill_offset.toString()}");

        data.forEach((element) {
          plantrip_with_waybill_list.add(element);
        });
      } else {
        plantrip_with_waybill_list.value = data;
        //plantrip_with_waybill_list.addAll(data);
      }
      update();
       if(state == 'running'){
      //   log('plantrip_with_waybill_list length => ${plantrip_with_waybill_list.length}');
      //   arg_index.value = plantrip_with_waybill_list.length - 1;
      //   log('arg_index => $arg_index');
      //   // recalculate
        if(plantrip_with_waybill_list!=null && plantrip_with_waybill_list.length>0){
          calculateTotalExpense(plantrip_with_waybill_list[arg_index.value].expenseIds);
        }
        //calculateTotalExpense(plantrip_with_waybill_list[arg_index.value].expenseIds);
       }
      Get.back();
    });
  }

  getAdvanceExpenseCategoryList() async {
    var company_id = box.read('emp_company');
    await planTripServie
        .getDayTripAdvanceExpenseCategory(int.tryParse(company_id))
        .then((data) {
      data.insert(
          0,
          Daytrip_advance_expense_category(
              id: 0, displayName: 'Expense Category Type'));
      this.selectedExpenseCategory = data[0];
      exp_category_list.value = data;
    });
  }

  getAddFuelLocation() async {
    await planTripServie.getStockLocationList().then((data) {
      data.insert(0, Stock_location(id: 0, name: 'Location'));
      this.selectedLocation = data[0];
      location_list.value = data;
    });
  }

  getProductForFuelTab() async {
    var company_id = box.read('emp_company');
    await planTripServie
        .getDayTripProductListForFuelTab(company_id.toString())
        .then((data) {
      data.insert(0, Daytrip_expense(id: 0, name: 'Product'));
      this.selectedProduct = data[0];
      product_list.value = data;
    });
  }

  addPlanTripProductFuelConsumption(
      Plan_trip_product planTripProduct, int lineID) async {
    bool valid = false;
    if (actualAmountTextController.text.isEmpty) {
      Get.snackbar('Warning', "Fill Required Data!",
          snackPosition: SnackPosition.BOTTOM);
      valid = false;
    } else if (double.tryParse(actualAmountTextController.text) >
        this.selectedBaseRoute.fuel_liter) {
      if (descriptionTextController.text.isEmpty) {
        Get.snackbar('Warning', "Please Fill Description!",
            snackPosition: SnackPosition.BOTTOM);
        valid = false;
      } else {
        valid = true;
      }
    } else {
      valid = true;
    }
    if (valid) {
      var endTrip;
      if (lineID == 0) {
        endTrip = Plantrip_fuel_consumption(
            planTripId: plantrip_id,
            consumedLiter: double.parse(actualAmountTextController.text),
            description: descriptionTextController.text,
            route_id: this.selectedBaseRoute.id,
            date: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()));
      } else {
        endTrip = Plantrip_fuel_consumption(
            planTripId: plantrip_id,
            consumedLiter: double.parse(actualAmountTextController.text),
            description: descriptionTextController.text,
            route_id: this.selectedBaseRoute.id,
            date: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
            line_id: lineID);
      }
      AppUtils.showConfirmCancelDialog('Warning', 'Are you sure?', () async {
        // var endTrip  = Plantrip_fuel_consumption(planTripId: plantrip_id,consumedLiter: double.parse(actualAmountTextController.text),description:descriptionTextController.text,route_id: this.selectedRoute.routeId.id,date: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()));
        //
        Future.delayed(
            Duration.zero,
            () => Get.dialog(
                Center(
                    child: SpinKitWave(
                  color: Color.fromRGBO(63, 51, 128, 1),
                  size: 30.0,
                )),
                barrierDismissible: false));
        await planTripServie.addPlanTripFuelConsumption(endTrip).then((data) {
          if (data != 0) {
            Get.defaultDialog(
                title: 'Information',
                content: Text('Successfully Added!'),
                confirmTextColor: Colors.white,
                onConfirm: () {
                  actualAmountTextController.text = '';
                  descriptionTextController.text = '';
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.back(result: true);
                });
          }
        });
      }, () async {});
    }
  }

  addPlanTripWillbillFuelConsumption(
      Plantrip_waybill planTripWayBill, int lineID) async {
    print("DateTime");
    print(DateFormat("yyyy-MM-dd").format(DateTime.now()));
    bool valid = false;
    if (actualAmountTextController.text.isEmpty) {
      Get.snackbar('Warning', "Fill Required Data!",
          snackPosition: SnackPosition.BOTTOM);
      valid = false;
    } else if (double.tryParse(actualAmountTextController.text) >
        this.selectedBaseRoute.fuel_liter) {
      if (descriptionTextController.text.isEmpty) {
        Get.snackbar('Warning', "Please Fill Description!",
            snackPosition: SnackPosition.BOTTOM);
        valid = false;
      } else {
        valid = true;
      }
    } else {
      valid = true;
    }
    if (valid) {
      var endTrip;
      if (lineID == 0) {
        endTrip = Plantrip_fuel_consumption(
            planTripId: planTripWayBill.id,
            consumedLiter: double.parse(actualAmountTextController.text),
            description: descriptionTextController.text,
            route_id: this.selectedBaseRoute.id,
            date: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()));
        ;
      } else {
        endTrip = Plantrip_fuel_consumption(
            planTripId: planTripWayBill.id,
            consumedLiter: double.parse(actualAmountTextController.text),
            description: descriptionTextController.text,
            route_id: this.selectedBaseRoute.id,
            date: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
            line_id: lineID);
      }
      AppUtils.showConfirmCancelDialog('Warning', 'Are you sure?', () async {
        print("DateTime");
        print(DateFormat("yyyy-MM-dd").format(DateTime.now()));

        await planTripServie
            .addPlanTripWaybillFuelConsumption(endTrip)
            .then((data) {
          if (data != 0) {
            Get.defaultDialog(
                title: 'Information',
                content: Text('Successfully Added!'),
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back();
                  Get.back();
                  Get.back(result: true);
                });
          }
        });
      }, () async {});
    }
  }

  saveExpense(String type, int lineID) async {
    var employee_id = box.read('emp_id');
    if (type == 'product') {
      bool valid = false;
      if (expenseActualTextController.text.isEmpty) {
        Get.snackbar('Warning', "Fill Required Data!",
            snackPosition: SnackPosition.BOTTOM);
        valid = false;
      } else if (double.tryParse(expenseActualTextController.text) >
          this.selectedExpenseRouteCategory.standardAmount) {
        if (expenseDescriptionTextController.text.isEmpty) {
          Get.snackbar('Warning', "Please Fill Description!",
              snackPosition: SnackPosition.BOTTOM);
          valid = false;
        } else {
          valid = true;
        }
      } else if (selectedExpensePlanTripProductImage.isEmpty ||
          isShowImage.value == false) {
        Get.snackbar('Warning', "Image is required!",
            snackPosition: SnackPosition.BOTTOM);
        valid = false;
      } else {
        valid = true;
      }
      if (valid) {
        Plantrip_product_expense_line plantrip_product_expense_line =
            Plantrip_product_expense_line(
                // tripProductId: planTripModel.id,
                routeExpenseId: selectedExpenseRouteCategory.routeExpenseId.id,
                actualAmount: double.tryParse(
                    expenseActualTextController.text.toString()),
                description: expenseDescriptionTextController.text.toString(),
                image: selectedExpensePlanTripProductImage);
        planTripServie
            .addPlanTripProductExpense(plantrip_product_expense_line, lineID,
                int.tryParse(employee_id), "edit")
            .then((data) {
          if (data != 0) {
            Get.defaultDialog(
                title: 'Information',
                content: Text('Successfully Updated!'),
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back();
                  Get.back(result: true);
                });
          }
        });
      }
    } else {
      bool valid = false;
      if (wayBillexpenseActualTextController.text.isEmpty) {
        Get.snackbar('Warning', "Fill Required Data!",
            snackPosition: SnackPosition.BOTTOM);
        valid = false;
      } else if (double.tryParse(
              wayBillexpenseActualTextController.text.toString()) >
          this.selectedWayBillExpenseRouteCategory.standardAmount) {
        if (wayBillexpenseDescriptionTextController.text.isEmpty) {
          Get.snackbar('Warning', "Please Fill Description!",
              snackPosition: SnackPosition.BOTTOM);
          valid = false;
        } else {
          valid = true;
        }
      } else if (!isShowImage.value ||
          selectedExpensePlanTripWayBillImage.isEmpty) {
        Get.snackbar('Warning', "Image is required!",
            snackPosition: SnackPosition.BOTTOM);
        valid = false;
      } else {
        valid = true;
      }
      if (valid) {
        Plantrip_waybill_expense_line plantrip_waybill_expense_line =
            Plantrip_waybill_expense_line(
                // tripWaybillId: planTripWayBillModel.id,
                routeExpenseId:
                    selectedWayBillExpenseRouteCategory.routeExpenseId.id,
                actualAmount: double.parse(
                    wayBillexpenseActualTextController.text.toString()),
                description:
                    wayBillexpenseDescriptionTextController.text.toString(),
                image: selectedExpensePlanTripWayBillImage);
        planTripServie
            .addPlanTripWayBillExpense(plantrip_waybill_expense_line,
                lineID.toString(), employee_id, "edit")
            .then((data) {
          if (data != 0) {
            Get.defaultDialog(
                title: 'Information',
                content: Text('Successfully Updated!'),
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back();
                  Get.back(result: true);
                });
          }
        });
      }
    }
    // getPlantripList(current_page.value);
  }

  void onChangeRouteCategoryDropdown(BaseRoute route) async {
    this.selectedBaseRoute = route;
    show_standard_liter.value = true;
    update();
  }

  void onChangeWayBillRouteDropdown(BaseRoute route) async {
    this.selectedBaseRoute = route;
    show_standard_liter.value = true;
    update();
  }

  void onChangeRouteExpenseDropdown(Expense_ids expense) async {
    this.selectedExpenseRouteCategory = expense;
    show_standard_amount.value = true;
    update();
  }

  void onChangeWayBillRouteExpenseDropdown(WayBill_Expense_ids expense) async {
    this.selectedWayBillExpenseRouteCategory = expense;
    show_standard_amount.value = true;
    update();
  }

  endPlanTripProduct(BuildContext context) async {
    showAlertDialog(context, "Warning!", "Are you sure to end trip?");
    // await planTripServie.endPlanTripProductTrip(plantrip_id.toString()).then((data) {
    //   if (data != 0) {
    //     AppUtils.showConfirmDialog('Information', 'Successfully Ended!',(){
    //       Get.back();
    //       Get.back();
    //       Get.back(result: true);
    //     });
    //   }
    // });
  }

  endPlanTripWayBill() async {
    //var data  = Daytrip_fuel_consumption(dayTripId: daytrip_id,consumedLiter: double.parse(actualFuelLiterTextController.text),description:totalAmountController.text);
    await planTripServie
        .endPlanTripWaybillTrip(plantrip_waybill_id.toString())
        .then((data) {
      if (data != 0) {
        AppUtils.showConfirmDialog('Information', 'Successfully Ended!', () {
          Get.back();
          Get.back();
          Get.back(result: true);
        });
      }
    });
  }

  showAlertDialog(BuildContext context, String title, String name) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context, true);
        planTripServie
            .endPlanTripProductTrip(plantrip_id.toString())
            .then((data) {
          if (data != 0) {
            AppUtils.showConfirmDialog('Information', 'Successfully Ended!',
                () {
              Get.back();
              Get.back();
              Get.back(result: true);
            });
          }
        });
      },
    );
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(
        "$title",
        style: TextStyle(color: Colors.red),
      ),
      content: Text("$name"),
      actions: [okButton, cancelButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<int> updateQty(int pID) async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie
        .updateQty(pID, productQtyController.text.toString())
        .then((data) {
      if (data != 0) {
        AppUtils.showConfirmDialog('Information', 'Successfully Updated!', () {
          Get.back();
          Get.back();
          Get.back(result: true);
        });
      }
    });
    return int.parse(productQtyController.text.toString());
  }

  Future<void> getPlantripToApproveList() async {
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
    await planTripServie
        .getPlanTripProductListToApprove(int.tryParse(employee_id))
        .then((data) {
      plantrip_with_product_toapprove_list.value = data;

      update();
      Get.back();
    });
  }

  Future<void> getPlantripWithWayBillToApproveList() async {
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
    await planTripServie
        .getPlanTripWaybillListToApprove(int.tryParse(employee_id))
        .then((data) {
      plantrip_with_waybill_topprove_list.value = data;

      update();
      Get.back();
    });
  }

  void approvePlanTripProduct() async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie.approvePlanTipProduct(plantrip_id).then((data) {
      Get.back();
      if (data != 0) {
        AppUtils.showConfirmDialog('Information', 'Successfully Approved!', () {
          Get.back();
          Get.back(result: true);
        });
      }
    });
  }

  void declinePlanTripProduct() async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie.declinePlanTipProduct(plantrip_id).then((data) {
      Get.back();
      if (data != 0) {
        AppUtils.showConfirmDialog('Information', 'Successfully Declined!', () {
          Get.back();
          Get.back(result: true);
        });
      }
    });
  }

  void approvePlanTripWayBill() async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie.approvePlanTipWyBill(plantrip_waybill_id).then((data) {
      Get.back();
      if (data != 0) {
        AppUtils.showConfirmDialog('Information', 'Successfully Approved!', () {
          Get.back();
          Get.back(result: true);
        });
      }
    });
  }

  void declinePlanTripWayBill() async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie.declinePlanTipWyBill(plantrip_waybill_id).then((data) {
      Get.back();
      if (data != 0) {
        AppUtils.showConfirmDialog('Information', 'Successfully Declined!', () {
          Get.back();
          Get.back(result: true);
        });
      }
    });
  }

  void setCameraImage(File image, String image64) {
    isShowImage.value = true;
    selectedPlantripImage.value = image;
    selectedExpensePlanTripProductImage = image64;
  }

  void setCameraImageFromWayBill(File image, String image64) {
    isShowImage.value = true;
    selectedPlantripWayBillImage.value = image;
    selectedExpensePlanTripWayBillImage = image64;
  }

  deleteAdvanceLine(int lineID) async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie.deleteAdvance(lineID).then((data) {
      getPlantripList(current_page.value);
      Get.back();
      if (data != 0) {
        Get.defaultDialog(
            title: 'Information',
            content: Text('Successfully Deleted!'),
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
            });
      }
    });
  }

  deleteWayBillAdvanceLine(int lineID) async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie.deleteAdvance(lineID).then((data) {
      getPlantripWithWayBillList(current_page.value);
      Get.back();
      if (data != 0) {
        Get.defaultDialog(
            title: 'Information',
            content: Text('Successfully Deleted!'),
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
            });
      }
    });
  }

  deleteExpenseLine(Expense_ids expenseId) async {
    Plantrip_product_expense_line plantrip_product_expense_line =
        Plantrip_product_expense_line(
            // tripProductId: planTripModel.id,
            routeExpenseId: expenseId.routeExpenseId.id,
            actualAmount: 0.0,
            description: expenseId.description,
            image: expenseId.attachement_image);
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie
        .deletePlantripProductExpense(
            plantrip_product_expense_line, expenseId.id)
        .then((data) {
      getPlantripList(current_page.value);
      Get.back();
      if (data != 0) {
        Get.defaultDialog(
            title: 'Information',
            content: Text('Successfully Deleted!'),
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
            });
      }
    });
  }

  deleteWayBillExpenseLine(WayBill_Expense_ids expenseId) async {
    Plantrip_waybill_expense_line plantrip_waybill_expense_line =
        Plantrip_waybill_expense_line(
            // tripWaybillId: planTripWayBillModel.id,
            routeExpenseId: expenseId.routeExpenseId.id,
            actualAmount: 0.0,
            description: expenseId.description,
            image: expenseId.attachement);
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie
        .deleteExpense(plantrip_waybill_expense_line, expenseId.id)
        .then((data) {
      getPlantripWithWayBillList(current_page.value);
      Get.back();
      if (data != 0) {
        Get.defaultDialog(
            title: 'Information',
            content: Text('Successfully Deleted!'),
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
            });
      }
    });
  }

  deletePlantripProuctConsumptionLine(int lineID) async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie.deleteFuelConsumption(lineID).then((data) {
      getPlantripList(current_page.value);
      Get.back();
      if (data != 0) {
        Get.defaultDialog(
            title: 'Information',
            content: Text('Successfully Deleted!'),
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
            });
      }
    });
  }

  deletePlantripWaybillConsumptionLine(int lineID) async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie.deleteFuelConsumption(lineID).then((data) {
      getPlantripWithWayBillList(current_page.value);
      Get.back();
      if (data != 0) {
        Get.defaultDialog(
            title: 'Information',
            content: Text('Successfully Deleted!'),
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
            });
      }
    });
  }

  deleteFuelInLineForPlantripProduct(int lineID) async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie.deleteFuelIn(lineID).then((data) {
      getPlantripList(current_page.value);
      Get.back();
      if (data != 0) {
        Get.defaultDialog(
            title: 'Information',
            content: Text('Successfully Deleted!'),
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
            });
      }
    });
  }

  deleteFuelInLineForPlantripWaybill(int lineID) async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie.deleteFuelIn(lineID).then((data) {
      getPlantripWithWayBillList(current_page.value);
      Get.back();
      if (data != 0) {
        Get.defaultDialog(
            title: 'Information',
            content: Text('Successfully Deleted!'),
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
            });
      }
    });
  }

  void getRouteList(String tripID, String tripType) async {
    var emp_company = box.read('emp_company').toString();
    var branch_id = box.read('branch_id').toString();
    print('getRouteList');
    print(emp_company);
    print(branch_id);
    await masterService.getRouteList(tripID, tripType).then((data) {
      if (data.length != 0) {
        this.selectedBaseRoute = data[0];
      }
      base_route_list.value = data;
    });
  }

  void calculateTotalExpense(List<WayBill_Expense_ids> expenseIds) {
    var standardAmount = 0.0;
    expenseIds.forEach((element) {
      standardAmount += element.standardAmount;
    });
    expenseStandardAmount.value = standardAmount;
    var actualAmount = 0.0;
    expenseIds.forEach((element) {
      actualAmount += element.actualAmount;
    });
    expenseActualAmount.value = actualAmount;
    var overAmount = 0.0;
    expenseIds.forEach((element) {
      overAmount += element.overAmount;
    });
    expenseOverAmount.value = overAmount;
  }

  void calculatePlantripTotalExpense(List<Expense_ids> expenseIds) {
    var standardAmount = 0.0;
    expenseIds.forEach((element) {
      standardAmount += element.standardAmount;
    });
    expenseStandardAmount.value = standardAmount;
    var actualAmount = 0.0;
    expenseIds.forEach((element) {
      actualAmount += element.actualAmount;
    });
    expenseActualAmount.value = actualAmount;
    var overAmount = 0.0;
    expenseIds.forEach((element) {
      overAmount += element.overAmount;
    });
    expenseOverAmount.value = overAmount;
  }

  void saveRouteDate(int pID) async {
    Future.delayed(
        Duration.zero,
        () => Get.dialog(
            Center(
                child: SpinKitWave(
              color: Color.fromRGBO(63, 51, 128, 1),
              size: 30.0,
            )),
            barrierDismissible: false));
    await planTripServie
        .updateRouteDate(pID, fromDateTextController.text.toString(), toDateTextController.text.toString())
        .then((data) {
      if (data != 0) {
        AppUtils.showConfirmDialog('Information', 'Successfully Updated!', () {
          Get.back();
          Get.back();
          Get.back(result: true);
        });
      }
    });
  }

  void calculateinterval(DateTime selectedFromDate, DateTime selectedToDate) {
    if (fromDateTextController.text.isNotEmpty &&
        toDateTextController.text.isNotEmpty) {
      if (selectedToDate.isAfter(selectedFromDate) || selectedToDate.isAtSameMomentAs(selectedFromDate)) {
        
      }
      else{
        AppUtils.showConfirmDialog('Warning', 'End date must be greater than start date.',(){
          Get.back();
          toDateTextController.text = '';
        });
      }
    }
  }

   @override
  void onClose() {
    super.onClose();
  }

  
}
