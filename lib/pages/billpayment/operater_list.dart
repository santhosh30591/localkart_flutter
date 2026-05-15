import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:localkart/Api/provider/billpay_provider.dart';
import 'package:localkart/Api/provider/home_provider.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/billpay_operater_list.dart';
import 'package:localkart/model/home_billpay_list.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BillPayOperateList extends StatefulWidget {
  final dynamic datas;

  const BillPayOperateList({Key? key, required this.datas}) : super(key: key);

  @override
  State<BillPayOperateList> createState() => _BillPayOperateList();
}

class _BillPayOperateList extends State<BillPayOperateList> {
  late List<OperaterListResults> _operaterList = [];

  List<String> operatorImageList = [];
  bool isLoading = false;

  BillPayData get model => widget.datas;

  String category = "";
  String stateId = "1";
  String districtId = "533";

  TextEditingController txt_edit_search = TextEditingController();

  @override
  void initState() {
    super.initState();
    category = model.name.toString();

    print("category name $category");
    operaterList();
  }

  @override
  Widget build(BuildContext context) {
    _operaterList = context.watch<BillPaymentProvider>().operaterListFilter;
    operatorImageList = context.watch<BillPaymentProvider>().operatorImageLists;
    isLoading = context.watch<BillPaymentProvider>().isLoading;

    return actionBarTopBottomViewBharathConnect(
      model.name.toString(),
      context,
      Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: isLoading == true && _operaterList.length == 0
            ? CardListItem(isLoading: true)
            : Stack(
                children: [
                  billpayViewLoading(),
                  if (isLoading) fullViewLoadingUi(isLoading),
                ],
              ),
      ),
    );
  }

  operaterList() async {
    var db = DBHelper();
    stateId = await db.getLoginSubDB("stateId");
    districtId = await db.getLoginSubDB("districtId");
    _operaterList = [];
    context.read<BillPaymentProvider>().upateContext(contexts: context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var operator = category;
      if (category.toLowerCase().contains("landline")) {
        operator = "Landline Postpaid";
      } else if (category.toLowerCase().contains("postpaid")) {
        operator = "Mobile Postpaid";
      } else if (category.toLowerCase().contains("education")) {
        operator = "Education Fees";
      }

      context.read<BillPaymentProvider>().getBillPayOpeatorList(
        operator,
        stateId,
        districtId,
      );
    });
  }

  billpayViewLoading() {
    return Column(
      children: [
        operatorImageList.length != 0
            ? Container(
                height: 200,
                child: ImageSlideshow(
                  indicatorColor: Colors.blue,
                  onPageChanged: (value) {
                    //    debugPrint('Page changed: $value');
                  },
                  autoPlayInterval: 3000,
                  isLoop: operatorImageList.length == 1 ? false : true,
                  children: [
                    for (var items in operatorImageList)
                      ClipRRect(
                        child: Image.network(
                          items.toString(),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/loading.gif"),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset("assets/logo_with_name1.png");
                          },
                        ),
                      ),
                  ],
                ),
              )
            : Container(),

        Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              style: BorderStyle.solid,
              color: billpay_div_line_color,
            ),
          ),

          child: Container(
            height: 40,
            width: double.infinity,
            padding: EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              // Capitalizes the first letter of each sentence
              controller: txt_edit_search,
              decoration: InputDecoration(
                hintText: 'Search',

                prefixIcon: Icon(Icons.search, color: billpay_div_line_color),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 25, // Adjust as needed
                  minHeight: 25,
                ),
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              onChanged: (searchText) => {
                // print("searchText $searchText and length " + searchText.length.toString())
                context.read<BillPaymentProvider>().searchStringCatory(
                  searchText.toString(),
                ),
              },
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ),

        _operaterList.length != 0
            ? Flexible(
                child: Card(
                  margin: EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: ListView.separated(
                    itemCount: _operaterList.length,
                    shrinkWrap: true,

                    // Key property: prevents expanding to fill all space
                    itemBuilder: (context, index) {
                      var data = _operaterList[index];
                      return InkWell(
                        onTap: () {
                          context.read<BillPaymentProvider>().fetchInfo(
                            _operaterList[index],
                            category,
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Container(
                                  padding: EdgeInsets.all(4),

                                  child: Image.network(
                                    data.icon.toString(),
                                    fit: BoxFit.cover,

                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/load.gif",
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/logo_with_name1.png",
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                data.name.toString(),
                                // textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                              ),
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
                        height:
                            0, // No extra height needed if thickness is enough
                      );
                    },
                  ),
                ),
              )
            : Expanded(
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text('No Data Found.')],
                ),
              ),
      ],
    );
  }
}

class CardListItem extends StatelessWidget {
  const CardListItem({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 220,

            width: double.maxFinite,
            // color: Colors.white, // The 'color' of the placeholder itself
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                style: BorderStyle.solid,
                color: Colors.grey,
              ),
            ),
            child: Container(
              height: 35,
              width: double.infinity,
              padding: EdgeInsets.all(5),
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[Icon(Icons.search), Text(" Search ")],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                style: BorderStyle.solid,
                color: Colors.grey,
              ),
            ),

            margin: EdgeInsets.all(10),
            child: ListView.separated(
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // var data = _operaterList[index];
                return InkWell(
                  onTap: () {},

                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: EdgeInsets.all(3),
                          height: 50,
                          width: 50,
                          child: CircleAvatar(
                            // child: CircleAvatar(),
                          ),
                        ),
                      ),

                      Container(
                        height: 20,
                        width: 200,
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
    );
  }
}
