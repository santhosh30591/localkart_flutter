import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';

class MyRewardsPage extends StatefulWidget {
  static const routeName = '/myrewards';

  MyRewardsPage({Key? key}) : super(key: key);

  @override
  State<MyRewardsPage> createState() => _MyRewardsPageState();
}

class _MyRewardsPageState extends State<MyRewardsPage> {
  Future getBookingsList() async {
    var userid = await DBHelper().getLoginSubDB("Id");
    var type = "" + await DBHelper().getLoginDB("type");

    if (type == "Services") {
      type = "Service";
    }

    var url =
        "$subBase/myrewards?userId=$userid"
            "&type=" +
        type;
    var responces = await ApiClientLocalKart().httpGet(url);

    return json.decode(responces.body);
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      "My Rewards",
      context,
      FutureBuilder(
        future: getBookingsList(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.hasData) {
            var data = snapshot.data['result'];
            return snapshot.data['result'] == null
                ? Center(child: Text(snapshot.data['Message']))
                : ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TicketWidget(ticketData: data[index]),
                      );
                    },
                  );
          }
          return const Center(child: CupertinoActivityIndicator());
        },
      ),
    );
  }
}

class TicketWidget extends StatefulWidget {
  TicketWidget({this.ticketData, Key? key}) : super(key: key);

  var ticketData;

  @override
  _TicketWidgetState createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  TicketReturs(ticketnumbers) {
    var convertvalue = int.parse(ticketnumbers);
    var value = "0 Ticket";
    if (convertvalue == 0 || convertvalue < 0) {
      value = ticketnumbers + " Ticket";

      return value;
    } else {
      value = ticketnumbers + " Tickets";

      return value;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    // final double screenHeight = mediaQueryData.size.height;
    final double screenWidth = mediaQueryData.size.width - 20;
    return GestureDetector(
      onTap: () {
        Map<String, String> roots = {
          "id": widget.ticketData['id'].toString() ?? "",
        };
        Navigator.of(context).pushNamed(view_my_bookings, arguments: roots);
      },
      child: SingleChildScrollView(
        child: Container(
          // padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('assets/ticketImage.png'),
            //   fit: BoxFit.fill,
            // ),
            borderRadius: BorderRadius.all(Radius.circular(10)),

            color: home_service_tab_bg,
          ),
          width: screenWidth - 20,
          // height: screenHeight / 4.6,
          // color: Colors.grey,
          child: Row(
            children: [
              Container(
                width: screenWidth / 3.5,

                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    // Change 20.0 to your desired radius
                    bottomLeft: Radius.circular(
                      10.0,
                    ), // Change 20.0 to your desired radius
                  ),
                  child: Image.network(
                    widget.ticketData['reward_image'] ?? "",
                    fit: BoxFit.cover,
                    loadingBuilder:
                        (
                          BuildContext context,
                          Widget child,
                          ImageChunkEvent? loadingProgress,
                        ) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                    errorBuilder:
                        (
                          BuildContext context,
                          Object exception,
                          StackTrace? stackTrace,
                        ) {
                          return const Icon(Icons.error);
                        },
                  ),
                ),
              ),
              // const SizedBox(width: 10),
              DottedVerticalLineWidget(
                height: 145,
                strokeWidth: 2.0,
                color: const Color.fromARGB(
                  255,
                  218,
                  218,
                  218,
                ), // Specify the desired color of the line
              ),
              // const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: SizedBox(
                  width: screenWidth / 1.50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth / 1.8,
                        child: Text(
                          widget.ticketData['shop_name'] ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: app_theam,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // const Padding(
                          //   padding: EdgeInsets.all(2.0),
                          //   child: Icon(
                          //     Icons.calendar_month_outlined,
                          //     size: 18,
                          //   ),
                          // ),
                          Text(
                            widget.ticketData['type'] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        widget.ticketData['title'] ?? "",
                        maxLines: 2,

                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Valid Till " + widget.ticketData['expiry'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    width: 1,
                                    color: app_theam,
                                  ),
                                ),
                                margin: EdgeInsets.all(2),
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Text(
                                  widget.ticketData['validupto'] ?? " 0",
                                  style: TextStyle(
                                    color: app_theam[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: app_theam,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1, color: app_theam),
                            ),

                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5,
                            ),
                            child: Text(
                              "View",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedVerticalLineWidget extends StatelessWidget {
  final double height;
  final double strokeWidth;
  final Color color;

  DottedVerticalLineWidget({
    this.height = 100.0,
    this.strokeWidth = 2.0,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(2.0, height),
      painter: DottedVerticalLinePainter(
        strokeWidth: strokeWidth,
        color: color,
      ),
    );
  }
}

class DottedVerticalLinePainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  DottedVerticalLinePainter({
    this.strokeWidth = 2.0,
    this.color = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double startX = size.width / 2;
    final double endY = size.height;

    for (double y = 0; y < endY; y += 7.0) {
      canvas.drawLine(Offset(startX, y), Offset(startX, y + 2.0), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
