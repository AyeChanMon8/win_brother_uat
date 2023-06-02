part of './app_pages.dart';

abstract class Routes {
  static const INITIAL = '/';
  static const LOGIN = '/login';
  static const FORGET_PASSWORD = '/forgetpassword';
  static const BOTTOM_NAVIGATION = '/bottomnavigation';
  static const PROFILE_PAGE = '/profilepage';

  static const REQUEST_LIST = '/requestlist';
  static const ATTENDANCE = '/attendance';
  static const ATTENDANCE_REPORT = '/attendancereport';
  static const APPROVAL = '/approval';
  static const ANNOUNCEMENTS_DETAILS = '/announcementsdetails';
  static const APPROVAL_ANNOUNCEMENTS_DETAILS = '/approvalannouncementsdetails';
  static const ANNOUNCEMENTS_APPROVAL_TAB_PAGE = '/announcement_approval_tab';
  static const NOTIFICATION_DETAILS = '/notificationdetails';
  static const LEAVE_TRIP_REPORT = '/leavetripreport';
  static const EMPLOYEE_CHANGE = '/employee_changes';
  static const LEAVE_TRIP_TAB_BAR = '/leavetriptapbar';
  static const ORGANIZATION_CHART = '/organizationchart';
  static const PMS_PAGE = '/pmspage';
  static const PAY_SLIP_PAGE = '/payslippage';
  static const PAY_SLIP_DETAIL_PAGE = '/payslipdetailpage';
  static const LOAN_PAGE = '/loanpage';
  static const INSURANCE = '/insurance';
  static const CREATE_INSURANCE = '/create_insurance';
  static const CLAIM_INSURANCE = '/claim_insurance';
  static const CREATE_EMPLOYEE_CHANGE = '/create_employee_change';
  static const OVER_TIME_PAGE = '/overtimepage';
  static const OVER_TIME_LIST_PAGE = '/overtimelistpage';
  static const OVER_TIME_RESPONSE_DETAILS_PAGE = '/overtimresponsedetailpage';
  static const EXPENSE_REPORT = '/expensereport';
  static const CREATE_EXPENSE = '/createexpense';
  static const FLEET_PAGE = '/fleetpage';
  static const CREATE_PLAN_TRIP = '/createplantrip';
  static const REWARD_PAGE = '/rewardpage';
  static const REWARD_APPROVE_TAB_PAGE = '/rewardApproveTabPage';
  static const REMINDER_APPROVE_TAB_PAGE = '/reminderApproveTabPage';
  static const WARNING_PAGE = '/warningpage';
  static const EMPLOYEE_DOCEMENT_PAGE = '/emp_doc_page';
  static const EMPLOYEE_DOCEMENT_DETAILS_PAGE = '/emp_doc_details';
  static const WARNING_APPROVE_TAB_PAGE = '/warningApproveTabPage';
  static const BUSINESS_TRAVEL_CREATE = '/businesstravelcreate';
  static const CHANGE_PASSWORD = '/changepassword';
  static const EXPENSE_PAGE = '/expense';
  static const APPROVAL_REQUEST = '/approvalrequest';
  static const ANNOUNCEMENTS_LIST = '/announcementlist';
  static const NOTIFICATION_LIST = '/notificationlist';
  static const LEAVE_REQUEST = '/leaverequest';
  static const TRAVEL_REQUEST = '/travelrequest';
  static const PMA_PAGE = '/pmspage';
  static const PMS_DETAILS_PAGE = '/pmsdetailspage';
  static const PMS_Manager_DETAILS_PAGE = '/pmsmanagerdetailspage';
  static const PMS_Manager_DONE_DETAILS_PAGE = '/pmsmanagerdonedetailspage';
  static const OUT_OF_POCKET_PAGE = '/outofpocketpage';
  static const APPROVAL_LIST = '/approvallist';
  static const REWARD_DETAILS_PAGE = '/rewarddetailspage';
  static const WARNING_DETAILS_PAGE = '/warningdetailspage';
  static const TRAVEL_REQUEST_LIST = '/traverrequestlist';
  static const TRAVEL_DETAILS = '/traveldetails';
  static const TRAVEL_REQUEST_UPDATE = '/travelrequestupdate';
  static const LEAVE_DETAILS = '/leavedetails';
  static const LEAVE_REQUEST_UPDATE = '/leaverequestupdate';
  static const LANGUAGE_PAGE = '/language';
  static const OVERTIME_DETAILS = '/overtimedetails';
  static const OVERTIME_COMPLETE_DETAILS = '/overtimecompletedetails';
  static const OVERTIME_DECLINE = '/overtimedeclinepage';
  static const LOAN_DETAILS = '/loandetails';
  static const HOME_PAGE = '/homepage';
  static const HR_PAGE = '/hrpage';
  static const ADMIN_PAGE = '/adminpage';
  static const MESSAGE_PAGE = '/messagepage';
  static const MORE_PAGE = '/morepage';
  static const MAINTENANCE_REQUEST = '/maintenancerequest';
  static const CREATE_DAY_TRIP = '/daytrip';
  static const DOCUMENTS = '/documents';
  static const CALENDAR = '/calendar';
  static const DETAILS_LIST = '/detilslist';
  static const APPROVAL_ATTENDANCE_LIST = '/approval_attendance_list';
  static const APPROVAL_ATTENDANCE_DETAILS = '/approval_attendance_details';
  static const APPROVAL_TRAVEL_LIST = '/approval_travel_list';
  static const APPROVED_TRAVEL_LIST = '/approved_travel_list';
  static const APPROVAL_ROUTE_LIST = '/approval_route_list';
  static const APPROVED_ROUTE_LIST = '/approved_route_list';
  static const APPROVAL_ROUTE_DETAILS = '/approval_route_details';
  static const APPROVED_ROUTE_DETAILS = '/approved_route_details';
  static const APPROVAL_LOAN_LIST = '/approval_loan_list';
  static const APPROVAL_LOAN_DETAILS = '/approval_loan_details';
  static const APPROVED_LOAN_DETAILS = '/approved_loan_details';
  static const APPROVAL_RESIGNATION_LIST = '/approval_resignation_list';
  static const APPROVAL_RESIGNATION_DETAILS = '/approval_resignation_details';
  static const APPROVED_RESIGNATION_DETAILS = '/approved_resignation_details';
  static const APPROVAL_EMPLOYEE_CHANGES_LIST = '/approval_employee_changes_list';
  static const FIRST_APPROVAL_EMPLOYEE_CHANGES_DETAILS = '/first_approval_employee_changes_details';
  static const APPROVAL_EMPLOYEE_CHANGES_DETAILS = '/approval_employee_changes_details';
  static const APPROVED_EMPLOYEE_CHANGES_DETAILS = '/approved_employee_changes_details';
  static const EMPLOYEE_CHANGES_DETAILS = '/employee_changes_details';
  static const DOCUMENT_LIST = '/document_list';
  static const APPROVAL_SUSPENSION_LIST = '/approval_suspension_list';

