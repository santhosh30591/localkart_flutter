import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/theams_colors.dart';

class ErrorPageArguments {
  var data;
  ErrorPageArguments(this.data);
}

class ErrorPageScreen extends StatefulWidget {
  static const routeName = '/errorPage';

  var data;
  ErrorPageScreen({
    required this.data,
    Key? key,
  }) : super(key: key);
  @override
  State<ErrorPageScreen> createState() => _ErrorPageScreenState();
}

class _ErrorPageScreenState extends State<ErrorPageScreen> {



  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double screenHeight = mediaQueryData.size.height;
    final double screenWidth = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Scan'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/deny.png')),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
        
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
             // Half of the height to make it fully circular
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(widget.data['Message'], style: TextStyle(color: Colors.white, fontSize: 15),),
          ),
        ),
          ]),
      bottomNavigationBar: SizedBox(
          height: 40,
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: screenWidth,
                    color: app_theam,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                           Image.asset(
                            'assets/qr.png',
                            height: 20,
                          ),
                          SizedBox(width: 3,),
                          Text(
                            'Re-Scan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          )),
    );
  }
}
