import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localkart/Api/provider/billpay_provider.dart';
import 'package:localkart/Api/provider/home_provider.dart';
import 'package:localkart/Api/provider/manage_business_provider.dart';
import 'package:localkart/pages/Dashboard/dashboard.dart';
import 'package:localkart/pages/Dashboard/home.dart';
import 'package:localkart/RoutingSetup/router.dart' as router;
import 'package:localkart/pages/Dashboard/manage_business/UpdateDetails/business_basic_update.dart';
import 'package:localkart/pages/autho/splash.dart';
import 'package:localkart/theams_colors.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  ); // Enable edge-to-edge

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomePageProvider>(
          create: (context) => HomePageProvider(),
        ),
        ChangeNotifierProvider<BillPaymentProvider>(
          create: (context) => BillPaymentProvider(),
        ),
        ChangeNotifierProvider<ManageBusinessProvider>(
          create: (context) => ManageBusinessProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: app_theam),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: router.generateRoute,
        home: SplashScreen(),
        // home: UpdateBusiness(),
      ),
    );
  }
}
