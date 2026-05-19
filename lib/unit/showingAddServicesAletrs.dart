import 'package:flutter/material.dart';
import 'package:localkart/theams_colors.dart';

class AddServicesAlerts extends StatefulWidget {
  AddServicesAlerts({Key? key}) : super(key: key);

  @override
  _AddServicesAlerts createState() => _AddServicesAlerts();
}

class _AddServicesAlerts extends State<AddServicesAlerts> {
  int valueHolder = 30;

  TextEditingController _textAddService = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 200,
              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
              width: double.infinity,
              child: Column(
                children: [
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Add New Service",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                  TextField(
                    controller: _textAddService,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: "Enter service name", labelText: "Name"),
                  ),
                  SizedBox(height: 25),
                  Container(
                    alignment: FractionalOffset.center,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [app_theam, app_colorSecondary],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(5, 5),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_textAddService.text.length == 0) {
                            } else {
                              Navigator.pop(context,
                                  "" + _textAddService.text.toString());
                            }
                          },
                          child: Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [app_theam, Color(0xFFf4a4c8)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(5, 5),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: -40,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 35,
                  child: Image.asset(
                    "assets/logo_with_name.png",
                    height: 50,
                    width: 50,
                  ),
                )),
          ],
        ));
  }
}
