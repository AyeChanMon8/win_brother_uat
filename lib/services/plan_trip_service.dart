// @dart=2.9

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:winbrother_hr_app/constants/globals.dart';
import 'package:winbrother_hr_app/models/daytrip_advance_expense_category.dart';
import 'package:winbrother_hr_app/models/daytrip_expense.dart';
import 'package:winbrother_hr_app/models/palntrip_with_product_fuelin_line.dart';
import 'package:winbrother_hr_app/models/plan_trip_product.dart';
import 'package:winbrother_hr_app/models/plantrip_fuel_consumption.dart';
import 'package:winbrother_hr_app/models/plantrip_product_adavance_line.dart';
import 'package:winbrother_hr_app/models/plantrip_product_expense_line.dart';
import 'package:winbrother_hr_app/models/plantrip_waybill.dart';
import 'package:winbrother_hr_app/models/plantrip_waybill_expense_line.dart';
import 'package:winbrother_hr_app/models/plantrip_waybill_fuelin_line.dart';
import 'package:winbrother_hr_app/models/plantrip_waybilll_advance_line.dart';
import 'package:winbrother_hr_app/models/stock_location.dart';
import 'package:winbrother_hr_app/services/odoo_service.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';
import 'package:get/get.dart' hide Response;
class PlanTripServie extends OdooService {
  Dio dioClient;
  @override
  Future<PlanTripServie> init() async {
    dioClient = await client();
    return this;
  }

  Future<List<Plan_trip_product>> getPlanTripWithProductList(
      int empID, String offset, String state) async {
    List<Plan_trip_product> dayTripList = [];
    List<dynamic> planTripIdList =
        await getPlanTripWithProductIdList(empID, state);
    if (planTripIdList != null) {
      String url = Globals.baseURL +
          "/plan.trip.product?filters=[('id','in',${planTripIdList.toString()})]&limit=" +
          Globals.pag_limit.toString() +
          "&offset=" +
          offset +
          "&order=create_date desc";

      Response response = await dioClient.get(url);
      if (response.statusCode == 200) {
        var list = response.data['results'];
        var count = response.data['count'];
        if (count != 0) {
          list.forEach((v) {
            dayTripList.add(Plan_trip_product.fromJson(v));
          });
        }
      }
    }

    return dayTripList;
  }

  getPlanTripWithProductIdList(int empID, String state) async {
    String url = Globals.baseURL +
        "/hr.employee/" +
        empID.toString() +
        "/get_plan_trip_product_lists";
    Response response = await dioClient.put(url,
        data: jsonEncode({'employee_id': empID, 'state': state}));
    List<dynamic> planTripIds = response.data;
    return planTripIds;
  }

  getPlanTripWithWayBillIdsList(int empID, String state) async {
    String url = Globals.baseURL +
        "/hr.employee/" +
        empID.toString() +
        "/get_plan_trip_waybill_lists";
    Response response = await dioClient.put(url,
        data: jsonEncode({'employee_id': empID, 'state': state}));
    List<dynamic> planTripIds = response.data;
    print("URL### $url");
    print("EmployeeID : ${empID.toString()}");
    print("Plan Trip : ${planTripIds.length}");
    return planTripIds;
  }

  Future<List<Plantrip_waybill>> getPlanTripWithWayBillList(
      int empID, String offset, String state) async {
    List<Plantrip_waybill> dayTripList = [];
    List<dynamic> planTripIdList =
        await getPlanTripWithWayBillIdsList(empID, state);
    if (planTripIdList != null) {
      String url = Globals.baseURL +
          "/plan.trip.waybill?filters=[('id','in',${planTripIdList.toString()})]&limit=" +
          Globals.pag_limit.toString() +
          "&offset=" +
          offset +
          "&order=state,create_date desc";

      print("URL### $url");

      Response response = await dioClient.get(url);
      print("response Trip : ${response.statusCode}");
      // print(
      //     "List : ${response.data['results'].length} Count: ${response.data['count'].length}");
      if (response.statusCode == 200) {
        var list = response.data['results'];
        var count = response.data['count'];
        if (count != 0) {
          list.forEach((v) {
            dayTripList.add(Plantrip_waybill.fromJson(v));
          });
        }
      }
    }

    return dayTripList;
  }

  Future<List<Stock_location>> getStockLocationList() async {
    String url = Globals.baseURL + "/stock.location";
    Response response = await dioClient.get(url);
    List<Stock_location> expense_list = new List<Stock_location>();
    if (response.statusCode == 200) {
      var list = response.data['results'];
      list.forEach((v) {
        expense_list.add(Stock_location.fromMap(v));
      });
    }
    return expense_list;
  }

