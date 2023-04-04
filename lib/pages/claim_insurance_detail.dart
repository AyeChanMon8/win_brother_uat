// @dart=2.9

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:winbrother_hr_app/models/claiminsurancemodel.dart';
import 'package:winbrother_hr_app/my_class/my_app_bar.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/pages/pdf_view.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';

import '../localization.dart';
class ClaimInsuranceDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Claiminsurancemodel insurance = Get.arguments;
    final labels = AppLocalizations.of(context);
    return Scaffold(
      appBar: appbar(context, 'Claim Insurance Detail', ''),
      body:SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                AutoSizeText(labels?.insuranceType,style: detailsStyle()),
                AutoSizeText(' : ${insurance.insuranceTypeId.policyType}',style: maintitleStyle()),
              ],),
              SizedBox(height: 10,),
              Row(children: [
                AutoSizeText('Insurance Reference',style: detailsStyle()),
                AutoSizeText(' : ${insurance.insurance_ids[0].name}',style: maintitleStyle()),
              ],),
              SizedBox(height: 10,),
              Row(children: [
                AutoSizeText(labels?.employeeName,style: detailsStyle()),
                AutoSizeText(' : ${insurance.employeeId.name}',style: maintitleStyle()),
              ],),
              SizedBox(height: 10,),
              Row(children: [
                AutoSizeText('Date',style: detailsStyle()),
                AutoSizeText(' : ${AppUtils.changeDateFormat(insurance.date)}',style: maintitleStyle()),
              ],),
              SizedBox(height: 10,),
              Row(children: [
                AutoSizeText('Field Description',style: detailsStyle()),
                AutoSizeText(' : ${AppUtils.removeNullString(insurance.description)}',style: maintitleStyle()),
              ],),
              SizedBox(height: 10,),
              Row(children: [
                AutoSizeText('Coverage Amount',style: detailsStyle()),
                AutoSizeText(' : ${NumberFormat('#,###').format(double.tryParse(insurance.coverageAmount.toString()))}',style: maintitleStyle()),
              ],),
              SizedBox(height: 10,),
              Row(children: [
                AutoSizeText('Claim Amount',style: detailsStyle()),
                AutoSizeText(' : ${NumberFormat('#,###').format(double.tryParse(insurance.claimAmount.toString()))}',style: maintitleStyle()),
              ],),
              SizedBox(height: 10,),
              Row(children: [
                AutoSizeText('Balance Amount',style: detailsStyle()),
                AutoSizeText(' : ${NumberFormat('#,###').format(double.tryParse(insurance.balance.toString()))}',style: maintitleStyle()),
              ],),
              SizedBox(height: 10,),
              Row(children: [
                Text(
                  '${labels?.attachment} : ',
                  style: detailsStyle(),
                ),
                InkWell(
                  onTap: () async{
                    File file = await AppUtils.createPDF(insurance.attachmentId, "attachmentId.png","application/png");
                    if (AppUtils.isImage(file.path)) {
                      Get.dialog(Stack(
                        children: [
                          Center(child: Image.file(file)),
                          Positioned(right : 0,child: FlatButton(onPressed: (){Get.back();}, child: Text('Close',style:TextStyle(color: Colors.white,fontSize: 20) ,)))
                        ],
                      ));
                    } else {
                      await OpenFile.open(file.path);
                      //Get.to(PdfView(file.path,"attachment_file.png"));
                    }
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
                      child: Icon(Icons.attachment),
                    ),
                  ),
                ),
              ],),




              /*ExpansionTile(
                title: Text(
                  labels?.attachment,
                  style: maintitleStyle(),
                ),
                children:[
                  ListView.builder(
                    shrinkWrap: true,
                       itemCount: insurance.attachmentId.length,
                      itemBuilder: (context,index){
                    return InkWell(
                      onTap: () async{
                        File file = await AppUtils.createPDF(insurance.attachmentId[index].datas, "${insurance.attachmentId[index].name}");
                        if (AppUtils.isImage(file.path)) {
                          Get.dialog(Stack(
                            children: [
                              Center(child: Image.file(file)),
                              Positioned(right : 0,child: FlatButton(onPressed: (){Get.back();}, child: Text('Close',style:TextStyle(color: Colors.white,fontSize: 20) ,)))
                            ],
                          ));
                        } else {
                          Get.to(PdfView(file.path,insurance.attachmentId[index].name));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: AutoSizeText(insurance.attachmentId[index].name),
                      ),
                    );
                  })
                ]
              ),*/
            ],
          ),
        ),
      ) ,
    );
  }
}
