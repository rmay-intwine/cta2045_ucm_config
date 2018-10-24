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

  List<String> _ssidList;

  _APListStepState() : super() {
    platform.setMethodCallHandler(_handleNativeCall);
  }

  @override
  initState() {
    super.initState();
    _getResult();
  }

  bool _isResultListNull(){
    return _ssidList == null || _ssidList.length == 0;
  }

  Future<Null> _getResult() async {
    setState(() {
      _ssidList = null;
    });

    List<String> resultValue;

    try{
      await platform.invokeMethod('getApList');
    }
    on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    switch(call.method) {
      case "setSsid":
        setState(() {
          _ssidList = (call.arguments as List<dynamic>).cast<String>();
        });
    }
  }

  Widget _getProgressIndicator() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new CircularProgressIndicator(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            child: new Text('Please select a network to connect to:'),
            padding: EdgeInsets.only(bottom: 10.0),
          ),
          new Expanded(
            child: _isResultListNull() ? _getProgressIndicator() : new Container(
              decoration: new BoxDecoration(
                border: Border.all(),
              ),
              padding: EdgeInsets.all(10.0),
              child: new ListView.builder(
                  itemCount: _ssidList.length,
                  itemBuilder: (BuildContext context, int index) {
                  String apName = _ssidList[index];
                  return new Text('$apName');
                },
              ),
            ),
          ),
          new RaisedButton(
            child: Text('Refresh'),
            onPressed: _isResultListNull() ? null : _getResult,
          ),
        ],
      ),
    );
  }
}