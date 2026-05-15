// import 'package:flutter/material.dart';
// import 'package:localkart/lib/Api/Ticket_Nxt/ticket_nxtAPI.dart';
// import 'package:localkart/lib/Modules/events/api/event_provider.dart';
// import 'package:localkart/lib/Modules/events/eventdetailspage.dart';
// import 'package:localkart/lib/Modules/events/manageEvents/scanEvent_Details.dart';
// import 'package:localkart/lib/Modules/events/manageEvents/scanTicket.dart';
// import 'package:localkart/lib/theams_colors.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ScanAgentEventsListing extends StatefulWidget {
//   static const routeName = '/events';
//
//   ScanAgentEventsListing(
//     this.ScanUserId, {
//     Key? key,
//   }) : super(key: key);
//   var ScanUserId;
//   @override
//   State<ScanAgentEventsListing> createState() => _ScanAgentEventsListingState();
// }
//
// class _ScanAgentEventsListingState extends State<ScanAgentEventsListing> {
//   bool isLoaded = false;
//   List ScanEventsList = [];
//
//   @override
//   void initState() {
//     getScanAgentEvent();
//     super.initState();
//   }
//
//   getScanAgentEvent() async {
//     var response =
//         await HttpClientsTicketNxt(context).getScanEvents(widget.ScanUserId);
//     print("widget.ScanUserId " + widget.ScanUserId.toString());
//     if (response != null) {
//       setState(() {
//         ScanEventsList = response;
//         isLoaded = true;
//       });
//     }
//     print("getScanAgentEvent " + response.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final MediaQueryData mediaQueryData = MediaQuery.of(context);
//     final double screenHeight = mediaQueryData.size.height;
//     final double screenWidth = mediaQueryData.size.width - 20;
//     return !isLoaded
//         ? const Center(child: CircularProgressIndicator())
//         : Scaffold(
//             appBar: AppBar(
//               centerTitle: true,
//               title: const Text('Events'),
//             ),
//             body: ScanEventsList.isEmpty
//                 ? Container(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: const [
//                         Text(
//                           "No events assigned/available",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     child: Column(
//                     children: [
//                       const SizedBox(height: 5),
//                       for (int i = 0; i < ScanEventsList.length; i++)
//                         Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(13)),
//                           elevation: 4,
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width - 20,
//                             child: Column(
//                               children: [
//                                 Image.network(ScanEventsList[i]['image']),
//                                 Container(
//                                   color: app_theam[100],
//                                   height: screenHeight / 20,
//                                   width: MediaQuery.of(context).size.width,
//                                   child: Center(
//                                     child: Text(
//                                       ScanEventsList[i]['eventname'],
//                                       style: TextStyle(
//                                           color: app_theam,
//                                           fontWeight: FontWeight.bold),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 5),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           const Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: Icon(
//                                                 Icons.calendar_month_outlined),
//                                           ),
//                                           Text(
//                                             ScanEventsList[i]['date'],
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           const Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: Icon(
//                                                 Icons.location_on_outlined),
//                                           ),
//                                           Text(
//                                             ScanEventsList[i]['district'],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     InkWell(
//                                         onTap: () {
//                                           Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   ScanAgentEventDetailsPage(
//                                                 context,
//                                                 ScanUserId: widget.ScanUserId,
//                                                 eventId: ScanEventsList[i]
//                                                     ['eventId'],
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         child: Container(
//                                           decoration: const BoxDecoration(
//                                               color: Colors.pink,
//                                               borderRadius: BorderRadius.only(
//                                                   bottomLeft:
//                                                       Radius.circular(13))),
//                                           height: 40,
//                                           width: screenWidth / 2,
//                                           child: const Center(
//                                             child: Text(
//                                               'Details',
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                           ),
//                                         )),
//                                     GestureDetector(
//                                       onTap: () {
//                                         Navigator.pushNamed(context,
//                                             TicketScannerPage.routeName,
//                                             arguments:
//                                                 TicketScannerPageArguments(
//                                               ScanEventsList[i]['eventId'],
//                                               int.parse(
//                                                   widget.ScanUserId.toString()),
//                                               ScanEventsList[i]['eventname'],
//                                             ));
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             color: Colors.blue.shade900,
//                                             borderRadius:
//                                                 const BorderRadius.only(
//                                                     bottomRight:
//                                                         Radius.circular(13))),
//                                         height: 40,
//                                         width: screenWidth / 2,
//                                         child: const Center(
//                                           child: Text(
//                                             'Scan',
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                     ],
//                   )),
//             // bottomNavigationBar: InkWell(
//             //     onTap: () async {
//             //       await launch('https://localkart.app/portal/events/authlogin');
//             //     },
//             //     child: Container(
//             //       height: 40,
//             //       width: screenWidth,
//             //       color: app_theam,
//             //       child: Center(
//             //         child: Row(
//             //           mainAxisAlignment: MainAxisAlignment.center,
//             //           children: const [
//             //             Text(
//             //               'Create Event',
//             //               style: TextStyle(
//             //                   color: Colors.white, fontWeight: FontWeight.bold),
//             //             ),
//             //           ],
//             //         ),
//             //       ),
//             //     )),
//           );
//   }
// }
