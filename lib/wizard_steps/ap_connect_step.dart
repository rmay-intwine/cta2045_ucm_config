import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class APConnectStep extends StatefulWidget {

  @override
  _APConnectStepState createState() => new _APConnectStepState();
}

class _APConnectStepState extends State<APConnectStep> {
  static const MethodChannel platform = const MethodChannel('com.cairnsystems.connectivity/ap');

  _APConnectStepState() : super() {
    platform.setMethodCallHandler(_handleNativeCall);
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    debugPrint('Entering _handleNativeCall: ' + call.method);

    switch(call.method) {
      case "connectAPCallback":
        /*setState(() {
          _ssidList = (call.arguments as List<dynamic>).cast<String>();
        });*/
        debugPrint("APConnectStep: callback from native: " + call.arguments.toString());
    }
  }

  void _handleButtonPress() {
    debugPrint('APConnectStep: button pressed');

    try{
      platform.invokeMethod('connectToAp');
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
        new FlatButton(onPressed: _handleButtonPress, child: const Text('Connect')),
      ],
    );
  }

}