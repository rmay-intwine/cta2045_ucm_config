import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class APConnectStep extends StatefulWidget {
  final String ssidName;

  APConnectStep(this.ssidName);

  @override
  _APConnectStepState createState() => new _APConnectStepState();
}

class _APConnectStepState extends State<APConnectStep> {
  static const MethodChannel platform = const MethodChannel('com.cairnsystems.connectivity/ap');

  TextEditingController _passwordTextController = new TextEditingController();

  _APConnectStepState() : super() {
    platform.setMethodCallHandler(_handleNativeCall);
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    debugPrint('Entering _handleNativeCall: ' + call.method);

    switch(call.method) {
      case "connectAPCallback":
        debugPrint("APConnectStep: callback from native: " + call.arguments.toString());
    }
  }

  void _handleButtonPress() {
    debugPrint('APConnectStep: button pressed');

    List<String> arguments = new List();
    arguments.add(widget.ssidName);
    arguments.add(_passwordTextController.text);

    try{
      platform.invokeMethod('connectToAp', arguments);
    }
    on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Connecting to module'),
        const Text('Password: '),
        new TextField(controller: _passwordTextController,),
        new FlatButton(onPressed: _handleButtonPress, child: const Text('Connect')),
      ],
    );
  }

}