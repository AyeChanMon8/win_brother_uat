import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winbrother_hr_app/constants/globals.dart';
import 'package:winbrother_hr_app/controllers/reward_controller.dart';
import 'package:winbrother_hr_app/my_class/my_style.dart';
import 'package:winbrother_hr_app/routes/app_pages.dart';
import 'package:winbrother_hr_app/utils/app_utils.dart';

class RewardApprovalPage extends StatefulWidget {
  final String pageType;

  RewardApprovalPage(this.pageType);

  @override
  _RewardApprovalPageState createState() => _RewardApprovalPageState();
}

class _RewardApprovalPageState extends State<RewardApprovalPage> {
  final RewardController controller = Get.put(RewardController());
  Future _loadData() async {
    widget.pageType == 'approval'
        ? controller.getRewardsApproval()
        : controller.getRewardApprove();
  }

  @override
  void initState() {
    super.initState();
    controller.offset.value = 0;
    widget.pageType == 'approval'
        ? controller.getRewardsApproval()
        : controller.getRewardApprove();
  }

  @override
  Widget build(BuildContext context) {
    var limit = Globals.pag_limit;
    return Container(
        child: Obx(() => RefreshIndicator(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!controller.isLoading.value &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  // start loading data
                  controller.offset.value += limit;
                  controller.isLoading.value = true;
                  _loadData();
                }
                return true;
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.rewards.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        // widget.pageType == 'approval'
                        Get.toNamed(Routes.REWARD_DETAILS_PAGE,
                            arguments: index);
                        // : controller
                        //     .downloadReward(controller.rewards[index]);
                      },
                      child: ListTile(
                          leading: Text(controller.rewards[index].code),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.rewards[index].employeeId[0].name,
                                style: subtitleStyle(),
                              ),
                              Text(
                                controller.rewards[index].description,
                                style: subtitleStyle(),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppUtils.changeDateFormat(
                                  controller.rewards[index].date.toString())),
                              Text(
                                controller
                                    .rewards[index].employeeId[0].rewardTotal
                                    .toString(),
                                style: subtitleStyle(),
                              )
                            ],
                          ),
                          trailing: arrowforwardIcon),
                    ),
                  );
                },
              ),
            ),
            onRefresh: widget.pageType == 'approval'
                ? controller.getRewardsApproval
                : controller.getRewardApprove)));
  }
}
