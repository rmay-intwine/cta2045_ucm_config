import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'istep.dart';

class EnterNetworkStep extends StatefulWidget{
  final String initialNetworkName;
  final Function submitListener;

  EnterNetworkStep(this.initialNetworkName, this.submitListener);

  @override
  _EnterNetworkStepState createState() => new _EnterNetworkStepState(initialNetworkName);
}

class _EnterNetworkStepState extends State<EnterNetworkStep> {
  String _networkName;
  TextEditingController _textController = new TextEditingController();

  _EnterNetworkStepState(this._networkName);

  void submitData(value) {
    _networkName = value;
    widget.submitListener(value);
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = _networkName;

    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Enter network name'),
          new TextField(
            controller: _textController,
            onSubmitted: (value) {
              setState(() {
                submitData(value);
              });
            },
            onChanged: (value) {
              submitData(value);
            },
          ),
        ],
      ),
    );
  }

  String get networkName => _networkName;
}