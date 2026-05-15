import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localkart/Api/provider/billpay_provider.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/billpay_operater_list.dart';
import 'package:localkart/model/fatch_bill_info_model.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/buttons.dart';
import 'package:localkart/unit/showing.dart';
import 'package:provider/provider.dart';

class BillFatchInfoEnterCard extends StatefulWidget {
  final dynamic datas;

  const BillFatchInfoEnterCard({Key? key, required this.datas})
    : super(key: key);

  @override
  State<BillFatchInfoEnterCard> createState() => _BillFatchInfoEnterCard();
}

class _BillFatchInfoEnterCard extends State<BillFatchInfoEnterCard> {
  FatchBillInfoModel get model => widget.datas['response'];

  OperaterListResults get billerinfo => widget.datas['billerinfo'];

  FatchBillResult get result => model.result!;

  String get title => widget.datas['app_title'];

  var userId = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomViewBharathConnect(
      title,
      context,
      Consumer<BillPaymentProvider>(
        builder: (context, provider, child) {
          return Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: parmsLoading(provider),
                  ),
                ),
                if (provider.isLoading) fullViewLoadingUi(provider.isLoading),
              ],
            ),
          );
        },
      ),
    );
  }

  parmsLoading(BillPaymentProvider provider) {
    return Container(
      child: Column(
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
                            billerinfo.icon.toString(),
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
                        billerinfo.name.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(right: 10, left: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                            color: app_theam,
                          ),
                        ),
                        child: Text(
                          "  Change  ",
                          style: const TextStyle(
                            color: app_theam,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: billpay_div_line_color,
                  margin: EdgeInsets.only(top: 3),
                  height: 1,
                ),
                loadingParmsData(provider),
                SizedBox(height: 15),
                InkWell(
                  onTap: (provider.isAllValid && !provider.isLoading)
                      ? () async {
                          userId = await DBHelper().getUserId();

                          Map<String, Object> params = {
                            "billerid": billerinfo.billerid.toString(),
                            "billertype": provider.paramData[0].inputName!
                                .toString(),
                            "number": provider.paramData[0].enterValues
                                .toString(),
                            "adhoc": result.adhoc!,
                            "userid": userId,
                          };

                          if (result.fetchrequiment.toString().toUpperCase() ==
                              "MANDATORY") {
                            var url = "fastag_balance";

                            if (title.toLowerCase().contains("landline")) {
                              url = "landline_balance";
                            } else if (title.toLowerCase().contains(
                              "postpaid",
                            )) {
                              url = "postpaid_balance";
                            } else if (title.toLowerCase().contains(
                              "electricity",
                            )) {
                              url = "eb_balance";
                            } else if (title.toLowerCase().contains(
                              "credit card",
                            )) {
                              url = "creditcard_balance";
                              params = {
                                "billerid": billerinfo.billerid.toString(),
                                "billertype": result.billername.toString(),
                                "cardnumber": provider.paramData[0].enterValues
                                    .toString(),
                                "number": provider.paramData[1].enterValues
                                    .toString(),
                                "adhoc": result.adhoc!.toString(),
                                "userid": userId.toString(),
                              };
                            }

                            provider.fetchBalanceInfo(
                              params,
                              url,
                              model.result!,
                              billerinfo,
                              title,
                            );
                          } else {
                            Navigator.pushNamed(
                              context,
                              root_fetch_balance,
                              arguments: {
                                'fetch_bill_result': model.result!,
                                'operator': billerinfo,
                                'app_title': title,
                              },
                            );
                          }
                        }
                      : null,
                  child: submitBottomButton(
                    "Submit",
                    provider.isAllValid && !provider.isLoading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingParmsData(BillPaymentProvider provider) {
    return ListView.builder(
      itemCount: provider.paramData.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10, left: 12, right: 10, bottom: 5),
      itemBuilder: (context, index) {
        var param = provider.paramData[index];
        return Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                param.labelName.toString(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: param.enterValues.isEmpty
                        ? billpay_div_line_color
                        : (param.isValidate ? Colors.green : Colors.red),
                  ),
                ),
                child: Container(
                  height: 45,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    // controller: TextEditingController(text: param.enterValues),
                    inputFormatters: [UpperCaseTextFormatter()],
                    textCapitalization: TextCapitalization.none,
                    maxLength: int.tryParse(param.maxLength ?? "100") ?? 100,
                    keyboardType: param.inputType == "NUMERIC"
                        ? TextInputType.number
                        : TextInputType.text,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Enter ${param.inputName}",
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      provider.enterNumbers(value, index);
                    },
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ),
              if (param.enterValues.isNotEmpty && !param.isValidate)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 2),
                  child: Text(
                    "Please enter valid ${param.labelName} (Min ${param.minLength}, Max ${param.maxLength})",
                    style: TextStyle(fontSize: 11, color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
