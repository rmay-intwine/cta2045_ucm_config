import 'package:flutter/material.dart';

import 'istep.dart';

class EnterNetworkStep extends StatefulWidget{
  final Function nextStepListener;

  EnterNetworkStep(this.nextStepListener);

  @override
  _EnterNetworkStepState createState() => new _EnterNetworkStepState();
}

class _EnterNetworkStepState extends State<EnterNetworkStep> {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(child: const Text('Enter Network text here')),
        new Row(
          children: <Widget>[
            new FlatButton(onPressed: widget.nextStepListener, child: const Text('Next')),
          ],
        ),
      ],
    );
  }
}