  Future<List<Daytrip_expense>> getDayTripProductListForProductTab(
      String companyID) async {
    String url = Globals.baseURL +
        "/product.product?filters=[('product_tmpl_id.categ_id.delivery','=',True),'|',('product_tmpl_id.company_id','='," +
        companyID.toString() +
        "),('product_tmpl_id.company_id','=','false')]";
    Response response = await dioClient.get(url);
    List<Daytrip_expense> expense_list = new List<Daytrip_expense>();
    if (response.statusCode == 200) {
      var list = response.data['results'];
      list.forEach((v) {
        expense_list.add(Daytrip_expense.fromMap(v));
      });
    }
    return expense_list;
  }

  Future<List<Daytrip_expense>> getDayTripProductListForFuelTab(
      String companyID) async {
    String url = Globals.baseURL +
        "/product.product?filters=[('product_tmpl_id.categ_id.day_trip','=',True),'|',('product_tmpl_id.company_id','='," +
        companyID.toString() +
        "),('product_tmpl_id.company_id','=','false')]";
    Response response = await dioClient.get(url);
    List<Daytrip_expense> expense_list = new List<Daytrip_expense>();
    if (response.statusCode == 200) {
      var list = response.data['results'];
      list.forEach((v) {
        expense_list.add(Daytrip_expense.fromMap(v));
      });
    }
    return expense_list;
  }

  Future<List<Daytrip_advance_expense_category>>
      getDayTripAdvanceExpenseCategory(int companyID) async {
    var created = 0;
    String url = Globals.baseURL +
        "/product.category?filters=[('travel_expense','=',True),'|', ('company_id', '=', " +
        companyID.toString() +
        "), ('company_id', '=', False)]";

    Response response = await dioClient.get(url);
    List<Daytrip_advance_expense_category> expense_category_list =
        new List<Daytrip_advance_expense_category>();
    if (response.statusCode == 200) {
      var list = response.data['results'];
      var count = response.data['count'];
      if (count != 0) {
        list.forEach((v) {
          expense_category_list
              .add(Daytrip_advance_expense_category.fromJson(v));
        });
      }
    }

    return expense_category_list;
  }

