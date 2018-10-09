import 'package:flutter/material.dart';

class ModulePlugInStep extends StatefulWidget {
  ModulePlugInStep();

  @override
  _ModulePlugInStepState createState() => new _ModulePlugInStepState();
}

class _ModulePlugInStepState extends State<ModulePlugInStep> {
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Plug in the module. Tap Next when done.'),
      ],
    );
  }

}