  static const APPROVAL_TRAVEL_DETAILS = '/approval_travel_details';
  static const APPROVED_TRAVEL_DETAILS = '/approved_travel_details';
  static const APPROVAL_OVERTIME_LIST = '/approval_overtime_list';
  static const APPROVAL_OVERTIME_DETAILS = '/approval_overtime_details';
  static const APPROVED_LEAVE_DETAIL = '/approved_leave_details';
  static const ATTENDANCE_APPROVAL_LIST = '/attendance_approval_list';
  static const OUT_OF_POCKET_DETAILS = '/out_of_pocket_details';
  static const OUT_OF_POCKET_UPDATE = '/out_of_pocket_update';
  static const EXPENSE_TRAVEL_DETAILS = "/expense_travel_details";
  static const EXPENSE_TRAVEL_UPDATE = "/expense_travel_update";
  static const OUT_OF_POCKET_APPROVAL = '/out_of_pocket_approval';
  static const TRAVEL_EXPENSE_APPROVAL = '/travel_expense_approval';
  static const TRIP_EXPENSE_APPROVAL = '/trip_expense_approval';
  static const APPROVAL_OUTOFPOCKET_LIST = '/approval_outofpocket_list';
  static const APPROVED_OUTOFPOCKET_APPROVED_DETAILS = '/approved_outofpocket_details';
  static const APPROVAL_TRIPEXPENSE_LIST = '/approval_tripexpense_list';
  static const APPROVED_TRIPEXXPENSE_APPROVED_DETAILS = '/approved_tripexpense_details';
  static const APPROVAL_TRAVEL_EXPENSE_LIST = '/approval_travelexpense_list';
  static const APPROVED_TRAVEL_EXPENSE_DETAILS = '/approved_travel_expense_details';
  static const CONFIGURATION_PAGE = '/configuration';
  static const NOTIFICATION_PAGE = '/notification';
  static const PLAN_TRIP_PAGE = '/plan_trip';
  static const PLAN_TRIP_WAYBILL_PAGE = '/plan_waybill_trip';
  static const DAY_TRIP_PAGE = '/day_trip';
  static const FLEET_LIST_PAGE = '/fleet_list';
  static const FLEET_INSURANCE_DETAIL = '/fleet_insurance_detail';
  static const MAINTENANCE_LIST = '/maintenance_list';
  static const PLANTRIP_DETAILS = '/plantrip_details';
  static const PLANTRIP_WAYBILL_DETAILS = '/plantrip_waybill_details';
  static const INSURANCEDETAIL = '/insurance_detail';
  static const CLAIMINSURANCEDETAIL = '/claiminsurance_detail';
  static const MAINTENANCEDETAILPAGE = '/maintenance_detail_page';
  static const DAY_TRIP_TABAR = '/daytrip_tab';
  static const CREATEROUTEDATEWAYBILL = '/create_route_date_waybill';
  static const OTPCONFIRM ='/otp_confirm';
  static const PURCHASE_ORDER_LIST = '/purchase_order_list';
  static const PURCHASE_ORDER_DETAIL = '/purchase_order_detail';
  static const APPROVAL_SUSPENSION_DETAILS = '/approval_suspension_details';
  static const APPROVED_SUSPENSION_DETAILS = '/approved_suspension_details';
}
