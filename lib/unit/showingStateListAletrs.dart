import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/pages/autho/register.dart';
import 'package:localkart/theams_colors.dart';

class StateListAletrs extends StatefulWidget {
  List<StateList> stateList;
  String title;

  StateListAletrs({Key? key, required this.title, required this.stateList})
    : super(key: key);

  @override
  _StateListAletrs createState() => _StateListAletrs();
}

class _StateListAletrs extends State<StateListAletrs> {
  int valueHolder = 30;

  @override
  void initState() {
    stateList = widget.stateList;
    tempStateList = stateList;
    super.initState();
  }

  List<StateList> stateList = [];

  List<StateList> tempStateList = [];

  var txt_control_search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      child: Container(
        height: 450,

        width: double.infinity,

        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  // Define the colors for the gradient. At least two are required.
                  colors: [gradint_start_color, gradient_end_color],
                  // Define where the gradient starts and ends (Alignment values range from -1.0 to 1.0).
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.45, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.bottomRight,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Select " + widget.title,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      color: app_theam,
                      icon: Icon(Icons.close, color: Colors.white, size: 26),
                      onPressed: () {
                        Navigator.pop(context, "0");
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: txt_control_search,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search ' + widget.title + " name",
                  contentPadding: EdgeInsets.all(8),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                    // borderSide: new BorderSide(color: billpay_div_line_color),
                  ),

                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  List<StateList> tempStateListw = [];

                  if (value.toString().length >= 2) {
                    for (int i = 0; i < stateList.length; i++) {
                      if (stateList[i].stateName.toLowerCase().contains(
                        value.toLowerCase(),
                      )) {
                        tempStateListw.add(stateList[i]);
                      }
                    }
                  } else {
                    tempStateListw = stateList;
                  }

                  print("the data size is " + tempStateList.length.toString());

                  setState(() {
                    tempStateList = tempStateListw;
                  });
                },
                onSubmitted: (value) {
                  List<StateList> tempStateListw = [];

                  if (value.toString().length >= 2) {
                    for (int i = 0; i < stateList.length; i++) {
                      if (stateList[i].stateName.toLowerCase().contains(
                        value.toLowerCase(),
                      )) {
                        tempStateListw.add(stateList[i]);
                      }
                    }
                  } else {
                    tempStateListw = stateList;
                  }

                  print("the data size is " + tempStateList.length.toString());

                  setState(() {
                    tempStateList = tempStateListw;
                  });
                },
              ),
            ),
            Flexible(
              child: tempStateList.length == 0
                  ? Container()
                  : ListView.builder(
                      itemCount: tempStateList.length,
                      // separatorBuilder: (context, int) {
                      //   // return;
                      // },
                      itemBuilder: (context, index) {
                        return _showBottomSheetWithSearch(
                          tempStateList[index],
                          true,
                          index,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showBottomSheetWithSearch(StateList state, var isState, index) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(15),
        child: new Text(state.stateName),
      ),
      onTap: () {
        try {
          setState(() {
            Navigator.pop(context, state);
          });
        } catch (e) {
          print("data loading err- " + e.toString());
        }
      },
    );
  }
}
