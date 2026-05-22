import 'package:flutter/material.dart';
import 'package:localkart/Api/provider/billpay_provider.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/model/bill_pay_model/view_status_details_model.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TransStatusDetails extends StatefulWidget {
  final dynamic datas;

  const TransStatusDetails({super.key, required this.datas});

  @override
  State<TransStatusDetails> createState() => _TransStatusDetails();
}

class _TransStatusDetails extends State<TransStatusDetails> {
  bool isLoading = false;
  bool isHistory = true;
  List<StatusInfo> info = [];
  late var referrenceid = widget.datas['referrenceid'];
  var status = "";

  @override
  void initState() {
    super.initState();
    getStatusDetails();
  }

  void getStatusDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BillPaymentProvider>().upateContext(contexts: context);
      Provider.of<BillPaymentProvider>(
        context,
        listen: false,
      ).getBillPayStatus(referrenceid);
    });
  }

  ViewStatusdetailsModel viewStatusdetailsModel = ViewStatusdetailsModel();

  var title = "Bill Pay History";
  late BuildContext context1;

  @override
  Widget build(BuildContext context) {
    isLoading = context.watch<BillPaymentProvider>().isLoading;
    context1 = context;
    try {
      isHistory = widget.datas['isHistory'];
    } catch (e) {
      isHistory = true;
    }

    return PopScope(
      // Set to false to prevent the default pop action
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        if (!isHistory) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            root_dashboard,
            (route) => false,
          );
        } else {
          Navigator.of(context).pop(false);
        }
      },
      child: Consumer<BillPaymentProvider>(
        builder: (context, provider, child) {
          try {
            viewStatusdetailsModel = provider.viewStatusdetailsModel;
            title = viewStatusdetailsModel.result!.category.toString();
            status = viewStatusdetailsModel.result!.status.toString();
            info = viewStatusdetailsModel.result!.info!;
          } catch (e) {
            title = "Bill Pay Details";
          }

          // return actionBarTopBottomViewBharathConnect(
          //     title,
          //     context,
          // );
          return actionBarTopBottomViewBharathConnect(
            title,
            context,

            Scaffold(
              body: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: provider.isLoading
                    ? TempLoadingStatus(isLoading: provider.isLoading)
                    : SingleChildScrollView(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: provider.viewStatusdetailsModel.errorCode == 0
                              ? viewStatusHeadder(provider)
                              : Center(
                                  child: Text(
                                    provider.viewStatusdetailsModel.message!,
                                  ),
                                ),
                        ),
                      ),
              ),
              bottomNavigationBar: viewStatusdetailsModel.rewards == false
                  ? Container(height: 1)
                  : InkWell(
                      onTap: () {
                        try {
                          print(
                            "name " +
                                viewStatusdetailsModel
                                    .result!
                                    .reward!
                                    .result!
                                    .reward_title
                                    .toString(),
                          );
                        } catch (e) {
                          print("error $e");
                        }
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(gradient: app_gradient),

                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  viewStatusHeadder(BillPaymentProvider provider) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(10.0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Image.network(
                          viewStatusdetailsModel.result!.icon.toString(),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/load.gif"),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset("assets/logo_with_name1.png");
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      viewStatusdetailsModel.result!.operator.toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(right: 10, left: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: status == "Refunded"
                            ? Colors.amber
                            : status == "Success"
                            ? Colors.green
                            : Colors.redAccent, // Refunded
                      ),
                    ),
                    child: Text(
                      "  $status  ",
                      style: TextStyle(
                        color: status == "Refunded"
                            ? Colors.amber
                            : status == "Success"
                            ? Colors.green
                            : Colors.redAccent, // Refunded
                        fontSize: 13,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              Container(
                color: billpay_div_line_color,
                margin: EdgeInsets.only(top: 3, bottom: 10),

                height: 1,
              ),

              loadingBillerDetails(info),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget loadingBillerDetails(List<StatusInfo> info) {
    return ListView.builder(
      itemCount: info.length,
      shrinkWrap: true,

      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // var data = _operaterList[index];
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      info[index].key.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      maxLines: 2,
                    ),
                  ),

                  Container(
                    child: Text(
                      info[index].value.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            if (index < info.length - 1)
              Container(
                child: Text(
                  "----------------------------------------------------------------------------------------------------------------",
                  style: TextStyle(color: billpay_div_line_color, fontSize: 12),
                  maxLines: 1,
                ),
              ),
          ],
        );
      },
    );
  }
}

class TempLoadingStatus extends StatelessWidget {
  const TempLoadingStatus({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.all(10),
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            style: BorderStyle.solid,
            color: Colors.grey,
          ),
        ),

        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),

              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(3),
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      // child: CircleAvatar(),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 20,
                    width: 200,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
            Container(
              color: billpay_div_line_color,
              height: 1,
              width: double.infinity,
            ),
            Container(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              //   border: Border.all(
              //     width: 1,
              //     style: BorderStyle.solid,
              //     color: Colors.grey,
              //   ),
              // ),
              child: ListView.separated(
                itemCount: 5,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // var data = _operaterList[index];
                  return Container(
                    padding: EdgeInsets.all(20),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 15,
                          width: 100,
                          color: Colors.grey[300],
                        ),
                        Container(
                          height: 15,
                          width: 150,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  // This builds the separator widget (a horizontal line by default)
                  return Divider(
                    color: billpay_div_line_color, // Customize the color
                    thickness: 1, // Customize the thickness
                    height: 0, // No extra height needed if thickness is enough
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
