import 'package:flutter/material.dart';
import 'package:localkart/Api/provider/manage_business_provider.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/dashboard/manage_business_model.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:provider/provider.dart';

class SubscribersListPage extends StatefulWidget {
  SubscribersListPage({Key? key}) : super(key: key);

  @override
  State<SubscribersListPage> createState() => _SubscribersListState();
}

class _SubscribersListState extends State<SubscribersListPage> {
  late BuildContext contextMain;
  bool _isLoading = true;

  late ManageBusinessProvider provider;

  late ManageBusinessModel manageBusinessModel = ManageBusinessModel(
    errorCode: 1,
    message: "",
  );

  loadingServiceDetails() async {
    var dbhelper = await DBHelper();
    var shopIndexId = await dbhelper.getLoginDB("shopId");
    var userIndexId = await dbhelper.getLoginSubDB('Id');
    var type = await dbhelper.getLoginDB('type');

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    Map<String, Object> inputs = {
      "shopIndexId": shopIndexId.toString(),
      "userIndexId": userIndexId.toString(),
      "type": type.toString(),
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        provider = Provider.of<ManageBusinessProvider>(context, listen: false);
        provider.updateContext(contexts: context);
        provider.getScrber(inputs);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadingServiceDetails();
  }

  String address = "";
  var isWindows = false;
  int select_posication = 0;

  @override
  Widget build(BuildContext context) {
    contextMain = context;

    return actionBarTopBottomView(
      "Subscribers",
      context,
      Scaffold(
        body: Container(
          color: Colors.white,
          child: Consumer<ManageBusinessProvider>(
            builder: (context, provider, child) {
              _isLoading = provider.isLoading;
              final model = provider.manageBusinessModel1;

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  model.errorCode == 0 && model.results != null
                      ? SingleChildScrollView(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        color: app_colorSecondary,
                                        child: Row(
                                          children: [
                                            buildHeaderCell("#", 50),
                                            buildHeaderCell("Name", 160),
                                            buildHeaderCell("Mobile", 140),
                                            buildHeaderCell("District", 160),
                                            buildHeaderCell("Subscribed", 90),
                                          ],
                                        ),
                                      ),
                                      for (
                                        int i = 0;
                                        i < model.results!.length;
                                        i++
                                      ) ...[
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              buildHeaderCell(
                                                (i + 1).toString(),
                                                50,
                                              ),
                                              buildHeaderCell(
                                                model.results![i].name ?? " -",
                                                160,
                                              ),
                                              buildHeaderCell(
                                                model.results![i].mobile ?? " -",
                                                140,
                                              ),
                                              buildHeaderCell(
                                                model.results![i].district ??
                                                    " -",
                                                160,
                                              ),
                                              buildHeaderCell(
                                                (model.results![i].time ==
                                                            null ||
                                                        model
                                                            .results![i]
                                                            .time!
                                                            .isEmpty)
                                                    ? (model.results![i].date ??
                                                          "")
                                                    : "${model.results![i].date ?? ""}\n${model.results![i].time ?? ""}",
                                                90,
                                                // fontSize: 13,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(3),
                                          color: billpay_div_line_color,
                                          height: 1,
                                          child: Row(
                                            children: [
                                              Container(width: 60),
                                              Container(width: 160),
                                              Container(width: 140),
                                              Container(width: 160),
                                              Container(width: 90),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : model.errorCode == 1
                      ? Center(
                          child: Text(
                            model.message.toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                        )
                      : Center(
                          child: Text(
                            manageBusinessModel.message!,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                  _isLoading != false
                      ? Container(
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 80,
                                  height: 80,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 10),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/load.gif"),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: const Text(
                                    "Loading...",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      // child: Loader(loadingTxt: 'Loading...'))
                      : Container(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget buildHeaderCell(String s, int i) {
  return Container(width: i.toDouble(), child: Text(s));
}
