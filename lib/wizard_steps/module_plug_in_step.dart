import 'package:flutter/material.dart';

class ModulePlugInStep extends StatefulWidget {
  final Function previousStepListener;

  ModulePlugInStep(this.previousStepListener);

  @override
  _ModulePlugInStepState createState() => new _ModulePlugInStepState();
}

class _ModulePlugInStepState extends State<ModulePlugInStep> {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(child: const Text('Instructions for plugging in the module')),
      ],
    );
  }

}