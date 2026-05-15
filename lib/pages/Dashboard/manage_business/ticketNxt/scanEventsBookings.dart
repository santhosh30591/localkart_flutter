// import 'package:flutter/material.dart';
// import 'package:localkart/lib/Modules/events/mybooking_provider.dart';
// import 'package:localkart/lib/theams_colors.dart';
// import 'package:provider/provider.dart';
//
// class ScanAgentEventBookingsListPage extends StatefulWidget {
//   static const routeName = '/scanagent-bookings';
//
//   ScanAgentEventBookingsListPage({
//     required this.eventId,
//     required this.scanUserid,
//     Key? key,
//   }) : super(key: key);
//   int eventId;
//   int scanUserid;
//   @override
//   State<ScanAgentEventBookingsListPage> createState() =>
//       _ScanAgentEventBookingsListPageState();
// }
//
// class _ScanAgentEventBookingsListPageState
//     extends State<ScanAgentEventBookingsListPage> {
//   bool isExpanded = false;
//
//   @override
//   void initState() {
//     getBookings();
//     super.initState();
//   }
//
//   getBookings() async {
//     print('calling');
//     Provider.of<MyBookingsProvider>(context, listen: false)
//         .getScanAgentEventBookingList(widget.eventId, widget.scanUserid);
//   }
//
//   Color? convertColor(String? colorString) {
//     if (colorString == null) return null;
//     try {
//       return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
//     } catch (e) {
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List bookingList = [];
//     final MediaQueryData mediaQueryData = MediaQuery.of(context);
//     final double screenWidth = mediaQueryData.size.width - 20;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Bookings'),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: SizedBox(
//               width: screenWidth * 2,
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       color: app_theam[100],
//                       padding: const EdgeInsets.all(4),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             height: 30,
//                             width: screenWidth / 8,
//                             child: Center(
//                                 child: Text(
//                               '#',
//                               style: TextStyle(
//                                   color: app_theam,
//                                   fontWeight: FontWeight.bold),
//                             )),
//                           ),
//                           SizedBox(
//                             height: 30,
//                             width: screenWidth / 9,
//                             child: Center(
//                               child: Image.asset(
//                                 'assets/entry-02.png',
//                                 // width: 15,
//                                 // height: 20,
//                                 color: app_theam,
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 30,
//                             width: screenWidth / 2.5,
//                             child: Center(
//                                 child: Text(
//                               'NAME & MOBILE NO',
//                               style: TextStyle(
//                                   color: app_theam,
//                                   fontWeight: FontWeight.bold),
//                             )),
//                           ),
//                           SizedBox(
//                             height: 30,
//                             width: screenWidth / 6,
//                             child: Center(
//                                 child: Text(
//                               'TICKETS',
//                               style: TextStyle(
//                                   color: app_theam,
//                                   fontWeight: FontWeight.bold),
//                             )),
//                           ),
//                           // SizedBox(
//                           //   height: 30,
//                           //   width: screenWidth / 3,
//                           //   child: Center(
//                           //       child: Text(
//                           //     'BOOKED',
//                           //     style: TextStyle(
//                           //         color: app_theam,
//                           //         fontWeight: FontWeight.bold),
//                           //   )),
//                           // ),
//                           SizedBox(
//                             height: 30,
//                             width: screenWidth / 4,
//                             child: Center(
//                                 child: Text(
//                               'ADMITTED',
//                               style: TextStyle(
//                                   color: app_theam,
//                                   fontWeight: FontWeight.bold),
//                             )),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Consumer<MyBookingsProvider>(
//                         builder: (context, bookingsProvider, child) {
//                       bookingList = bookingsProvider.scan_eventBookingList;
//
//                       return bookingList.isEmpty
//                           ? const Center(child: Text("No Data Found"))
//                           : Column(
//                               children: [
//                                 for (int i = 0;
//                                     i < bookingList.length;
//                                     i++) ...[
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 10,
//                                         top: 10,
//                                         bottom: 10,
//                                         right: 5),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           width: screenWidth / 8,
//                                           child: Center(
//                                               child: Text(
//                                             (i + 1).toString(),
//                                           )),
//                                         ),
//                                         SizedBox(
//                                           height: 30,
//                                           width: screenWidth / 8,
//                                           child: Center(
//                                             child: Image.asset(
//                                               'assets/dot.png',
//                                               width: 15,
//                                               height: 20,
//                                               color: convertColor(bookingList[i]
//                                                   ['admitted_color']) ?? Colors.transparent,
//                                             ),
//                                             //      Text(
//                                             //   '.',
//                                             //   style: TextStyle(
//                                             //       color: convertColor(bookingList[i]['admitted_color']),
//                                             //       fontWeight: FontWeight.bold,fontSize: 20),
//                                             // )
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: screenWidth / 2.5,
//                                           child: Center(
//                                               child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 '${bookingList[i]['customer_name'] ?? ""}',
//                                               ),
//                                               // Text(
//                                               //   '${bookingList[i]['customer_mobile'] ?? ""}',
//                                               // ),
//                                             ],
//                                           )),
//                                         ),
//                                         Center(
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.pink,
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                             ),
//                                             height: 25,
//                                             width: screenWidth / 6,
//                                             child: Center(
//                                               child: Text(
//                                                 '${bookingList[i]['ticket_qty'] ?? ""}',
//                                                 style: const TextStyle(
//                                                   fontSize: 16,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         // SizedBox(
//                                         //   width: screenWidth / 3,
//                                         //   child: Center(
//                                         //       child: Column(
//                                         //     children: [
//                                         //       Text(
//                                         //         '${bookingList[i]['date'] ?? ""}',
//                                         //       ),
//                                         //       Text(
//                                         //         '${bookingList[i]['time'] ?? ""}',
//                                         //       ),
//                                         //     ],
//                                         //   )),
//                                         // ),
//                                         SizedBox(
//                                           width: screenWidth / 4,
//                                           child: Center(
//                                             child: Text(bookingList[i]
//                                                         ['date'] !=
//                                                     null
//                                                 ? "${bookingList[i]['date']}\n ${bookingList[i]['time']}"
//                                                 : "-"),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const Divider(
//                                     thickness: 2,
//                                     indent: 5,
//                                     endIndent: 5,
//                                   ),
//                                 ]
//                               ],
//                             );
//                     })
//                   ]),
//             )),
//       ),
//       bottomNavigationBar: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Container(
//             height: 40,
//             width: screenWidth,
//             color: app_theam,
//             child: Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Text(
//                     'Back',
//                     style: TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }
