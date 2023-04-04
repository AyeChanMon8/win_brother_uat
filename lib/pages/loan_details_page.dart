// @dart=2.9

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:winbrother_hr_app/controllers/loan_page_controller.dart';
import 'package:winbrother_hr_app/localization.dart';
import 'package:winbrother_hr_app/my_class/my_app_bar.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/my_class/theme.dart';
import 'package:winbrother_hr_app/pages/pdf_view.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';

import 'leave_detail.dart';

class LoanDetailsPage extends StatelessWidget {
  int dindex;
  final box = GetStorage();
  String image;
  final LoanController controller = Get.put(LoanController());
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    dindex = Get.arguments;
    image = box.read('emp_image');
    return Scaffold(
      appBar: appbar(context, labels.loanDetails,image),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: scrollController,
        thickness: 5,
        radius: Radius.circular(10),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            margin: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    controller.loanList[dindex].name,
                    style: subtitleStyle(),
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          labels?.status,
                          // ("employee_name"),
                          style: datalistStyle(),
                        ),
                      ),
                      Obx(
                            () => Container(
                          child: Text(
                            controller.loanList[dindex].state,
                            style: subtitleStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          labels?.employeeName,
                          // ("employee_name"),
                          style: datalistStyle(),
                        ),
                      ),
                      Obx(
                        () => Container(
                          child: Text(
                            controller.loanList[dindex].employee_id.name,
                            style: subtitleStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          labels?.position,
                          // ("position"),
                          style: datalistStyle(),
                        ),
                      ),
                      Obx(
                        () => Container(
                          child: controller.loanList[dindex].job_position.name !=
                                  null
                              ? Text(
                                  controller.loanList[dindex].job_position.name,
                                  style: subtitleStyle(),
                                )
                              : Text('-'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          labels?.date,
                          // ("date"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          ("payment_start_date"),
                          style: datalistStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            AppUtils.changeDateFormat(controller.loanList[dindex].date),
                            style: subtitleStyle(),
                          ),
                        ),
                        Container(
                          child: Text(
                            AppUtils.changeDateFormat(controller.loanList[dindex].payment_date),
                            style: subtitleStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          labels?.loanAmount,
                          // ("loan_amount"),
                          style: datalistStyle(),
                        ),
                      ),
                      Container(
                        child: Text(
                          labels?.noOfInstallments,
                          // ("no_of_installments"),
                          style: datalistStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            NumberFormat('#,###').format(double.tryParse(controller.loanList[dindex].loan_amount.toString())),
                            style: subtitleStyle(),
                          ),
                        ),
                        Container(
                          child: Text(
                            controller.loanList[dindex].installment.toString(),
                            style: subtitleStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    'Attachments',
                    // ("loan_amount"),
                    style: datalistStyle(),
                  ),
                ),
                // Divider(
                //   thickness: 1,
                // ),
                SizedBox(
                  height: 10,
                ),
                controller.loanList.value[dindex].attachment!=null ?
                InkWell(
                  onTap: () async{
                    controller.loanList.value[dindex].attachment_filename.contains('pdf')?
                    _createFileFromString(controller.loanList.value[dindex].attachment.toString()).then((path) async{
                      await OpenFile.open(path);
                    //  Get.to(PdfView(path,'Name.pdf'));
                    }) :
                    await showDialog(
                        context: context,
                        builder: (_) {
                          return ImageDialog(
                            bytes: base64Decode(controller.loanList.value[dindex].attachment),
                          );
                        }
                    );
                  },
                  child: Card(
                    elevation: 10,
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Row(
                          children: [
                            Icon(Icons.attach_file),
                            Expanded(
                              child: AutoSizeText(
                                controller.loanList.value[dindex].attachment_filename!=null?controller.loanList.value[dindex].attachment_filename:'',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ):new Container(),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                Container(
                  child: Text(labels?.installments, style: datalistStyle()),
                ),
                SizedBox(
                  height: 20,
                ),
                installmentTitleWidget(context),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                installmentWidget(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget installmentTitleWidget(BuildContext context) {
    final labels = AppLocalizations.of(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              labels?.paymentDate,
              // ("payment_date"),
              style: subtitleStyle(),
            ),
          ),
          Container(
            child: Text(
              labels?.status,
              // ("status"),
              style: subtitleStyle(),
            ),
          ),
          Container(
            child: Text(
              labels?.amount,
              // ("amount"),
              style: subtitleStyle(),
            ),
          )
        ],
      ),
    );
  }

  Widget installmentWidget(BuildContext context) {
    final labels = AppLocalizations.of(context);
    return Obx(() => Container(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.loanList[dindex].loan_lines.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                              AppUtils.changeDateFormat(controller.loanList[dindex].loan_lines[index].date)
                            ),
                        ),
                        Container(
                          child: Text(controller
                              .loanList[dindex].loan_lines[index].state),
                        ),
                        Container(
                          child: Text(NumberFormat('#,###').format(double.tryParse(controller
                  .loanList[dindex].loan_lines[index].amount
                  .toString()))
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
          ),
        ));
  }
  Future<String> _createFileFromString(String encodedStr) async {
    //final encodedStr = "put base64 encoded string here";
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    await file.writeAsBytes(bytes);
    return file.path.toString();
  }
}