  Future<int> addPlanTripProductFuelIn(
      Palntrip_with_product_fuelin_line fuel) async {
    var created = 0;
    String url = Globals.baseURL + "/trip.fuel.in";
    var fuel_data = fuel.toJson();
    print('fuelData');
    print(fuel_data);
    Response response = await dioClient.post(url, data: fuel_data);
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = response.data['id'];
      }
    }

    return created;
  }

  Future<int> addPlanTripWayBillFuelIn(
      Plantrip_waybill_fuelin_line fuel) async {
    var created = 0;
    String url = Globals.baseURL + "/trip.fuel.in";
    var fuel_data = fuel.toJson();

    Response response = await dioClient.post(url, data: fuel_data);
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = response.data['id'];
      }
    }

    return created;
  }

  Future<int> addPlanTripProductExpense(Plantrip_product_expense_line expense,
      int lineID, int employee_id, String status) async {
    var created = 0;
    String url = Globals.baseURL + "/trip.expense/" + lineID.toString();
    var expense_data = expense.toJson();
    Response response =
        await dioClient.put(url, data: jsonEncode(expense_data));
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
        saveEmployee(lineID, employee_id, status);
      }
    }
    return created;
  }

  Future<int> addPlanTripWayBillExpense(Plantrip_waybill_expense_line expense,
      String lineID, String empID, String status) async {
    var created = 0;
    String url = Globals.baseURL + "/trip.expense/" + lineID.toString();
    var expense_data = expense.toJson();

    Response response =
        await dioClient.put(url, data: jsonEncode(expense_data));
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
        saveEmployee(int.tryParse(lineID), int.tryParse(empID), status);
      }
    }
    return created;
  }

  Future<int> addPlanTripProductAdvance(
      Plantrip_product_adavance_line advance_line) async {
    var created = 0;
    String url = Globals.baseURL + "/travel.request.allowance";
    var advance_data = advance_line.toJson();
    Response response = await dioClient.post(url, data: advance_data);
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = response.data['id'];
      }
    }

    return created;
  }

  Future<int> addPlanTripWaybillAdvance(
      Plantrip_waybilll_advance_line advance_line) async {
    var created = 0;
    String url = Globals.baseURL + "/travel.request.allowance";
    var advance_data = advance_line.toJson();
    Response response = await dioClient.post(url, data: advance_data);
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = response.data['id'];
      }
    }

    return created;
  }

  Future<int> endPlanTripProductTrip(String tripID) async {
    var created = 0;
    String url =
        Globals.baseURL + "/plan.trip.product/" + tripID + "/action_end";
    Response response = await dioClient.put(url);
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
      }
    }
    return created;
  }

  Future<int> endPlanTripWaybillTrip(String tripID) async {
    var created = 0;
    String url =
        Globals.baseURL + "/plan.trip.waybill/" + tripID + "/action_end";
    Response response = await dioClient.put(url);
    if (response.statusCode == 200) {
      created = 1;
    }else{
      Get.back();
      AppUtils.showErrorDialog(response.toString(),response.statusCode.toString());
    }

    return created;
  }

  Future<int> addPlanTripWaybillFuelConsumption(
      Plantrip_fuel_consumption data) async {
    var created = 0;
    String url =
        Globals.baseURL + "/hr.employee/1/add_consumption_plan_trip_waybill";
    var fuel_data = data.toJson();
    Response response = await dioClient.put(url, data: fuel_data);
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
      }
    }else{
      Get.back();
      AppUtils.showErrorDialog(response.toString(),response.statusCode.toString());
    }

    return created;
  }

  Future<int> addPlanTripFuelConsumption(Plantrip_fuel_consumption data) async {
    var created = 0;
    String url =
        Globals.baseURL + "/hr.employee/1/add_consumption_plan_trip_product";
    var fuel_data = data.toJson();
    Response response = await dioClient.put(url, data: fuel_data);
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
      }
    }else{
    Get.back();
    AppUtils.showErrorDialog(response.toString(),response.statusCode.toString());
    }
    return created;
  }

  Future<int> updateQty(int pID, String qty) async {
    var created = 0;
    String url = Globals.baseURL + "/trip.product.line/" + pID.toString();
    Response response =
        await dioClient.put(url, data: jsonEncode({'quantity': qty}));
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
      }
    }
    return created;
  }

  Future<List<Plan_trip_product>> getPlanTripProductListToApprove(
      int empID) async {
    List<Plan_trip_product> planTripList = [];
    String url = Globals.baseURL +
        "/plan.trip.product?filters=[('driver_id.branch_id.manager_id','='," +
        empID.toString() +
        "),('state','=','submit')]&order=create_date desc";
    Response response = await dioClient.get(url);
    if (response.statusCode == 200) {
      var list = response.data['results'];
      var count = response.data['count'];
      if (count != 0) {
        list.forEach((v) {
          planTripList.add(Plan_trip_product.fromJson(v));
        });
      }
    }

    return planTripList;
  }

  Future<List<Plantrip_waybill>> getPlanTripWaybillListToApprove(
      int empID) async {
    List<Plantrip_waybill> planTripWaybillList = [];
    String url = Globals.baseURL +
        "/plan.trip.waybill?filters=[('driver_id.branch_id.manager_id','='," +
        empID.toString() +
        "),('state','=','submit')]&order=create_date desc";
    Response response = await dioClient.get(url);
    if (response.statusCode == 200) {
      var list = response.data['results'];
      var count = response.data['count'];
      if (count != 0) {
        list.forEach((v) {
          planTripWaybillList.add(Plantrip_waybill.fromJson(v));
        });
      }
    }

    return planTripWaybillList;
  }

  Future<int> approvePlanTipProduct(int id) async {
    var created = 0;
    String url = Globals.baseURL +
        "/plan.trip.product/" +
        id.toString() +
        "/action_approve";
    Response response = await dioClient.put(url);
    if (response.statusCode == 200) {
      created = 1;
    }
    return created;
  }

  Future<int> declinePlanTipProduct(int id) async {
    var created = 0;
    String url = Globals.baseURL +
        "/plan.trip.product/" +
        id.toString() +
        "/action_decline";
    Response response = await dioClient.put(url);
    if (response.statusCode == 200) {
      created = 1;
    }
    return created;
  }

  Future<int> approvePlanTipWyBill(int id) async {
    var created = 0;
    String url = Globals.baseURL +
        "/plan.trip.waybill/" +
        id.toString() +
        "/action_approve";
    Response response = await dioClient.put(url);
    if (response.statusCode == 200) {
      created = 1;
    }
    return created;
  }

  Future<int> declinePlanTipWyBill(int id) async {
    var created = 0;
    String url = Globals.baseURL +
        "/plan.trip.waybill/" +
        id.toString() +
        "/action_decline";
    Response response = await dioClient.put(url);
    if (response.statusCode == 200) {
      created = 1;
    }
    return created;
  }

  Future<int> deleteAdvance(int advance_line_id) async {
    var created = 0;
    String url = Globals.baseURL +
        "/travel.request.allowance/" +
        advance_line_id.toString();
    Response response = await dioClient.delete(url);
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
      }
    }

    return created;
  }

  Future<int> deleteExpense(
      Plantrip_waybill_expense_line expense_data, int advance_line_id) async {
    var created = 0;
    String url =
        Globals.baseURL + "/trip.expense/" + advance_line_id.toString();
    //Response response = await dioClient.delete(url);
    Response response =
        await dioClient.put(url, data: jsonEncode(expense_data));
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
      }
    }
    return created;
  }

  Future<int> deletePlantripProductExpense(
      Plantrip_product_expense_line expense_data, int advance_line_id) async {
    var created = 0;
    String url =
        Globals.baseURL + "/trip.expense/" + advance_line_id.toString();
    //Response response = await dioClient.delete(url);
    Response response =
        await dioClient.put(url, data: jsonEncode(expense_data));
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
      }
    }
    return created;
  }

  Future<int> deleteFuelConsumption(int advance_line_id) async {
    var created = 0;
    String url = Globals.baseURL +
        "/trip.fuel.consumption/" +
        advance_line_id.toString();
    Response response = await dioClient.delete(url);
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
      }
    }
    return created;
  }

  Future<int> deleteFuelIn(int line_id) async {
    var created = 0;
    String url = Globals.baseURL + "/trip.fuel.in/" + line_id.toString();
    Response response = await dioClient.delete(url);
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
      }
    }
    return created;
  }

  void saveEmployee(int lineID, int empID, String status) async {
    var url = Globals.baseURL + "/hr.employee/2/get_plan_trip_expense_emp_id";
    Response response = await dioClient.put(url,
        data: jsonEncode(
            {"line_id": lineID, "employee_id": empID, "status": status}));
  }

  Future<String> fetchExpenseStatusDayTipPlantrip(
      int tripId, String state) async {
    var data = '';
    String url = Globals.baseURL + "/hr.employee/2/get_trip_expense_status";
    Response response = await dioClient.put(url,
        data: jsonEncode({'trip_id': tripId, 'status': state}));
    if (response.statusCode == 200) {
      if (response.data != null) {
        print("ResponseData##");
        print(response.data);
        data = response.data;
      } else {
        data = '';
      }
    }
    return data;
  }

  Future<int> updateRouteDate(int pID, String sDate, String eDate) async {
    var created = 0;
    String url = Globals.baseURL + "/trip.route.line/" + pID.toString();
    Response response =
        await dioClient.put(url, data: jsonEncode({'start_actual_date': sDate, 'end_actual_date': eDate}));
    if (response.statusCode == 200) {
      if (response.data != null) {
        created = 1;
      }
    }else{
      Get.back();
      AppUtils.showErrorDialog(response.toString(),response.statusCode.toString());
    }
    return created;
  }


    Future<int> clickWayBillRouteLineTrip(bool first_route, int tripID, int route_id, int next_route_id) async {
    String process_datetime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    var created = 0;
    String url =
        Globals.baseURL + "/plan.trip.waybill/1/update_route_status";
    Response response = await dioClient.put(url,
    data: jsonEncode({'first_route':first_route, 'trip_id': tripID, 'route_id': route_id, 'next_route_id': next_route_id,'process_datetime': process_datetime}));
    if (response.statusCode == 200) {
      created = 1;
    }else{
      Get.back();
      AppUtils.showErrorDialog(response.toString(),response.statusCode.toString());
    }

    return created;
  }

  Future<int> clickProductRouteLineTrip(bool first_route, int tripID, int route_id, int next_route_id) async {
    String process_datetime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    var created = 0;
    String url =
        Globals.baseURL + "/plan.trip.product/1/update_route_status";
    Response response = await dioClient.put(url,
    data: jsonEncode({'first_route':first_route, 'trip_id': tripID, 'route_id': route_id, 'next_route_id': next_route_id,'process_datetime': process_datetime}));
    if (response.statusCode == 200) {
      created = 1;
    }else{
      Get.back();
      AppUtils.showErrorDialog(response.toString(),response.statusCode.toString());
    }

    return created;
  }

}
