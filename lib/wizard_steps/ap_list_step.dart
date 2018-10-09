import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class APListStep extends StatefulWidget {
  final Function submitListener;

  APListStep(this.submitListener);

  @override
  _APListStepState createState() => new _APListStepState();
}

class _APListStepState extends State<APListStep> {
  static const MethodChannel platform = const MethodChannel('com.cairnsystems.connectivity/ap');
  String _testResult = 'initial value';

  Future<Null> _getResult() async {
    String resultValue;

    try{
      final String result = await platform.invokeMethod('getApList');
      resultValue = result;
    }
    on PlatformException catch (e) {
      resultValue = 'Could not get result from native.';
    }

    setState(() {
      _testResult = resultValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('Please select an network to connect to: $_testResult'),
          new RaisedButton(
            child: Text('Get Result'),
            onPressed: _getResult,
          ),
          new Expanded(
            child: new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return new Text('row $index');
              }
            ),
          ),
        ],
      ),
    );
  }
}