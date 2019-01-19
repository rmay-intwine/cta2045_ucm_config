import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class APSearchStep extends StatefulWidget {
  final String initialSSIDName;
  final Function submitListener;

  APSearchStep(this.initialSSIDName, this.submitListener);

  @override
  _APSearchStepState createState() => new _APSearchStepState();
}

class _APSearchStepState extends State<APSearchStep> {
  static const MethodChannel platform = const MethodChannel('com.cairnsystems.connectivity/ap');

  bool _appScannedForSSIDs = false;
  List<String> _ssidList;

  _APSearchStepState() : super() {
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
      _appScannedForSSIDs = false;
      _ssidList = null;
    });

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
          _appScannedForSSIDs = true;
          _ssidList = (call.arguments as List<dynamic>).cast<String>();
        });
    }
  }

  Widget _getProgressIndicator() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          child: new Text('Looking for Module'),
          padding: EdgeInsets.only(bottom: 10.0),
        ),
        new CircularProgressIndicator(),
      ],
    );
  }

  Widget _getResultMessage() {
    bool isModuleFound = false;
    String moduleName = widget.initialSSIDName;

    if(_ssidList != null && _ssidList.length > 0) {
      for(String ssidName in _ssidList) {
        if(ssidName == moduleName) {
          isModuleFound = true;
          break;
        }
      }
    }

    String message;
    if(isModuleFound){
      message = '$moduleName was found.';
    }
    else {
      message = '$moduleName was not found.';
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(message),
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
          new Expanded(
          //child: _appScannedForSSIDs ? _getProgressIndicator() : _getResultMessage()
            child: _appScannedForSSIDs ? _getResultMessage() : _getProgressIndicator()
          ),
          new RaisedButton(
            child: Text('Refresh'),
            //onPressed: _appScannedForSSIDs ? null : _getResult,
            onPressed: _appScannedForSSIDs ? _getResult : null,
          ),
        ],
      ),
    );
  }
}