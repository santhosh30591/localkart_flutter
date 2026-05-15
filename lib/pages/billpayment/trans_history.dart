import 'package:flutter/material.dart';
import 'package:localkart/Api/provider/billpay_provider.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/bill_pay_model/trans_history_model.dart';
import 'package:localkart/model/bill_pay_model/view_status_details_model.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TransHistory extends StatefulWidget {
  const TransHistory({Key? key}) : super(key: key);

  @override
  State<TransHistory> createState() => _TransHistory();
}

class _TransHistory extends State<TransHistory> {
  bool isLoading = false;
  List<Results>? results = [];
  var status = "";

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  void getHistory() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<BillPaymentProvider>().upateContext(contexts: context);
      context.read<BillPaymentProvider>().isUiLoading(true);

      var userid = await DBHelper().getUserId();
      Provider.of<BillPaymentProvider>(
        context,
        listen: false,
      ).getBillPayHistory(userid);
    });
  }

  var title = "Bill Pay History";

  @override
  Widget build(BuildContext context) {
    isLoading = context.watch<BillPaymentProvider>().isLoading;

    return actionBarTopBottomViewBharathConnect(
      title,
      context,
      Consumer<BillPaymentProvider>(
        builder: (context, provider, child) {
          try {
            results = provider.results;
          } catch (e) {}
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: provider.isLoading
                ? TempHistoryLoading(isLoading: isLoading)
                : Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: viewHistory(),
                  ),
          );
        },
      ),
    );
    // return Container(
    //   decoration: const BoxDecoration(
    //     image: DecorationImage(
    //       image: AssetImage("assets/login-reg-bg.png"),
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    //   child:
    // );
  }

  Widget viewHistory() {
    return Container(
      child: results!.length == 0
          ? Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 40),
              alignment: Alignment.center,
              child: Text("No Transactions", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              itemCount: results!.length,
              padding: EdgeInsets.all(5),
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                var result = results![index];

                return InkWell(
                  onTap: () {
                    Map<String, dynamic> data = {
                      "referrenceid": result.referrenceid!,
                      "isHistory": true,
                    };
                    Navigator.of(
                      context,
                    ).pushNamed(root_view_billbay_status, arguments: data);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: billpay_div_line_color,
                      ),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                result.operator!,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: result.status == 1
                                      ? Colors.green
                                      : Colors.redAccent,
                                ),
                              ),

                              Text(
                                result.number!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                result.paymentDate!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "₹" + result.amount!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey.withAlpha(100),
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class TempHistoryLoading extends StatelessWidget {
  const TempHistoryLoading({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            child: ListView.builder(
              itemCount: 5,
              padding: EdgeInsets.all(5),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // var data = _operaterList[index];
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      style: BorderStyle.solid,
                      color: billpay_div_line_color,
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 14,
                            width: 200,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 12,
                            width: 150,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 10,
                            width: 100,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 12,
                            width: 60,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 5),
                          Container(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
