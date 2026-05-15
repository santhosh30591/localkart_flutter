import 'package:flutter/material.dart';
import 'package:localkart/model/dashboard/todayServicesDetailsModel.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/showing.dart';
import 'package:screenshot/screenshot.dart';

class DelarMoreDetails extends StatefulWidget {
  int index;
  TodayServiceMoreModel services;

  bool isJob;

  DelarMoreDetails({
    Key? key,
    required this.index,
    required this.services,
    required this.isJob,
  }) : super(key: key);

  @override
  _DelarMoreDetails createState() => _DelarMoreDetails();
}

class _DelarMoreDetails extends State<DelarMoreDetails>
    with WidgetsBindingObserver {
  late TodayServiceMoreModel services;
  int index = 0;

  bool prev = false;
  bool next = false;

  @override
  void initState() {
    services = widget.services;
    index = widget.index;

    print("my index main is " + index.toString());

    print("my services list is " + _samplePages.length.toString());

    _controller = PageController(initialPage: index);

    if (index == 0) {
      prev = false;
      next = true;
    } else if (index > 0 &&
        index < services.result!.shopOfferList!.length - 1) {
      prev = true;
      next = true;
    } else if (index > 0 && index < services.result!.shopOfferList!.length) {
      prev = true;
      next = false;
    }

    WidgetsBinding.instance.addObserver(this);
    getListPages();
    super.initState();
  }

  List<Widget> _samplePages = [];

  getListPages() {
    for (int i = 0; i < services.result!.shopOfferList!.length; i++) {
      _samplePages.add(
        MyPage1Widget(
          services.result!.shopOfferList![i],
          i,
          services,
          widget.isJob,
        ),
      );
      // }
    }

    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("page not loading ");
    if (state == AppLifecycleState.resumed) {
      //do your stuff
    }
  }

  var _controller = PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this); // don't forget to dispose
    super.dispose();
  }

  _onPageViewChange(int page) {
    print("Current Page: " + page.toString());
    setState(() {
      if (page == 0) {
        prev = false;
        next = true;
      } else if (page > 0 &&
          page < services.result!.shopOfferList!.length - 1) {
        prev = true;
        next = true;
      } else if (page > 0 && page < services.result!.shopOfferList!.length) {
        prev = true;
        next = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          // alignment: Alignment.topCenter,
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _samplePages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _samplePages[index % _samplePages.length];
                    },
                    onPageChanged: _onPageViewChange,
                  ),
                ),
              ],
            ),
            Positioned(
              left: 10,
              top: 1,
              right: 10,
              child: Container(
                // width: MediaQuery.of(context).size.width - 20,
                margin: const EdgeInsets.only(top: 100),
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      prev == true
                          ? InkWell(
                              child: Container(
                                height: 40,
                                width: 40,
                                child: CircleAvatar(
                                  backgroundColor: app_theam[400],
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                              onTap: () {
                                _controller.previousPage(
                                  duration: _kDuration,
                                  curve: _kCurve,
                                );
                              },
                            )
                          : Container(),
                      next == true
                          ? InkWell(
                              child: Container(
                                height: 40,
                                width: 40,
                                child: CircleAvatar(
                                  backgroundColor: app_theam[400],
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                              onTap: () {
                                _controller.nextPage(
                                  duration: _kDuration,
                                  curve: _kCurve,
                                );
                              },
                            )
                          : Container(),
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
}

class MyPage1Widget extends StatelessWidget {
  ShopOfferList shopOfferList;

  int index;
  TodayServiceMoreModel services;

  bool isJob;

  MyPage1Widget(this.shopOfferList, this.index, this.services, this.isJob);

  String changeDateFormate(String date) {
    var dates = "";
    try {
      var yy = date.toString().split("-")[0];
      var mm = date.toString().split("-")[1];
      var dd = date.toString().split("-")[2];

      dates = dd + "-" + mm + "-" + yy;
    } catch (e) {}
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: app_theam,
        leading: IconButton(
          color: app_theam,
          icon: const Icon(Icons.arrow_back_sharp, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: isJob == true
            ? Text("Job Opening " + (index + 1).toString())
            : Text("Deal " + (index + 1).toString()),
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          // alignment: Alignment.topCenter,
          children: [
            Screenshot(
              controller: screenshotController,
              child: SingleChildScrollView(
                child: Container(
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
                              //   Navigator.of(context).push(MaterialPageRoute(
                              //       builder: (context) => ZoomingImages(
                              //             title: "" +
                              //                 services
                              //                     .result!
                              //                     .shopOfferList![index]
                              //                     .heading
                              //                     .toString(),
                              //             image: services
                              //                 .result!
                              //                 .shopOfferList![index]
                              //                 .offerImage
                              //                 .toString(),
                              //           )));
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
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
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 5, right: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 15,
                                color: const Color(0xFF616161),
                              ),
                            ),
                            Text(
                              changeDateFormate(
                                    services.result!.fromDate.toString(),
                                  ) +
                                  " To " +
                                  changeDateFormate(
                                    services.result!.toDate.toString(),
                                  ),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 5, right: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Direction",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF616161),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                services.result!.distance.toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: app_theam, width: 1),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(8.0),
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
                ),
              ),
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
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                      const Text(
                        " Back",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (services.result!.shopOfferList!.length == 1) {
                    shareServicesDetails(
                      services.result!.shopName.toString() +
                          "\n\n" +
                          "Valid From " +
                          services.result!.fromDate!.toString() +
                          " To " +
                          services.result!.fromDate!.toString() +
                          "\n\n" +
                          services.result!.shopOfferList![0].heading
                              .toString() +
                          "\n\n " +
                          services.result!.shopOfferList![0].description
                              .toString(),
                      "https://bit.ly/3Bo6WNb",
                    );
                  } else {
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
                              .toString() +
                          "\n\n and  " +
                          (services.result!.shopOfferList!.length - 1)
                              .toString() +
                          " more deals",
                      "https://bit.ly/3Bo6WNb",
                    );
                  }
                },
                child: Container(
                  height: 50,
                  color: app_theam[400],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.share, color: Colors.white, size: 24),
                      const Text(
                        " Share",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
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
