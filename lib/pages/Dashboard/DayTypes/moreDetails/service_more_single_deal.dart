import 'package:flutter/material.dart';
import 'package:localkart/model/dashboard/todayServicesDetailsModel.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/showing.dart';
import 'package:screenshot/screenshot.dart';

class TodayMoreDetails2 extends StatefulWidget {
  int index;

  bool isJob;
  TodayServiceMoreModel services;

  TodayMoreDetails2({
    Key? key,
    required this.index,
    required this.services,
    required this.isJob,
  }) : super(key: key);

  @override
  State<TodayMoreDetails2> createState() => _TodayMoreDetails2();
}

class _TodayMoreDetails2 extends State<TodayMoreDetails2> {
  late BuildContext contextMain;
  late TodayServiceMoreModel services = new TodayServiceMoreModel();
  late int index;

  @override
  void initState() {
    services = widget.services;

    index = widget.index;
    super.initState();
  }

  String address = "";

  @override
  Widget build(BuildContext context) {
    contextMain = context;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: app_theam,
        leading: IconButton(
          color: app_theam,
          icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: widget.isJob == true
            ? Text("Job Opening " + (index + 1).toString())
            : Text("Deal " + (index + 1).toString()),
      ),
      body: Container(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Screenshot(
              controller: screenshotController,
              child: services.errorCode == 0
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              InkWell(
                                child: Container(
                                  height: 220,
                                  color: Colors.white,
                                  width: double.infinity,
                                  child: Image.network(
                                    services
                                        .result!
                                        .shopOfferList![index]
                                        .offerImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/logo_with_name1.png",
                                      );
                                    },
                                  ),
                                ),
                                onTap: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ZoomingImages(
                                  //       title:
                                  //           "" +
                                  //           services
                                  //               .result!
                                  //               .shopOfferList![index]
                                  //               .heading
                                  //               .toString(),
                                  //       image:
                                  //           "" +
                                  //           services
                                  //               .result!
                                  //               .shopOfferList![index]
                                  //               .offerImage
                                  //               .toString(),
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            color: app_colorSecondary,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              services.result!.shopOfferList![index].heading
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(color: app_theam, fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 5, right: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Date",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF616161),
                                  ),
                                ),
                                Text(
                                  services.result!.fromDate.toString() +
                                      " To " +
                                      services.result!.toDate.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: app_theam, width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            alignment: Alignment.topLeft,
                            child: Text(
                              services.result!.shopOfferList![index].description
                                  .toString(),
                              textScaleFactor: 1,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  color: app_theam[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      Text(
                        " Back ",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  shareServicesDetails(
                    services.result!.shopName.toString() +
                        "\n\n" +
                        "Valid From " +
                        services.result!.fromDate!.toString() +
                        " To " +
                        services.result!.fromDate!.toString() +
                        "\n\n" +
                        services.result!.shopOfferList![index].heading
                            .toString() +
                        "\n\n " +
                        services.result!.shopOfferList![index].description
                            .toString(),
                    "https://bit.ly/3Bo6WNb",
                  );
                },
                child: Container(
                  height: 50,
                  color: app_theam[400],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.share, color: Colors.white, size: 24),
                      Text(
                        " Share ",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  var Uint8List = null;
  late ScreenshotController screenshotController = ScreenshotController();
}
