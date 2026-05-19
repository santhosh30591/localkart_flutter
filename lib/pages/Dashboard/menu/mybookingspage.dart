import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';

class MybookingsPage extends StatefulWidget {
  static const routeName = '/myBookings';

  MybookingsPage({Key? key}) : super(key: key);

  @override
  State<MybookingsPage> createState() => _MybookingsPageState();
}

class _MybookingsPageState extends State<MybookingsPage> {
  Future getBookingsList() async {
    var userid = await DBHelper().getLoginSubDB("Id");

    var url = "$subBase/mybookings?userid=$userid";
    var responces = await ApiClientLocalKart().httpGet(url);

    return json.decode(responces.body);
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      "My Bookings",
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
                ? Center(child: Text(snapshot.data['message']))
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
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),

          decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('assets/ticketImage.png'),
            //   fit: BoxFit.fill,
            // ),
            borderRadius: BorderRadius.all(Radius.circular(10)),

            color: billpay_div_line_color,
          ),
          width: screenWidth - 20,
          // height: screenHeight / 4.6,
          // color: Colors.grey,
          child: Row(
            children: [
              SizedBox(
                width: screenWidth / 3.5,
                child: Image.network(
                  widget.ticketData['pri_image'] ?? "",
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
              const SizedBox(width: 10),
              DottedVerticalLineWidget(
                height: 140,
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
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  width: screenWidth / 1.65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth / 1.8,
                        child: Text(
                          widget.ticketData['eventname'] ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: app_theam,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.calendar_month_outlined,
                              size: 18,
                            ),
                          ),
                          Text(
                            widget.ticketData['date'] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(Icons.access_time, size: 18),
                          ),
                          Text(
                            widget.ticketData['time'] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(Icons.location_on_outlined, size: 18),
                          ),
                          Text(
                            widget.ticketData['district'] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  // child: Image.asset('assets/events.png'),
                                ),
                              ),
                              // const SizedBox(width: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.ticketData['tickets'] ?? " 0",
                                    style: TextStyle(color: app_theam),
                                  ),
                                  Text(
                                    " Tickets",
                                    style: TextStyle(color: app_theam),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Icon(Icons.arrow_forward, color: app_theam,size: 23,),
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
