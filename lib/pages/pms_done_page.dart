import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:winbrother_hr_app/constants/globals.dart';
import 'package:winbrother_hr_app/controllers/pms_list_controller.dart';
import 'package:winbrother_hr_app/localization.dart';
import 'package:winbrother_hr_app/models/pms_detail_model.dart';
import 'package:winbrother_hr_app/my_class/my_app_bar.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/my_class/theme.dart';
import 'package:winbrother_hr_app/pages/pms_details.dart';
import 'package:winbrother_hr_app/routes/app_pages.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';

class PmsDonePage extends StatefulWidget {
  @override
  _PmsDonePageState createState() => _PmsDonePageState();
}
class _PmsDonePageState extends State<PmsDonePage> {
  final PmsListController controller = Get.put(PmsListController());
  bool pending = true;
  bool approved = true;
  bool rejected = true;
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    controller.offset.value = 0;
  }
  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [

              Container(
                  padding: EdgeInsets.only(left: 0, top: 10),
                  child: listViewWidget(context))
            ],
          ),
        ),
      ),
    );
  }
  Future _loadData() async {
    print("****loadmore****");
    controller.getPmsApprovedList();
  }
  Widget listViewWidget(BuildContext context) {
    final labels = AppLocalizations.of(context);
    String role = box.read('role_category');
    controller.getPmsApprovedList();
    return Container(
        child: Obx(()=>NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.isLoading.value && scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                print("*****BottomOfPmsList*****");
                if(controller.pmsManagerDoneDetailModels.length>=10){
                  // start loading data
                  controller.offset.value +=Globals.pag_limit;
                  controller.isLoading.value = true;
                  _loadData();
                }
              }
              return true;
            },
            child:ListView.builder(
              shrinkWrap: true,
              itemCount: controller.pmsManagerDoneDetailModels.value.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                PMSDetailModel pmsDetailModel = controller.pmsManagerDoneDetailModels.value[index];
                return InkWell(
                  onTap: (){
                    Get.toNamed(Routes.PMS_Manager_DONE_DETAILS_PAGE,arguments: pmsDetailModel);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pmsDetailModel.name,style: TextStyle(color: backgroundIconColor,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 20,),
                                  Text(pmsDetailModel.employeeId.name,style: TextStyle(color: Colors.deepPurple[700]),),
                                  SizedBox(height: 10,),
                                  Text(pmsDetailModel.compTemplateId.name,style: TextStyle(color: Colors.deepPurple[700]),),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Text('Deadline : ${
                                  //     AppUtils.changeDateFormat(pmsDetailModel.deadline)
                                  //
                                  // }',style: TextStyle(color: Colors.deepPurple[700]),),
                                  SizedBox(height: 10,),
                                  Text('Period : ${pmsDetailModel.dateRangeId.name}',style: TextStyle(color: Colors.deepPurple[700]),),
                                  SizedBox(height: 20,),
                                  Container(
                                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(pmsDetailModel.state.toString(),style: TextStyle(color: Colors.white),)
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
        ));
  }
}
