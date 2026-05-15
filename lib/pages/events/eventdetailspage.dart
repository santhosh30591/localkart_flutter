import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';
import 'package:localkart/Api/provider/event_provider.dart';
import 'package:localkart/pages/Dashboard/manage_business/ticketNxt/bookings.dart';
import 'package:localkart/pages/Dashboard/manage_business/ticketNxt/summary.dart';
import 'package:localkart/pages/events/bookNow.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  EventDetailsPage(
    eventsListing, {
    Key? key,
    required this.eventId,
    required this.flag,
  }) : super(key: key);
  int eventId;
  int flag;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState(eventId);
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  _EventDetailsPageState(this.eventId);

  int eventId;
  var eventDetails = {};
  bool isLoaded = true;

  @override
  void initState() {
    getEventDetails(eventId);
    super.initState();
  }

  getEventDetails(id) async {
    var response = await EventsProvider().getEventDetails(id);
    if (response != null) {}
    setState(() {
      eventDetails = response;
      isLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      "Event Details",
      context,
      Scaffold(
        body: isLoaded
            ? const Center(child: CircularProgressIndicator())
            : eventDetails["errorCode"] == 1
            ? Center(
                child: Text(
                  eventDetails["message"].toString(),
                  style: TextStyle(fontSize: 15),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Image.network(
                              eventDetails["result"]["image"],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;

                                    return Container(
                                      height: 160,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/loading.gif",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },

                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 160,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/loading.gif"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      color: app_colorSecondary,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Html(
                          data: '${eventDetails['result']['eventname'] ?? ""}',
                          style: {
                            "body": Style(
                              color: app_theam,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                            ),
                          },
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 16,
                                width: 16,
                                child: Image.asset(
                                  'assets/calendar_outlined.png',
                                ),
                              ),
                              Text(" ${eventDetails["result"]["date"] ?? ""}"),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.black,
                                size: 16,
                              ),
                              Text(
                                " ${eventDetails["result"]["start_time"] ?? ""} to ${eventDetails["result"]["end_time"] ?? ""}",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 3,
                      ),
                      color: app_colorSecondary,
                      width: MediaQuery.of(context).size.width,
                      child: Html(
                        data:
                            '${eventDetails['result']['description_title'] ?? ""}',
                        style: {
                          "body": Style(
                            color: app_theam,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.bold,
                          ),
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        children: [
                          Html(
                            data:
                                "${eventDetails["result"]["description"] ?? ""}",
                            style: {
                              // Force header cells to align center
                              "th": Style(
                                padding: HtmlPaddings.all(3),

                                // Adds 12px padding inside header cells
                                textAlign: TextAlign.center,
                                // verticalAlign: VerticalAlign
                                //     .middle, // Ensures vertical centered alignment
                              ),
                              // Force data cells to align left
                              "td": Style(
                                padding: HtmlPaddings.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ), // Custom padding

                                textAlign: TextAlign.center,
                                verticalAlign: VerticalAlign.middle,
                              ),
                            },
                            extensions: [
                              // Put TagWrapExtension BEFORE TableHtmlExtension
                              TagWrapExtension(
                                tagsToWrap: {"table"},
                                builder: (child) {
                                  return Align(
                                    alignment: Alignment.center,
                                    // Aligns child strictly to the horizontal center
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: child,
                                    ),
                                  );
                                },
                              ),
                              const TableHtmlExtension(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 3,
                      ),
                      color: app_colorSecondary,
                      width: MediaQuery.of(context).size.width,
                      child: Html(
                        data: '${eventDetails['result']['notes_title'] ?? ""}',
                        style: {
                          "body": Style(
                            color: app_theam,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.bold,
                          ),
                        },
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Html(
                              data: eventDetails["result"]["notes"] ?? "",

                              style: {
                                // Force header cells to align center
                                "th": Style(
                                  padding: HtmlPaddings.all(3),

                                  // Adds 12px padding inside header cells
                                  textAlign: TextAlign.center,
                                  // verticalAlign: VerticalAlign
                                  //     .middle, // Ensures vertical centered alignment
                                ),
                                // Force data cells to align left
                                "td": Style(
                                  padding: HtmlPaddings.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ), // Custom padding

                                  textAlign: TextAlign.center,
                                  verticalAlign: VerticalAlign.middle,
                                ),
                              },
                              extensions: [
                                // Put TagWrapExtension BEFORE TableHtmlExtension
                                TagWrapExtension(
                                  tagsToWrap: {"table"},
                                  builder: (child) {
                                    return Align(
                                      alignment: Alignment.center,
                                      // Aligns child strictly to the horizontal center
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: child,
                                      ),
                                    );
                                  },
                                ),
                                const TableHtmlExtension(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 10),
                      color: app_colorSecondary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Tickets",
                            style: TextStyle(
                              color: app_theam,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (
                          int i = 0;
                          i < eventDetails["result"]["ticket"].length;
                          i++
                        )
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          eventDetails["result"]["ticket"][i]["name"] ??
                                              "",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        SizedBox(
                                          child: Text(
                                            eventDetails["result"]["ticket"][i]["admit_person"] ??
                                                "",
                                            style: const TextStyle(
                                              overflow: TextOverflow.clip,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "₹ ${eventDetails["result"]["ticket"][i]["price"] ?? ""} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                if (eventDetails["result"]["ticket"][i]["description"] ==
                                    null)
                                  ...[]
                                else if (eventDetails["result"]["ticket"][i]["description"]
                                        .length !=
                                    0) ...[
                                  for (
                                    int j = 0;
                                    j <
                                        eventDetails["result"]["ticket"][i]["description"]
                                            .length!;
                                    j++
                                  )
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              "${eventDetails["result"]["ticket"][i]["description"][j].toString() ?? ""}",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),

                        SizedBox(height: 2),
                        Container(
                          color: app_colorSecondary,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Venu ",
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  launch(eventDetails["result"]["map"]);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.location_on_outlined, size: 18),
                                    Text("Directions"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "${eventDetails["result"]["address1"] ?? ""},"
                                    .replaceAll(",,", ","),
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "${eventDetails["result"]["address2"] ?? ""},"
                                    .replaceAll(",,", ","),
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "${eventDetails["result"]["address3"] ?? ""},"
                                    .replaceAll(",,", ","),
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "${eventDetails["result"]["district"] ?? ""},"
                                    .replaceAll(",,", ","),
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "${eventDetails["result"]["state_name"] ?? ""} - ${eventDetails["result"]["pincode"] ?? ""}.",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),

                        if (eventDetails["result"]["amenities"].length !=
                            0) ...[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 5),
                            color: app_colorSecondary,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Amenities",
                                  style: TextStyle(
                                    color: app_theam,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 5),

                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: Wrap(
                              children: <Widget>[
                                for (
                                  int i = 0;
                                  i <
                                      eventDetails["result"]["amenities"]
                                          .length;
                                  i++
                                )
                                  Container(
                                    // color: Colors.blue[100 * (index % 9)],
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        top: 5,
                                        bottom: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),

                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(
                                            eventDetails["result"]["amenities"][i]["icon"] ??
                                                "",
                                            width: 25,
                                            height: 25,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            eventDetails["result"]["amenities"][i]["description"],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                        if (eventDetails["result"]["prohibiteditems"].length !=
                            0) ...[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 5),
                            color: app_colorSecondary,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Prohibiteditems",
                                  style: TextStyle(
                                    color: app_theam,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 5),
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: Wrap(
                              children: <Widget>[
                                for (
                                  int i = 0;
                                  i <
                                      eventDetails["result"]["prohibiteditems"]
                                          .length;
                                  i++
                                )
                                  Container(
                                    // color: Colors.blue[100 * (index % 9)],
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        top: 5,
                                        bottom: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),

                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(
                                            eventDetails["result"]["prohibiteditems"][i]["icon"] ??
                                                "",
                                            width: 25,
                                            height: 25,
                                          ),
                                          SizedBox(width: 5),
                                          HtmlWidget(
                                            eventDetails["result"]["prohibiteditems"][i]["description"],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: isLoaded
            ? const Center(child: CircularProgressIndicator())
            : eventDetails["errorCode"] == 1
            ? Container(height: 1)
            : Container(
                height: 45,
                color: Colors.white,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: widget.flag == 1
                            ? () {
                                Navigator.pop(context);
                              }
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventSummaryPage(id: eventId.toInt()),
                                  ),
                                );
                              },
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.only(right: 1),
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            gradient: gradient_btn_lift,
                          ),
                          child: Center(
                            child: widget.flag == 1
                                ? const Text(
                                    ' Back',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const Text(
                                    'Summary',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                      widget.flag == 1
                          ? InkWell(
                              onTap:
                                  eventDetails["result"]["booking_allow"] == 0
                                  ? () {
                                      showCommonToast(
                                        context,
                                        "",
                                        eventDetails["result"]["closed_message"],
                                      );
                                    }
                                  : () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => BookNowPage(
                                            eventId: eventId.toInt(),
                                          ),
                                        ),
                                      );
                                    },
                              child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width / 2,
                                decoration: BoxDecoration(
                                  gradient:
                                      eventDetails["result"]["booking_allow"] !=
                                          0
                                      ? gradient_btn_rigth
                                      : gradient_btn_lift_disabled,
                                ),
                                child: const Center(
                                  child: Text(
                                    ' Book now ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EventBookingsListPage(
                                      eventId: widget.eventId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width / 2,
                                decoration: BoxDecoration(
                                  gradient: gradient_btn_rigth,
                                ),
                                child: const Center(
                                  child: Text(
                                    ' Bookings',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
