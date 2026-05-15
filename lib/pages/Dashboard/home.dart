// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:localkart/Api/provider/home_provider.dart';
// import 'package:localkart/RoutingSetup/router-constants.dart';
// import 'package:localkart/data_base/db_config.dart';
// import 'package:localkart/model/home_billpay_list.dart';
// import 'package:localkart/theams_colors.dart';
// import 'package:localkart/unit/action_bar.dart';
// import 'package:provider/provider.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _MyHomePage();
// }
//
// class _MyHomePage extends State<HomePage> {
//   late List<BillPayData> _billPayDataList = [];
//
//   late HomePageProvider provider;
//
//   var appTitle = "";
//
//   @override
//   void initState() {
//     super.initState();
//     bilPayApiCall();
//
//     loginDetails();
//   }
//
//   loginDetails() async {
//     var dbhelper = await DBHelper();
//     var name = await dbhelper.getLoginSubDB('Name');
//     appTitle = name.toString();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _billPayDataList = context.watch<HomePageProvider>().billPayDataList;
//
//     // return actionBarTopBottomViewBharathConnect("Localkart", temp(), context);
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         systemNavigationBarColor: Colors.transparent,
//         systemNavigationBarIconBrightness: Brightness.light,
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/login-reg-bg.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           top: false,
//           bottom: false,
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               // Here we take the value from the MyHomePage object that was created by
//               // the App.build method, and use it to set our appbar title.
//               title: Text(appTitle),
//               actions: [
//                 InkWell(
//                   onTap: () {
//                     Navigator.pushNamed(context, root_billbay_history);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     child: Icon(Icons.history, color: Colors.white, size: 26),
//                   ),
//                 ),
//
//                 InkWell(
//                   onTap: () async {
//                     // loginDetails();
//                     var dbhelper = await DBHelper();
//                     await dbhelper.logOutDB();
//
//                     Navigator.pushNamedAndRemoveUntil(
//                       context,
//                       root_login,
//                       (route) => false,
//                     );
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     child: Icon(
//                       Icons.power_settings_new,
//                       color: Colors.white,
//                       size: 26,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             body: Container(
//               color: Colors.white,
//               height: double.infinity,
//               width: MediaQuery.of(context).size.width,
//               child: _billPayDataList != 0
//                   // ? Text("_billPayDataList"+_billPayDataList.length.toString())
//                   ? billpayViewLoading()
//                   : Column(
//                       mainAxisAlignment: .center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             onTap:
//                             bilPayApiCall();
//                           },
//                           child: Text('No Data Found.'),
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   bilPayApiCall() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       provider = Provider.of<HomePageProvider>(context, listen: false);
//       provider.updateContext(contexts: context);
//       provider.getBillPay();
//
//       print("_billPayDataList length - " + _billPayDataList.length.toString());
//     });
//   }
//
//   billpayViewLoading() {
//     return GridView.count(
//       shrinkWrap: true,
//       scrollDirection: Axis.vertical,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 4,
//       children: List.generate(_billPayDataList.length, (index) {
//         var data = _billPayDataList[index];
//
//         return InkWell(
//           onTap: () {
//             Navigator.of(context).pushNamed(
//               root_billpay_opertor_list,
//               arguments: _billPayDataList[index],
//             );
//           },
//           child: Container(
//             color: Colors.white,
//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     width: MediaQuery.of(context).size.width / 7,
//                     height: MediaQuery.of(context).size.width / 7,
//                     child: Container(
//                       child: Container(
//                         padding: EdgeInsets.all(4),
//                         child: Image.network(
//                           data.icon.toString(),
//                           fit: BoxFit.cover,
//
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return Container(
//                               decoration: const BoxDecoration(
//                                 image: DecorationImage(
//                                   image: AssetImage("assets/load.gif"),
//                                 ),
//                               ),
//                             );
//                           },
//                           errorBuilder: (context, error, stackTrace) {
//                             return Image.asset("assets/logo_with_name1.png");
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         data.name.toString(),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 12,
//                         ),
//                         maxLines: 2,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
