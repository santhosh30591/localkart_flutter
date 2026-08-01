import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _redirectPage();
  }

  Future<void> _redirectPage() async {
    // Add a minimum delay to show the splash animation
    int delaySeconds = isLiveMode ? 5 : 2;
    await Future.delayed(Duration(seconds: delaySeconds));

    if (!mounted) return;

    bool isLogin = await _dbHelper.isLoginDB();

    if (isLogin) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        root_dashboard,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        root_login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/splash_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Image.asset(
              "assets/splash_ani.gif",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
