import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';

class EventSucessScreen extends StatefulWidget {
  final String eventid;
  final String orderId;

  const EventSucessScreen({
    required this.eventid,
    required this.orderId,
    Key? key,
  }) : super(key: key);

  @override
  State<EventSucessScreen> createState() => _EventSucessScreenState();
}

class _EventSucessScreenState extends State<EventSucessScreen> {
  @override
  void initState() {
    super.initState();
    Convert();
  }

  int id = 0;

  String orderId = "";

  Convert() {
    print("ID converted " + widget.eventid.toString() + "orderId " + orderId);
    try {
      id = int.parse(widget.eventid.toString());
      orderId = widget.orderId.toString();
      print("ID converted " + id.toString());
    } catch (e) {
      print("ert event id error " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("event id " + widget.eventid.toString());
    return actionBarTopBottomView(
      "Event Bookings",
      context,
      Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    "assets/tick-green.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Booking Successful!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Map<String, String> roots = {"id": id.toString() ?? ""};
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(view_my_bookings, arguments: roots);

                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => EventSucessScreen(
                    //       eventid: widget.eventDetails['id'].toString(),
                    //     ),
                    //   ),
                    // );

                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => TicketDetailsScreen(id: id),
                    //   ),
                    // );
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(gradient: app_gradient),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "View Booking",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
