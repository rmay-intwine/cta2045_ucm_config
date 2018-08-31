import 'package:flutter/material.dart';

class IdModuleStep extends StatefulWidget {


  IdModuleStep();

  @override
  _IdModuleStepState createState() => new _IdModuleStepState();
}

class _IdModuleStepState extends State<IdModuleStep> {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(child: const Text('Enter Module ID')),
      ],
    );
  }

}