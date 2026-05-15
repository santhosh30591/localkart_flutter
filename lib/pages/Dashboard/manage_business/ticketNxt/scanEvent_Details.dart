// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:localkart/lib/Modules/events/api/event_provider.dart';
// import 'package:localkart/lib/Modules/events/bookNow.dart';
// import 'package:localkart/lib/Modules/events/manageEvents/bookings.dart';
// import 'package:localkart/lib/Modules/events/manageEvents/scanEventsBookings.dart';
// import 'package:localkart/lib/Modules/events/manageEvents/summary.dart';
// import 'package:localkart/lib/theams_colors.dart';
// import 'package:localkart/lib/unit/showing.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ScanAgentEventDetailsPage extends StatefulWidget {
//   ScanAgentEventDetailsPage(
//     eventsListing, {
//     Key? key,
//     required this.eventId,
//     required this.ScanUserId,
//   }) : super(key: key);
//   int eventId;
//   String ScanUserId;
//   @override
//   State<ScanAgentEventDetailsPage> createState() => _ScanAgentEventDetailsPageState(eventId);
// }
//
// class _ScanAgentEventDetailsPageState extends State<ScanAgentEventDetailsPage> {
//   _ScanAgentEventDetailsPageState(this.eventId);
//   int eventId;
//   var eventDetails = {};
//   bool isLoaded = false;
//
//   @override
//   void initState() {
//     getEventDetails(eventId);
//     super.initState();
//   }
//
//   getEventDetails(id) async {
//     var response = await EventsProvider().getEventDetails(id);
//     if (response != null) {
//       setState(() {
//         eventDetails = response;
//         isLoaded = true;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title:const Text('Event Details'),
//         ),
//         body: !isLoaded
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     // color: Colors.red,
//                     height: MediaQuery.of(context).size.height / 4.3,
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Image.network(eventDetails["result"] != null
//                             ? eventDetails["result"]["image"] ??
//                                 "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg"
//                             : "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg"),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     color: app_theam[100],
//                     height: MediaQuery.of(context).size.height / 20,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           eventDetails["result"]["eventname"] ?? "",
//                           style: const TextStyle(
//                               color: Color(0xFFe4287c),
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           child: Row(
//                             children: [
//                               const Icon(
//                                 Icons.calendar_month,
//                                 color: Colors.black,
//                                 size: 16,
//                               ),
//                               Text(" ${eventDetails["result"]["date"] ?? ""}"),
//                             ],
//                           ),
//                         ),
//                         Container(
//                             child: Row(children: [
//                           const Icon(
//                             Icons.access_time,
//                             color: Colors.black,
//                             size: 16,
//                           ),
//                           Text(
//                               " ${eventDetails["result"]["start_time"] ?? ""} to ${eventDetails["result"]["end_time"] ?? ""}")
//                         ]))
//                       ],
//                     ),
//                   ),
//                   Container(
//                     color: app_theam[100],
//                     padding:const EdgeInsets.all(8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           eventDetails["result"]["description_title"] ?? "",
//                           style:const TextStyle(
//                               color: Color(0xFFe4287c),
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     child: Column(
//                       children: [
//                         Html(
//                           data: "${eventDetails["result"]["description"]}",
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: 20),
//                     color: app_theam[100],
//                     padding: EdgeInsets.all(8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           eventDetails["result"]["notes_title"] ?? "",
//                           style:const TextStyle(
//                               color: Color(0xFFe4287c),
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     child: Row(
//                       children: [
//                         SizedBox(
//                             width: MediaQuery.of(context).size.width - 50,
//                             child: HtmlWidget(eventDetails["result"]["notes"]))
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: 20),
//                     color: app_theam[100],
//                     padding: EdgeInsets.all(8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: const [
//                         Text(
//                           "Tickets",
//                           style: TextStyle(
//                               color: Color(0xFFe4287c),
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         for (int i = 0;
//                             i < eventDetails["result"]["ticket"].length;
//                             i++)
//                           Container(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               // crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                     child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                       Text(
//                                         eventDetails["result"]["ticket"][i]
//                                                 ["name"] ??
//                                             "",
//                                         style: const TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width -
//                                                 100,
//                                         child: Text(
//                                             eventDetails["result"]["ticket"][i]
//                                                     ["description"] ??
//                                                 "",
//                                             style: const TextStyle(
//                                                 fontSize: 10,
//                                                 overflow: TextOverflow.clip)),
//                                       ),
//                                      const Divider(
//                                           thickness: 0.0, color: Colors.black)
//                                     ])),
//                                 Container(
//                                   child: Column(
//                                     children: [
//                                       Text("₹ " +
//                                           eventDetails["result"]["ticket"][i]
//                                               ["price"])
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         Container(
//                           color: app_theam[100],
//                           padding:const EdgeInsets.all(8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Venu  ",
//                                 style: TextStyle(
//                                     color: Color(0xFFe4287c),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   launch(eventDetails["result"]["map"]);
//                                 },
//                                 child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: const [
//                                       Icon(
//                                         Icons.location_on_outlined,
//                                         color: Colors.black,
//                                         size: 16,
//                                       ),
//                                       Text("Directions"),
//                                     ]),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.all(8),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(eventDetails["result"]["address1"] ?? "",
//                                   style: const TextStyle(fontSize: 12)),
//                               Text(eventDetails["result"]["address2"] ?? "",
//                                   style: const TextStyle(fontSize: 12)),
//                               Text(eventDetails["result"]["address3"] ?? "",
//                                   style: const TextStyle(fontSize: 12)),
//                               Text(eventDetails["result"]["district"] ?? "",
//                                   style: const TextStyle(fontSize: 12)),
//                               Text(
//                                   "${eventDetails["result"]["state_name"] ?? ""} - ${eventDetails["result"]["pincode"] ?? ""}",
//                                   style: const TextStyle(fontSize: 12)),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           color: app_theam[100],
//                           padding: const EdgeInsets.all(8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: const [
//                               Text(
//                                 "Contact",
//                                 style: TextStyle(
//                                     color: Color(0xFFe4287c),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold),
//                               )
//                             ],
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             launchInCall(eventDetails["result"]
//                                     ["contact_mobile"]
//                                 .toString());
//                           },
//                           child: Container(
//                               padding: const EdgeInsets.all(8),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 // crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                       child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: const [
//                                         Text("Mobile"),
//                                       ])),
//                                   Container(
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                             eventDetails["result"]
//                                                     ["contact_mobile"] ??
//                                                 "",
//                                             style: const TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.bold))
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               )),
//                         ),
//                         const Divider(thickness: 0.0, color: Colors.black),
//                         InkWell(
//                             onTap: () {
//                               print("tapped");
//                               launchInCall(eventDetails["result"]
//                                       ["contact_alt_mobile"]
//                                   .toString());
//                             },
//                             child: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   // crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                         child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: const [
//                                           Text("Alternate Mobile"),
//                                         ])),
//                                     Container(
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                               eventDetails["result"]
//                                                       ["contact_alt_mobile"] ??
//                                                   "",
//                                               style: const TextStyle(
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.bold))
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ))),
//                         const Divider(thickness: 0.0, color: Colors.black),
//                         InkWell(
//                           onTap: () {
//                             launchInWhatsapp(
//                                 eventDetails["result"]["contact_whatsapp"]
//                                     .toString(),
//                                 "");
//                           },
//                           child: Container(
//                               padding: const EdgeInsets.all(8),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 // crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                       child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: const [
//                                         Text("Whatsapp"),
//                                       ])),
//                                   Container(
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                             eventDetails["result"]
//                                                     ["contact_whatsapp"] ??
//                                                 "",
//                                             style: const TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.bold))
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               )),
//                         ),
//                         const Divider(thickness: 0.0, color: Colors.black),
//                         InkWell(
//                           onTap: () {
//                             launchInMail(eventDetails["result"]["contact_email"]
//                                 .toString());
//                           },
//                           child: Container(
//                               padding: const EdgeInsets.all(8),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 // crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                       child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: const [
//                                         Text("Email"),
//                                       ])),
//                                   Container(
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                             eventDetails["result"]
//                                                     ["contact_email"] ??
//                                                 "",
//                                             style: const TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.bold))
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               )),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               )),
//         bottomNavigationBar: Container(
//             height: 40,
//             // color: app_theam[400],
//             alignment: Alignment.center,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Container(
//                   child: Row(
//                 children: [
//                   InkWell(
//                       onTap: () {
//                               // Navigator.pushNamed(
//                               //     context, EventSummaryPage.routeName,
//                               //     arguments: EventSummaryPageArguments(
//                               //         widget.eventId));
//                             },
//                       child: Container(
//                         height: 40,
//                         width: MediaQuery.of(context).size.width / 2,
//                         color: app_theam[400],
//                         child:const Center(
//                           child:  Text(
//                                   'Back',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                         ),
//                       )),
//                   const SizedBox(width: 2),
//                   InkWell(
//                     onTap: () {
//                         var ID =int.parse(widget.ScanUserId);
//
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => ScanAgentEventBookingsListPage(
//                                   eventId: widget.eventId,
//                                   scanUserid :ID,
//
//                                 ),
//                               ),
//                             );
//                           },
//                     child: Container(
//                       height: 40,
//                       width: MediaQuery.of(context).size.width / 2,
//                       color: app_theam,
//                       child:const Center(
//                         child:  Text(
//                                 ' Bookings',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )),
//             )));
//   }
// }
