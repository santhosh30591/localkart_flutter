// import 'package:flutter/material.dart';
// import 'package:localkart/pages/events/EventFailure.dart';
// import 'package:localkart/pages/events/eventsucess.dart';
// import 'package:localkart/theams_colors.dart';
//
// class ShowEventTransactionSucess extends StatefulWidget {
//   bool type;
//   String msg;
//   String eventId;
//
//   ShowEventTransactionSucess({
//     Key? key,
//     required this.type,
//     required this.msg,
//     required this.eventId,
//   }) : super(key: key);
//
//   @override
//   _ShowEventTransactionSucess createState() => _ShowEventTransactionSucess();
// }
//
// class _ShowEventTransactionSucess extends State<ShowEventTransactionSucess> {
//   int valueHolder = 30;
//
//   @override
//   Widget build(BuildContext context) {
//     print(
//       "type ${widget.type.toString()} msg ${widget.msg.toString()}  eventId ${widget.eventId.toString()}",
//     );
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.topCenter,
//         children: [
//           Container(
//             height: 180,
//             width: double.infinity,
//             margin: EdgeInsets.all(5),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(5, 45, 0, 5),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   widget.type == true
//                       ? Text(
//                           widget.msg,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         )
//                       : Text(
//                           widget.msg,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                   const SizedBox(height: 20),
//                   Container(
//                     margin: const EdgeInsets.all(10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.pop(context, true);
//
//                               widget.type == true
//                                   ? {
//                                       Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ShowEventTransactionSucess(
//                                                 eventid: widget.eventId
//                                                     .toString(),
//
//                                               ),
//                                         ),
//                                       ),
//                                       // Navigator.pushReplacementNamed(
//                                       //   context,
//                                       //   EventSucessScreen.routeName,
//                                       //   arguments: EventSucessScreenArguments(
//                                       //     widget.eventId.toString(),
//                                       //   ),
//                                       // )
//                                     }
//                                   :
//                                     // Navigator.pushReplacementNamed(
//                                     //         context,
//                                     //         EventFailureScreen.routeName,
//                                     //         arguments: EventSucessScreenArguments(
//                                     //           widget.eventId.toString(),
//                                     //         ),
//                                     //       );
//                                     Navigator.of(context).push(
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             EventFailureScreen(
//                                               eventid: widget.eventId
//                                                   .toString(),
//                                             ),
//                                       ),
//                                     );
//                             },
//                             child: Container(
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [app_theam, Color(0xFFf4a4c8)],
//                                   begin: Alignment.bottomCenter,
//                                   end: Alignment.topCenter,
//                                 ),
//                                 borderRadius: BorderRadius.circular(5),
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Colors.black12,
//                                     offset: Offset(5, 5),
//                                     blurRadius: 10,
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: const [
//                                   Text(
//                                     "Continue",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: -40,
//             child: widget.type == true
//                 ? const CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 35,
//                     child: Icon(Icons.check, size: 50, color: Colors.green),
//                   )
//                 : const CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 35,
//                     child: Icon(Icons.close, size: 50, color: Colors.red),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
