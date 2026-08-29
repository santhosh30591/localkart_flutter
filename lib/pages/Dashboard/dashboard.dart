import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localkart/Api/provider/home_provider.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/bill_pay_model/view_status_details_model.dart';

import 'package:localkart/model/dashboard/servicesDetailsModel.dart';
import 'package:localkart/model/dashboard/shop_services_model.dart';
import 'package:localkart/model/dashboard_model.dart';
import 'package:localkart/model/home_billpay_list.dart';
import 'package:localkart/pages/Dashboard/manage_business/ticketNxt/bookings.dart';
import 'package:localkart/pages/Dashboard/menu/Notification/notification_details.dart';
import 'package:localkart/pages/Dashboard/menu/Notification/notification_post_details.dart';

import 'package:localkart/pages/Dashboard/nav.dart';
import 'package:localkart/pages/events/bookNow.dart';
import 'package:localkart/pages/events/eventdetailspage.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/showingLocationAletrs.dart';

import 'package:marquee/marquee.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage> {
  late List<BillPayData> _billPayDataList = [];
  List<Events> ticket_next_events = [];
  late HomePageProvider provider;

  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    // 3. Use the controller to scroll
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  var _pushToken = "";

  Future<void> initOneSignal() async {
    // 1. Initialize with your App ID from the OneSignal Dashboard
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize("b830f3f7-f484-4e37-893d-dd4050874621");
    await OneSignal.User.pushSubscription.optIn();

    // 2. Request permission to send notifications
    await OneSignal.Notifications.requestPermission(true);

    // 3. Fetch the device token (Push Token)
    // Note: This may be null if the device hasn't registered with FCM/APNs yet
    String? token = await OneSignal.User.pushSubscription.id;
    String? onesignalId = await OneSignal.User.getOnesignalId();
    print(
      "_pushToken1 main $_pushToken onesignalId $onesignalId token $token and info ",
    );

    if (token.toString().length > 6) {
      provider.getUpdateDetvices(token);
    }
    OneSignal.Notifications.addClickListener((event) {
      // Access title and body the same way
      String? title = event.notification.title;
      String? body = event.notification.body;

      Map<dynamic, dynamic>? additionalData = event.notification.additionalData;

      print(
        "Foreground  Title: $title body $body additionalData $additionalData ",
      );

      try {
        var type = additionalData!['type'];
        print("Type $type  ");

        if (type == "event") {
          var id = additionalData['eventId'];
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(
                context,
                eventId: int.parse(id.toString()),
                flag: 1,
              ),
            ),
          );
        } else if (type == "newshop") {
          ServiceDetailsModel listSetvices = ServiceDetailsModel();

          setState(() {});

          var shopType = additionalData['shopType'];
          var shopIndexId = additionalData['shopIndexId'];

          listSetvices.type = shopType;
          listSetvices.shopIndexId = shopIndexId.toString();

          Navigator.of(
            context,
          ).pushNamed(root_services_more_details, arguments: listSetvices);
        } else if (type == "offer") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PostNotyDetails(
                shopIndexId: "" + additionalData['postIndexId'].toString(),
                postIndexId: "" + additionalData['shopIndexId'].toString(),
                postType: "" + additionalData['shopType'].toString(),
              ),
            ),
          );
        } else if (type == "offerdetails") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotificationDetails(
                notificationId: "" + additionalData['id'].toString(),
              ),
            ),
          );
        } else if (type == "event_booking") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventBookingsListPage(
                eventId: int.parse(additionalData['eventId'].toString()),
              ),
            ),
          );
        } else {
          print("data type $type not available.");
        }
      } catch (e) {
        print("event type not error $e");
      }
      event.notification.display();
    });
  }

  var district_name = "Hosur";

  bool isLoading = false;
  var dbhelper = DBHelper();

  var userIndexId = "5";
  var flag = "0";
  var stateId = "1";
  var districtId = "752";
  var lat = "";
  var longs = "";

  var isServices = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      flag = await DBHelper().getLoginDB("flag");
      userIndexId = await await DBHelper().getLoginSubDB('Id');
      stateId = await await DBHelper().getLoginSubDB('stateId');
      districtId = await await DBHelper().getLoginSubDB('districtId');
      lat = await await DBHelper().getLocationDetailsDB(true);
      longs = await await DBHelper().getLocationDetailsDB(false);
      var district_names = await await DBHelper().getLoginSubDB(
        'district_name',
      );
      district_name = district_names.toString();

      provider = await Provider.of<HomePageProvider>(context, listen: false);
      provider.updateContext(contexts: context);
      provider.getDashboard(userIndexId, stateId, districtId);
      await provider.getrewards(userIndexId);

      if (!isLiveMode) {
        await initOneSignal();
      }
      await checkingGpsSearch();

      setState(() {});
    });
  }

  int _currentIndex = 0;
  DashboardModel dashboardModel = DashboardModel();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default back button behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final bool? shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Yes'),
              ),
            ],
          ),
        );

        print("logs $shouldExit");

        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },

      child: Consumer<HomePageProvider>(
        builder: (context, provider, child) {
          isLoading = provider.isLoading;
          _billPayDataList = provider.billPayDataList;
          dashboardModel = provider.dashboardModel;
          ticket_next_events = provider.events;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/login-reg-bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SafeArea(
                  top: true,
                  bottom: true,

                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    drawer: NavBar(),

                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      iconTheme: IconThemeData(color: Colors.white),

                      // Changes the menu icon to red
                      title: InkWell(
                        onTap: () {
                          checkingLocation();
                        },
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "LocalKart ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "®",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "$district_name",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      Icons.location_on,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        InkWell(
                          onTap: () async {

                              if (_currentIndex == 0) {
                                Navigator.of(context).pushNamed(root_search);
                                // var details = RewardDetails(
                                //   id: 192,
                                //   reward_title: "test title",
                                //   reward_type: "Reward typesss",
                                //   reward_validity: "12-12-2026",
                                // );
                                //
                                // try {
                                //   scarchCard(context, details);
                                // } catch (e) {
                                //   print("error $e");
                                // }
                              } else {
                                showEventAlerts();
                              }

                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              _currentIndex == 0
                                  ? Icons.search
                                  : _currentIndex == 1
                                  ? Icons.filter_alt_outlined
                                  : null,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                    body: Container(
                      color: Colors.white,
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width,
                      child:
                          dashboardModel.errorCode != null &&
                              dashboardModel.errorCode == 2
                          ? networkIssue()
                          : Stack(
                              children: [
                                bottomSelectTabView(),

                                // Pinned bottom right icon
                                Positioned(
                                  bottom: 10.0,
                                  right: 12.0,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(
                                        context,
                                      ).pushNamed(root_ai_home);
                                    },

                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      padding: const EdgeInsets.all(1.0),
                                      // 1-pixel padding around the asset
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        // Background color visible through the 1px padding
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            // Shadow color
                                            spreadRadius: 1,
                                            // How much the shadow spreads
                                            blurRadius: 5,
                                            // How soft the shadow looks
                                            offset: const Offset(
                                              0,
                                              2,
                                            ), // Shadow position (x, y)
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/ic_ai_chart.gif",
                                          fit: BoxFit
                                              .cover, // Fills the circular shape perfectly
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    bottomNavigationBar: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Container(color: billpay_div_line_color, height: 1),
                        Container(
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(child: selectBottomView("0")),
                              Expanded(child: selectBottomView("1")),
                              Expanded(child: selectBottomView("2")),
                              Expanded(child: selectBottomView("3")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget bottomSelectTabView() {
    double leftRigthPading = 10;

    if (dashboardModel.errorCode == null) {
      return TempDashboardLoading(isLoading: isLoading);
    } else {
      List<DashboardSlider> topSlider = dashboardModel.topSlider!;

      if (_currentIndex == 0) {
        if (dashboardModel.errorCode == null) {
          return TempDashboardLoading(isLoading: isLoading);
        } else {
          List<Events> events = dashboardModel.events!;

          List<Billpayment>? billpayment = dashboardModel.billpayment!;
          List<Shopping> shopping = dashboardModel.shopping!;
          List<Shopping> services = dashboardModel.services!;
          topSlider = dashboardModel.topSlider!;
          List<DashboardSlider> slider1 = dashboardModel.slider1!;
          List<DashboardSlider> slider2 = dashboardModel.slider2!;
          List<DashboardSlider> slider3 = dashboardModel.slider3!;
          String news = dashboardModel.news!;
          Post post = dashboardModel.post!;

          double imagePadding = 2;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Slid
                sliderView(topSlider),
                events.length == 0
                    ? Container()
                    : Container(
                        // margin: EdgeInsets.all(leftRigthPading),
                        margin: EdgeInsets.only(left: 10, top: 10),
                        child: Container(
                          child: Text(
                            "Events Around You",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                // Events Around You list
                Container(
                  child: Container(
                    height: events.length == 0 ? 5 : 150,
                    margin: EdgeInsets.only(
                      top: events.length == 0 ? 0 : 10,
                      bottom: events.length == 0 ? 0 : 5,
                      left: 10,
                      right: 10,
                    ),
                    child: ListView.builder(
                      itemCount: events.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return events[index].eventname == "More"
                            ? InkWell(
                                onTap: () {

                                    _currentIndex = 1;
                                    selectEventFilter = 1;
                                    provider.getDashboardEvent(
                                      userIndexId.toString(),
                                      stateId.toString(),
                                      districtId.toString(),
                                      lat,
                                      longs,
                                      selectEventFilter,
                                    );
                                    setState(() {});

                                },
                                child: Container(
                                  width: 120,
                                  height: 150,
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  // padding: EdgeInsets.all(imagePadding),
                                  // margin: EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // Adjust for corner roundness
                                    child: Image.asset("assets/l_more.png"),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EventDetailsPage(
                                          context,
                                          eventId: events[index].eventId!
                                              .toInt(),
                                          flag: 1,
                                        ),
                                      ),
                                    );

                                },

                                child: Container(
                                  width: 120,
                                  height: 150,
                                  margin: EdgeInsets.only(right: 10),

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    // If you need rounded corners
                                    child: Image.network(
                                      events[index].image.toString(),
                                      width: 120,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (
                                            BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress,
                                          ) {
                                            if (loadingProgress == null) {
                                              return child; // Image is fully loaded, display it
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null, // Displays exact progress if total size is known
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                                size: 40,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ),
                // Shopping cards
                InkWell(
                  onTap: () {
                    _currentIndex = 1;
                    selectEventFilter = 1;
                    provider.getDashboardEvent(
                      userIndexId.toString(),
                      stateId.toString(),
                      districtId.toString(),
                      lat,
                      longs,
                      selectEventFilter,
                    );
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.all(leftRigthPading),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: app_gradient,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(imagePadding),
                          child: Image.asset("assets/dash_happy.png"),
                          margin: EdgeInsets.only(right: 10),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                child: Text(
                                  "Happenings!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                              SizedBox(height: 2),
                              Text(
                                "Explore more events in your city.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Billpayment
                sliderView(slider1),
                Container(
                  margin: EdgeInsets.all(leftRigthPading),
                  padding: EdgeInsets.only(left: 0, top: 5),
                  child: Container(
                    child: Text(
                      "Bill Payment & Recharge",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Billpayment list
                Container(
                  margin: EdgeInsets.only(
                    left: leftRigthPading - 5,
                    right: leftRigthPading - 5,
                  ),

                  child: Container(
                    child: GridView.count(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      children: List.generate(billpayment.length, (index) {
                        return billpayment[index].name == "More"
                            ? InkWell(
                                onTap: () {
                                  _currentIndex = 3;
                                  provider.getBillPay();
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.all(imagePadding),
                                  // margin: EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    // Adjust for corner roundness
                                    child: Image.asset("assets/s_more.png"),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  BillPayData bdata = BillPayData();

                                  bdata.id = billpayment[index].id;
                                  bdata.icon = billpayment[index].icons;
                                  bdata.name = billpayment[index].name;

                                  Navigator.of(context).pushNamed(
                                    root_billpay_opertor_list,
                                    arguments: bdata,
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // Optional: rounded corners
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        billpayment[index].icons!.toString(),
                                      ),
                                      fit: BoxFit
                                          .cover, // Ensures the image fills the container
                                    ),
                                  ),
                                ),
                              );
                      }),
                    ),
                  ),
                ),
                // Billpayment cards
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.all(leftRigthPading),
                    padding: EdgeInsets.all(leftRigthPading),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(leftRigthPading),
                      gradient: app_gradient,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(imagePadding),
                          margin: EdgeInsets.only(right: 10),
                          child: Image.asset("assets/dash_recharge.png"),
                        ),

                        flag.toString() == "1"
                            ? Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(root_business);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        child: Text(
                                          "Manage My Business!",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 2),
                                      Text(
                                        "Create post, Manage Subscription & Events.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(root_business_basic);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        child: Text(
                                          "Advertise Your Business Free!",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 2),
                                      Text(
                                        "Get started now.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        Container(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Shopping
                sliderView(slider2),
                Container(
                  margin: EdgeInsets.all(leftRigthPading),
                  padding: EdgeInsets.only(left: 1),
                  child: Container(
                    child: Text(
                      "Shopping",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Shopping list
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: Container(
                    height: 95,
                    child: ListView.builder(
                      itemCount: shopping.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return shopping[index].name == "More"
                            ? InkWell(
                                onTap: () {
                                  isServices = false;
                                  provider.getShopServices(isServices);
                                  _currentIndex = 2;
                                  _scrollToTop();
                                },
                                child: Container(
                                  // width: 95,
                                  height: 95,
                                  margin: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.all(imagePadding),
                                  // margin: EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // Adjust for corner roundness
                                    child: Image.asset("assets/s_more.png"),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  var title = "Shopping";
                                  var services_id = shopping[index].id;
                                  Map<String, dynamic> arguments = {
                                    "state_id": stateId,
                                    "dist_id": districtId,
                                    "title": title,
                                    "services_id": services_id,
                                    "sub_title": shopping[index].name,
                                  };

                                  Navigator.of(context).pushNamed(
                                    root_services_list,
                                    arguments: arguments,
                                  );
                                },

                                child: Container(
                                  width: 95,
                                  height: 95,
                                  margin: EdgeInsets.only(
                                    left: index == 0 ? 0 : 7,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // Optional: rounded corners
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        shopping[index].icons!.toString(),
                                      ),
                                      fit: BoxFit
                                          .cover, // Ensures the image fills the container
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ),
                // Shopping cards
                InkWell(
                  onTap: () {
                    isServices = false;
                    provider.getShopServices(isServices);
                    _currentIndex = 2;
                    _scrollToTop();
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.all(leftRigthPading),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: app_gradient,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(imagePadding),
                          child: Image.asset("assets/dash_shop.png"),
                          margin: EdgeInsets.only(right: 10),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                child: Text(
                                  "Explore Shops Nearby!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                              SizedBox(height: 2),
                              Text(
                                "See more shops around you.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // services
                sliderView(slider3),
                Container(
                  margin: EdgeInsets.all(leftRigthPading),
                  padding: EdgeInsets.only(left: 1),
                  child: Container(
                    child: Text(
                      "Services",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: Container(
                    height: 95,
                    child: ListView.builder(
                      itemCount: services.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return services[index].name == "More"
                            ? InkWell(
                                onTap: () {
                                  isServices = true;
                                  provider.getShopServices(isServices);
                                  _currentIndex = 2;
                                  _scrollToTop();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.all(imagePadding),
                                  // margin: EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // Adjust for corner roundness
                                    child: Image.asset("assets/s_more.png"),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  var title = "Services";
                                  var services_id = services[index].id;
                                  Map<String, dynamic> arguments = {
                                    "state_id": stateId,
                                    "dist_id": districtId,
                                    "title": title,
                                    "services_id": services_id,
                                    "sub_title": services[index].name,
                                  };

                                  Navigator.of(context).pushNamed(
                                    root_services_list,
                                    arguments: arguments,
                                  );
                                },
                                child: Container(
                                  width: 95,
                                  height: 95,

                                  margin: EdgeInsets.only(
                                    left: index == 0 ? 0 : 7,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // Optional: rounded corners
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        services[index].icons!.toString(),
                                      ),
                                      fit: BoxFit
                                          .cover, // Ensures the image fills the container
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    isServices = true;
                    provider.getShopServices(isServices);
                    _currentIndex = 2;
                    _scrollToTop();
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.all(leftRigthPading),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: app_gradient,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(imagePadding),
                          child: Image.asset("assets/dash_service.png"),
                          margin: EdgeInsets.only(right: 10),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                child: Text(
                                  "Explore Services Nearby!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                              SizedBox(height: 2),
                              Text(
                                "See more services around you.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //news
                news.length != 0
                    ? Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.all(leftRigthPading),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: dashboard_news_color,
                        ),
                        child: SizedBox(
                          height: 20,
                          child: Marquee(
                            text: news,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                            scrollAxis: Axis.horizontal,
                            // Direction of movement
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 80.0,
                            // Space between repetitions
                            velocity: 100.0,
                            // Pixels per second
                            pauseAfterRound: Duration(seconds: 1),
                            // Pause before restarting
                            accelerationDuration: Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                          ),
                        ),
                      )
                    : Container(),

                // post details
                Container(
                  margin: EdgeInsets.only(top: 10),

                  decoration: BoxDecoration(gradient: app_gradient),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                child: Text(
                                  post.title!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              SizedBox(height: 5),
                              Text(
                                post.content!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 140,
                        // width: 140,
                        child: Image.asset("assets/post_alerts.png"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      } else if (_currentIndex == 1) {
        return isLoading && _billPayDataList.length == 0
            ? TempDashboardLoading(isLoading: isLoading)
            : Container(
                child: Container(
                  child:
                      ticket_next_events != null &&
                          ticket_next_events.length != 0
                      ? ticketNextUiLoading()
                      : Container(
                          // height: 300,
                          width: double.infinity,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text('No Data Found.')],
                          ),
                        ),
                ),
              );
      } else if (_currentIndex == 2) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sliderView(topSlider),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 65,
                    padding: EdgeInsets.all(leftRigthPading),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: home_service_tab_bg,
                        ),
                        color: home_service_tab_bg,
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                isServices = false;
                                setState(() {});
                                provider.getShopServices(isServices);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: !isServices
                                        ? app_theam
                                        : Colors.transparent,
                                  ),
                                  color: !isServices
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                                padding: EdgeInsets.all(leftRigthPading),
                                child: Text(
                                  "Shopping",
                                  style: TextStyle(
                                    color: !isServices ? app_theam : app_theam,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                isServices = true;
                                setState(() {});
                                provider.getShopServices(isServices);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: isServices
                                        ? app_theam
                                        : Colors.transparent,
                                  ),
                                  color: isServices
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                                padding: EdgeInsets.all(leftRigthPading),
                                child: Text(
                                  "Services",
                                  style: TextStyle(
                                    color: !isServices ? app_theam : app_theam,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              shopServicesLoading(),
            ],
          ),
        );
      } else if (_currentIndex == 3) {
        return isLoading && _billPayDataList.length == 0
            ? TempDashboardLoading(isLoading: isLoading)
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Slid
                    sliderView(topSlider),
                    Container(
                      margin: EdgeInsets.only(
                        left: leftRigthPading,
                        right: leftRigthPading,
                        top: leftRigthPading,
                      ),
                      // padding: EdgeInsets.only(left: leftRigthPading),
                      child: Container(
                        child: Text(
                          "Bill Payment & Recharge",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    _billPayDataList.length != 0
                        ? billpayViewLoading()
                        : SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [Text('No Data Found.')],
                            ),
                          ),
                  ],
                ),
              );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('No Data Found.')],
        );
      }
    }
  }

  shopServicesLoading() {
    List<ShopServicesCategoryModel> mainList = [];

    if (isServices) {
      mainList = provider.servicesList;
    } else {
      mainList = provider.shoppingList;
    }

    return mainList.length == 0
        ? Container(
            height: 300,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text('No Data Found'),
                    ),
                    isLoading ? fullViewLoadingUi(isLoading) : Container(),
                  ],
                ),
              ],
            ),
          )
        : Container(
            child: Stack(
              children: [
                GridView.count(
                  cacheExtent: 300,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: List.generate(mainList.length, (index) {
                    return InkWell(
                      onTap: () {
                        var title = isServices ? "Services" : "Shopping";
                        var services_id = mainList[index].id;
                        Map<String, dynamic> arguments = {
                          "state_id": stateId,
                          "dist_id": districtId,
                          "title": title,
                          "services_id": services_id,
                          "sub_title": mainList[index].category,
                        };

                        Navigator.of(
                          context,
                        ).pushNamed(root_services_list, arguments: arguments);
                      },
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width / 7,
                                height: MediaQuery.of(context).size.width / 7,
                                child: Container(
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    child: Image.network(
                                      mainList[index].image.toString(),
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/logo_with_name1.png",
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    mainList[index].category.toString(),
                                    textAlign: TextAlign.center,

                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                isLoading
                    ? Container(
                        height: 300,
                        width: double.infinity,
                        child: fullViewLoadingUi(isLoading),
                      )
                    : Container(),
              ],
            ),
          );
  }

  billpayViewLoading() {
    return GridView.count(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      children: List.generate(_billPayDataList.length, (index) {
        var data = _billPayDataList[index];

        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              root_billpay_opertor_list,
              arguments: _billPayDataList[index],
            );
          },
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width / 7,
                    height: MediaQuery.of(context).size.width / 7,
                    child: Container(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Image.network(
                          data.icon.toString(),
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
                  Container(
                    alignment: Alignment.center,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        data.name.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget sliderView(List<DashboardSlider> sliderList) {
    return sliderList.length != 0
        ? Container(
            height: 200,
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: billpay_div_line_color,
                style: BorderStyle.solid,
              ),
            ),

            child: ImageSlideshow(
              indicatorColor: gradint_start_color,
              onPageChanged: (value) {
                // debugPrint('Page changed: $value');
              },
              autoPlayInterval: 3000,
              isLoop: sliderList.length == 1 ? false : true,
              children: [
                for (var items in sliderList)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      items.image!.toString(),
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          height: 180,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/loading.gif"),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/loading.gif"),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          )
        : Container();
  }

  Widget ticketNextUiLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 5), // Edge padding
      itemCount: ticket_next_events.length,
      itemBuilder: (context, index) {
        final event = ticket_next_events[index];
        EmbedInfo? embedInfo;

        if (event.is_video == 1 &&
            event.video_url != null &&
            event.video_url!.isNotEmpty) {
          try {
            Uri uri = Uri.parse(event.video_url.toString());
            String otp = uri.queryParameters['otp']?.toString() ?? "";
            String playbackInfo =
                uri.queryParameters['playbackInfo']?.toString() ?? "";

            if (otp.isNotEmpty && playbackInfo.isNotEmpty) {
              embedInfo = EmbedInfo.streaming(
                otp: otp,
                playbackInfo: playbackInfo,
              );
            }
          } catch (e) {
            print("Video parsing error: $e");
          }
        }

        return Container(
          margin: const EdgeInsets.only(top: 5),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            child: Column(
              children: [
                if (event.is_video == 1 && !event.isPlayingIcons)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: embedInfo != null
                        ? VdoPlayer(
                            embedInfo: embedInfo,
                            onPlayerCreated: (VdoPlayerController controller) {
                              setState(() {});
                            },
                            controls: true,
                            onError: (VdoError vdoError) {
                              print("VdoPlayer error: $vdoError");
                            },
                          )
                        : const Center(child: CircularProgressIndicator()),
                  )
                else
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          eventImageLoading(event.image, event.bookingAllow),
                          // if (event.is_video == 1 && event.isPlayingIcons)
                          //   InkWell(
                          //     onTap: () {
                          //       setState(() {
                          //         // event.isPlayingIcons = false;
                          //       });
                          //     },
                          //     child: SizedBox(
                          //       height: 40,
                          //       child: Image.asset("assets/ic_play.png"),
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                Container(
                  color: app_colorSecondary,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        event.eventname.toString(),
                        style: const TextStyle(
                          color: app_theam,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 2,
                    right: 5,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                "assets/calendar_outlined.png",
                              ),
                            ),
                          ),
                          Text(event.date ?? ""),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.location_on_outlined, size: 20),
                          ),
                          Text(event.district ?? ""),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: event.bookingAllow == 0
                            ? () {
                                showCommonToast(
                                  context,
                                  "",
                                  event.closedMessage ?? "",
                                );
                              }
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookNowPage(eventId: event.id!),
                                  ),
                                );
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: event.bookingAllow != 0
                                ? gradient_btn_lift
                                : gradient_btn_lift_disabled,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          height: 45,
                          child: const Center(
                            child: Text(
                              'Book Now',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(height: 45, width: 1.5, color: Colors.white),

                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EventDetailsPage(
                                context,
                                eventId: event.eventId!.toInt(),
                                flag: 1,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: event.bookingAllow != 0
                                ? gradient_btn_rigth
                                : gradient_btn_lift_disabled,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          height: 45,
                          child: const Center(
                            child: Text(
                              'Details',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  checkingLocation() async {
    var respons =
        await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return showLocationAlerts(state: stateId, city: districtId);
              },
            )
            as Map<String, Object>;

    print("respons $respons");

    try {
      var name = await DBHelper().getLoginSubDB("district_name");
      districtId = await DBHelper().getLoginSubDB("districtId");
      stateId = await DBHelper().getLoginSubDB("stateId");

      print("the name district_name  $name districtId $districtId");
      district_name = name.toString();

      provider.getDashboard(userIndexId, stateId, districtId);

      // await initOneSignal();

      setState(() {});
    } catch (e) {
      print("My res err " + e.toString());
    }

    await checkingGpsSearch();
  }

  var selectEventFilter = 1;

  Widget selectBottomView(String tab) {
    var paddingAll = 10.0;
    return tab == "0"
        ? InkWell(
            onTap: () {
              _currentIndex = 0;
              provider.getDashboard(
                userIndexId.toString(),
                stateId.toString(),
                districtId.toString(),
              );
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(paddingAll),

              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) =>
                    (_currentIndex == 0
                            ? app_gradient
                            : home_bottom_text_gradient)
                        .createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      child: Image.asset("assets/dash_bottom_home.png"),
                    ),
                    Text(
                      "Home",
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : tab == "1"
        ? InkWell(
            onTap: () {
              _currentIndex = 1;
              selectEventFilter = 1;
              provider.getDashboardEvent(
                userIndexId.toString(),
                stateId.toString(),
                districtId.toString(),
                lat,
                longs,
                selectEventFilter,
              );
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(paddingAll),

              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) =>
                    (_currentIndex == 1
                            ? app_gradient
                            : home_bottom_text_gradient)
                        .createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      child: Image.asset("assets/dash_bottom_ticket.png"),
                    ),
                    Text(
                      "TicketNXT",
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : tab == "2"
        ? InkWell(
            onTap: () {
              _currentIndex = 2;
              _scrollToTop();
              provider.getShopServices(isServices);

              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(paddingAll),

              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) =>
                    (_currentIndex == 2
                            ? app_gradient
                            : home_bottom_text_gradient)
                        .createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      child: Image.asset("assets/dash_bottom_shop.png"),
                    ),
                    Text(
                      "Shop Nearby",
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              _currentIndex = 3;
              provider.getBillPay();
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(paddingAll),

              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) =>
                    (_currentIndex == 3
                            ? app_gradient
                            : home_bottom_text_gradient)
                        .createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      child: Image.asset("assets/dash_bottom_billpay.png"),
                    ),
                    Text(
                      "BillpayNXT",
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void showEventAlerts() {
    showDialog(
      barrierDismissible: true,
      context: context,

      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        gradient: app_gradient,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Filter By",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          InkWell(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 26,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                selectEventFilter = 1;
                                setState(() {});

                                print(" select $selectEventFilter");
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    selectEventFilter == 1
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off,
                                    color: selectEventFilter == 1
                                        ? app_theam
                                        : Colors.grey,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "All Events",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectEventFilter = 2;
                                });
                                print(" select $selectEventFilter");
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    selectEventFilter == 2
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off,
                                    color: selectEventFilter == 2
                                        ? app_theam
                                        : Colors.grey,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Future Events",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectEventFilter = 3;
                                });
                                print(" select $selectEventFilter");
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    selectEventFilter == 3
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off,
                                    color: selectEventFilter == 3
                                        ? app_theam
                                        : Colors.grey,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Past Events",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // back
                              Navigator.of(context).pop();

                              provider.getDashboardEvent(
                                userIndexId.toString(),
                                stateId.toString(),
                                districtId.toString(),
                                lat,
                                longs,
                                selectEventFilter,
                              );

                              print(" select $selectEventFilter");
                            },
                            child: Container(
                              width: 120,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                gradient: app_gradient,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              padding: EdgeInsets.all(10),

                              child: Text(
                                "Apply",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  checkingGpsSearch() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (!serviceEnabled || permission == LocationPermission.denied) {
      showAlertDialog();
    } else {
      String latitude = await DBHelper().getLocationDetailsDB(true);

      if (latitude != "" ||
          latitude != "0.0" ||
          latitude != "null" ||
          latitude != null) {
        // if (isSerach) {
        //   // Navigator.of(context).pushNamed(roots);
        //   // checkingLogin(roots);
        // } else {
        Position position = await _getGeoLocationPosition();

        await DBHelper().saveLocationDetailsDB(
          position.latitude,
          position.longitude,
        );

        print("ammu location demo " + position.latitude.toString());
      }
      latitude = await DBHelper().getLocationDetailsDB(true);
      print("ammu location test latitude " + latitude.toString());

      setState(() {
        // _isLoading = false;
      });
    }
  }

  String confirmBtn_details = "Continue";

  Future<void> showAlertDialog() async {
    Widget yesButton = TextButton(
      child: Text(confirmBtn_details),
      onPressed: () async {
        confirmBtn_details = "Retry Again";

        setState(() {});

        Position position = await _getGeoLocationPosition();

        print("post late -  " + position.latitude.toString());

        if (await DBHelper().saveLocationDetailsDB(
          position.latitude,
          position.longitude,
        )) {
          setState(() {
            var location = '${position.latitude} ';
            print("the locationdata is " + location.toString());
            setState(() {
              // _isLoading = false;
            });
          });
          Navigator.pop(context);
          // checkingLogin(roots);
        } else {
          ShowToastdur(
            context,
            "Location not getting so please wait some time",
          );
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sorry!"),
      content: const Text(
        "Allow location to get the current location to identify the nearest services .",
      ),
      actions: [
        // opction,
        yesButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // context1 = context;
        return StatefulBuilder(
          builder: (context, setState) {
            return alert;
          },
        );
      },
    );
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    print("my response 0 " + serviceEnabled.toString());

    if (!serviceEnabled) {
      var respons = await await Geolocator.openLocationSettings();

      print("my response 1 " + respons.toString());

      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      print("my response 2 " + permission.toString());
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print("my response 3 " + permission.toString());
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // if (serviceEnabled) {
    //   // back
    //   Navigator.of(context).pop();
    // }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low, // Lower accuracy loads much faster
        distanceFilter: 100,
      ),
    );
  }
}

class TempDashboardLoading extends StatelessWidget {
  const TempDashboardLoading({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: 180,

            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          ),

          ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // var data = _operaterList[index];
              return Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                padding: EdgeInsets.all(5),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: 200,
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(bottom: 5),
                      ),

                      Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,

                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Colors.grey,
                              ),
                              color: Colors.grey,
                            ),

                            margin: EdgeInsets.all(5),
                          ),
                          Container(
                            height: 80,
                            width: 80,

                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Colors.grey,
                              ),
                              color: Colors.grey,
                            ),

                            margin: EdgeInsets.all(5),
                          ),
                          Container(
                            height: 80,
                            width: 80,

                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Colors.grey,
                              ),
                              color: Colors.grey,
                            ),

                            margin: EdgeInsets.all(5),
                          ),
                          Container(
                            height: 80,
                            width: 80,

                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Colors.grey,
                              ),
                              color: Colors.grey,
                            ),

                            margin: EdgeInsets.all(5),
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.grey,
                          ),
                          color: Colors.grey,
                        ),
                        margin: EdgeInsets.only(top: 5),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
