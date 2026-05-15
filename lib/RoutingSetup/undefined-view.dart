import 'package:flutter/material.dart';

class UndefinedView extends StatelessWidget {
  final String name;
  const UndefinedView({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("Undefined- $name"),
      ),
    );
  }
}
