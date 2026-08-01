import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';


class EventFailureScreen extends StatefulWidget {
  static const routeName = '/eventfailureScreen';

  EventFailureScreen({required this.eventid, Key? key}) : super(key: key);

  var eventid;

  @override
  State<EventFailureScreen> createState() => _EventFailureScreenState();
}

class _EventFailureScreenState extends State<EventFailureScreen> {
  @override
  void initState() {
    super.initState();
    Convert();
  }

  int id = 0;

  Convert() {
    id = int.parse(widget.eventid);
    print("ID converted " + id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      "Booking Failed",
      context,
      Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/deny.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Booking Failed",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 50,
          alignment: Alignment.center,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(gradient: app_gradient),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Try Again",
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
      ),
    );
  }
}
