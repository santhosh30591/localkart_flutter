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

    var url = "$subBase/myrewards?userId=$userid&type=$type";
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
    const double cardHeight = 145.0;

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    // final double screenHeight = mediaQueryData.size.height;
    final double screenWidth = mediaQueryData.size.width - 20;
    return GestureDetector(
      onTap: () {
        widget.ticketData['isManaged'] = false;
        Navigator.of(
          context,
        ).pushNamed(view_my_rewards, arguments: widget.ticketData);
        // Navigator.of(context).pushNamed(view_my_bookings, arguments: roots);
      },
      child: buildTicketCard(context, screenWidth, widget),
    );
  }
}

Widget buildTicketCard(BuildContext context, double screenWidth, widget) {
  // Define a consistent height for the ticket card layout
  const double cardHeight = 145.0;

  return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: home_service_tab_bg,
    ),
    width: screenWidth - 20,
    height: cardHeight, // Fixes the layout bounds error
    child: Row(
      children: [
        // 1. Left Side: Image Content
        SizedBox(
          width: screenWidth / 3.5,
          height: cardHeight,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
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

        // 2. Middle: Vertical Dotted Line
        DottedVerticalLineWidget(
          height: cardHeight,
          strokeWidth: 2.0,
          color: const Color.fromARGB(255, 218, 218, 218),
        ),

        // 3. Right Side: Dynamically sized Details Area
        // Replaced static SizedBox width with Expanded to prevent horizontal text overflow flags
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Info Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ticketData['shop_name'] ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: app_theam,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.ticketData['type'] ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.ticketData['title'] ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                // Safely pushes bottom content to the baseline of our 145px boundary
                const Spacer(),

                // Bottom Action & Validity Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Valid Till ${widget.ticketData['expiry'] ?? ''}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1, color: app_theam),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            child: Text(
                              widget.ticketData['validupto'] ?? "0",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: app_theam, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Button Element
                    Container(
                      decoration: BoxDecoration(
                        color: app_theam,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: app_theam),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      child: const Text(
                        "View",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
  );
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
