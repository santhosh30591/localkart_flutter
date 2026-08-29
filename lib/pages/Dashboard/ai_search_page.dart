import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/ai/ai_directory_model.dart';
import 'package:localkart/model/ai/ai_home.dart';
import 'package:localkart/model/dashboard/servicesDetailsModel.dart';
import 'package:localkart/model/dashboard/todayServicesListModel.dart';
import 'package:localkart/pages/Dashboard/DayTypes/moreDetails/today_more_details.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:url_launcher/url_launcher.dart';

class AiSearchPage extends StatefulWidget {
  const AiSearchPage({Key? key}) : super(key: key);

  @override
  State<AiSearchPage> createState() => _AiSearchPageState();
}

class _AiSearchPageState extends State<AiSearchPage> {
  AiHomeDataModel? _aiData;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // const url = "https://www.localkart.app/portal/api/shopservicecategories";
      final response = await ApiClientLocalKart().httpGet(
        shopservicecategories,
      );
      final data = json.decode(response.body);

      if (data['errorCode'] == 0) {
        setState(() {
          _aiData = AiHomeDataModel.fromJson(data);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching AI search data: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: app_gradient,
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colors: [
          //     Color(0xFF6B1B9A), // Purple
          //     Color(0xFF1976D2), // Blue
          //   ],
          // ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // ChatGPT Button
              _buildChatGPTButton(),

              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : _aiData == null
                    ? const Center(
                        child: Text(
                          "Error loading content",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 100),
                            // Title
                            Text(
                              _aiData?.title ??
                                  "What are you looking for today?",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Subtitle
                            Text(
                              _aiData?.subtitle ??
                                  "Tap a suggestion, type or speak to explore.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Horizontal Suggestion Rows
                            _buildHorizontalSections(),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
              ),

              // Bottom Input
              _buildBottomSearch(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalSections() {
    return Column(
      children: [
        if (_aiData?.shop != null && _aiData!.shop!.isNotEmpty)
          _buildHorizontalRow(_aiData!.shop!),
        const SizedBox(height: 20),
        if (_aiData?.service != null && _aiData!.service!.isNotEmpty)
          _buildHorizontalRow(_aiData!.service!),
        const SizedBox(height: 20),
        if (_aiData?.offer != null && _aiData!.offer!.isNotEmpty && isLiveMode)
          _buildHorizontalRow(_aiData!.offer!),
      ],
    );
  }

  Widget _buildHorizontalRow(List<AiItem> items) {
    return SizedBox(
      height: 50, // Height of the chip container
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _buildItemChip(items[index]),
          );
        },
      ),
    );
  }

  // Inside _AiSearchPageState
  void _onCategoryClick(AiItem item) async {
    // 1. Show the loading screen immediately
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => AiLoadingScreen(item)));
  }

  Widget _buildItemChip(AiItem item) {
    return InkWell(
      onTap: () {
        _onCategoryClick(item);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white24, width: 0.5),
        ),
        child: Text(
          item.name ?? "",
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildBottomSearch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(left: 20, right: 8),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Start typing...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),

          InkWell(
            onTap: () {
              if (_searchController.text.length == 0) {
                showCommonToast(context, "", "Please enter search text");
              } else {
                AiItem item = AiItem();
                item.name = _searchController.text.toString();
                item.type = "search";
                item.id = "22";
                _onCategoryClick(item);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF6B56D3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildChatGPTButton() {
  return InkWell(
    onTap: () async {
      final url = Uri.parse("https://chatgpt.com");
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Click here to go to ChatGPT",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(width: 8),
          Icon(Icons.north_east, color: Colors.white, size: 14),
        ],
      ),
    ),
  );
}

class AiLoadingScreen extends StatefulWidget {
  AiItem item;

  AiLoadingScreen(this.item);

  @override
  State<AiLoadingScreen> createState() => _AiLoadingScreenState();
}

class _AiLoadingScreenState extends State<AiLoadingScreen>
    with TickerProviderStateMixin {
  late GifController _controller;
  late AiItem item;

  var _isLoading = true;

  var errorMsg = "";
  var isRetry = false;

  @override
  void initState() {
    super.initState();
    // Initialize controller. Duration should match your GIF length approximately.
    _controller = GifController(vsync: this);
    item = widget.item;
    _ai_dir_result = [];
    _ai_api_result = [];
    _fetchData(item);
    // Listen for animation status
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("finished");
        _ai_dir_result = _ai_api_result;
        if (_ai_api_result!.length == 0) {
          errorMsg =
              "Sorry, I'm unable to provide the requested\ninformation at the moment.";
          isRetry = true;
        } else {
          errorMsg = "";
          // Navigator.pop(context);
        }

        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFFAD1457)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _ai_dir_result!.length != 0
            ? actionBarAiBGChange(
                item.name.toString(),
                context,
                Container(
                  height: double.infinity,
                  width: double.infinity,

                  child: _buildResultsList(_ai_dir_result),
                ),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(top: 80, child: _buildChatGPTButton()),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Use Gif widget instead of Image.asset
                      errorMsg.length != 0
                          ? Container(
                              child: Text(
                                errorMsg,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Gif(
                              image: const AssetImage(
                                "assets/ic_processing_true.gif",
                              ),
                              controller: _controller,
                              autostart: Autostart.once,
                              // Plays only one time
                              placeholder: (context) =>
                                  const CircularProgressIndicator(),
                              onFetchCompleted: () {
                                // Optional: adjust duration based on actual frames
                                _controller.duration = const Duration(
                                  milliseconds: 12000,
                                );
                                _controller.forward();
                              },
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  Positioned(
                    bottom: 1,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        // Updated opacity syntax
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: 15,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    child: isRetry
                        ? InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 35),
                              child: Image.asset(
                                "assets/ic_retry.png",
                                // width: 140,
                                height: 100,
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(bottom: 45),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              width: 65,
                              height: 65,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                // color: Colors.black12,
                                color: Colors.black.withValues(alpha: 0.15),
                                // color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/ic_ai_circle_loading.gif",
                                width: 45,
                                height: 45,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildResultsList(List<ResultMore>? _ai_dir_result) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      itemCount: _ai_dir_result!.length,
      itemBuilder: (context, index) {
        final result = _ai_dir_result[index];

        var phone = "";
        var logo = "";
        var description = "";
        if (item.type == "Today" ||
            item.type == "Weekly" ||
            item.type == "MEGASALES" ||
            item.type == "Festival") {
          phone = _ai_dir_result![index].phone.toString();
          description = result.offerHeading.toString();
          logo = result.logo.toString();
        } else {
          logo = result.logo.toString();
          phone = _ai_dir_result![index].call.toString();
          description = result.address.toString();
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2652).withOpacity(0.2),
            // Dark blue card background
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white24, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Upper part with Title and Address ---
              Padding(
                padding: const EdgeInsets.all(1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // crossAxisAlignment: sta,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.name ?? "Name",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                logo == ""
                                    ? Container()
                                    : Container(
                                        height: 40,
                                        width: 40,
                                        margin: EdgeInsets.only(right: 8),
                                        padding: EdgeInsets.all(3),
                                        child: ClipOval(
                                          child: Image.network(
                                            logo,
                                            width: 100,
                                            height: 100,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    width: 100,
                                                    height: 100,
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                                  );
                                                },
                                            // Triggers while image is loading (Optional)
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return const SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Checkmark badge in top right
                    result.isVerify == "0"
                        ? Container()
                        : Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFAD1457),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                ), // Pink/Purple accent
                                // borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                  ],
                ),
              ),

              // --- Bottom Action Buttons ---
              Container(
                // height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    // Call Button
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (item.type == "search") {
                            final Uri launchUri = Uri(
                              scheme: 'tel',
                              path: phone,
                            );
                            await launchUrl(launchUri);
                          } else {
                            final Uri launchUri = Uri(
                              scheme: 'tel',
                              path: phone,
                            );
                            await launchUrl(launchUri);
                          }
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: gradient_btn_lift,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.call_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Call",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Vertical divider line
                    Container(width: 1, color: Colors.white12),
                    // View Button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          //

                          if (item.type == "Today" ||
                              item.type == "Weekly" ||
                              // item.type == "MEGASALES" ||
                              item.type == "Festival") {
                            TodayServiceListModel resultToday =
                                TodayServiceListModel();
                            resultToday.errorCode = 0;
                            resultToday.message = "";
                            List<Result>? results = <Result>[];

                            for (int i = 0; i < _ai_dir_result.length; i++) {
                              var models = Result(
                                shopIndexId: _ai_dir_result[i].shopIndexId
                                    .toString(),
                                type: _ai_dir_result[i].type.toString(),
                                postIndexId: _ai_dir_result[i].postIndexId,
                                latitude: _ai_dir_result[i].latitude.toString(),
                                longitude: _ai_dir_result[i].longitude
                                    .toString(),
                                name: _ai_dir_result[i].name.toString(),
                                isSubscribed: _ai_dir_result[i].isSubscribed,
                              );

                              results.add(models);
                            }

                            resultToday.result = results;

                            viewDetails(resultToday, index);
                          } else {
                            viewMoewDetails(_ai_dir_result[index]);
                          }
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: gradient_btn_rigth,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.visibility_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "View",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void viewMoewDetails(ResultMore result) async {
    var type = result.type;

    ServiceDetailsModel model;
    model = ServiceDetailsModel();
    model.name = "" + result.name.toString();
    model.logo = "";
    model.distance = "0";
    model.distanceInt = "0";

    errorMsg = "";
    // AccessOptions acc = AccessOptions();
    setState(() {});
    // model.accessOptions = acc;
    model.description = result.description.toString();
    model.shopIndexId = result.shopIndexId.toString();
    model.type = type.toString();
    model.latitude = result.latitude.toString();
    model.longitude = result.longitude.toString();

    model.isSubscribed = result.isSubscribed.toString();
    model.shareUrl = "";
    model.isVerify = result.isVerify.toString();
    model.viewCount = "0";
    model.averageRating = "0";

    await Navigator.of(
      context,
    ).pushNamed(root_services_more_details, arguments: model);

    _fetchData(item);

    setState(() {});
  }

  List<ResultMore>? _ai_api_result = [];
  List<ResultMore>? _ai_dir_result = [];

  void _fetchData(AiItem item) async {
    var userid = await DBHelper().getUserId();
    var districtId = await DBHelper().getLoginSubDB("districtId");
    var stateId = await DBHelper().getLoginSubDB("stateId");

    var postData = Map<String, Object>();
    _isLoading = true;

    String url = "" + aidirectorylist;

    // setState(() {});
    var type = item.type;

    print("offerssss " + item.name.toString());

    if (item.type == "Today" ||
        item.type == "Weekly" ||
        item.type == "MEGASALES" ||
        item.type == "Festival") {
      url = aiofferslist;
      postData["userIndexId"] = "" + userid;
      postData["id"] = item.id.toString();
      postData["districtId"] = "" + districtId;
    } else {
      if (type == "Services") {
        type = "Service";
        postData["userIndexId"] = "" + userid;
        postData["catId"] = item.id.toString();
        postData["type"] = item.type.toString();
        postData["cityId"] = "" + districtId;
      } else if (type == "search") {
        url = aisearch;
        postData["userIndexId"] = "" + userid;
        postData["searchText"] = item.name.toString();
        postData["stateId"] = stateId.toString();
        postData["districtId"] = districtId.toString();
      } else {
        postData["userIndexId"] = "" + userid;
        postData["catId"] = item.id.toString();
        postData["type"] = item.type.toString();
        postData["cityId"] = "" + districtId;
      }
    }
    var response = await ApiClientLocalKart().httpPost(postData, url);
    final data = json.decode(response.body);

    if (data['errorCode'] == 0) {
      var _aiDirectoryModel = AiDirectoryModel.fromJson(data);
      _ai_api_result = _aiDirectoryModel.result;
    }
    setState(() => _isLoading = false);
  }

  void viewDetails(TodayServiceListModel resultToday, int index) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            TodayMoreDetails(result: resultToday, indexs: index),
      ),
    );
    _fetchData(item);
  }
}
