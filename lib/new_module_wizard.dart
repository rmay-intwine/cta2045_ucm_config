import 'package:flutter/material.dart';

class NewModuleWizard extends StatefulWidget {

  @override
  _NewModuleWizardState createState() => new _NewModuleWizardState();
}

class _NewModuleWizardState extends State<NewModuleWizard> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Configure new module"),
      ),
      body: new PageView(
        children: <Widget>[
          new Center(child: const Text("Step 1")),
          new Center(child: const Text("Step 2")),
          new Center(child: const Text("Step 3")),
        ],
      ),
    );
  }
}