import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  Future checkFirstSeen() async {
    var dbhelper = await DBHelper();
    bool islogin = await dbhelper.isLoginDB();

    if (islogin) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        root_dashboard,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(context, root_login, (route) => false);
    }
  }

  @override
  void initState() {
    print("redirect Splash Screen");
    redirectPage();

    super.initState();
  }

  Future<void> initializePreference() async {
    checkFirstSeen();
  }

  void redirectPage() async {
    print("redirect home");

    if (!isLiveMode) {
      initializePreference();
    } else {
      await Future.delayed(const Duration(seconds: 5), () {
        initializePreference();
      });
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
      child: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/login-reg-bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            top: true,
            bottom: true,

            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              // backgroundColor: Colors.transparent,
              body: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/splash_bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // child: InkWell(
                  //   onTap: () {
                  //     Navigator.pushNamed(context, root_login);
                  //   },
                  child: Image.asset("assets/splash_ani.gif"),
                  // ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
