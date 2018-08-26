import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'wizard_steps/enter_network_step.dart';
import 'wizard_steps/id_module_step.dart';
import 'wizard_steps/module_plug_in_step.dart';

class NewModuleWizard extends StatefulWidget {

  @override
  _NewModuleWizardState createState() => new _NewModuleWizardState();
}

class _NewModuleWizardState extends State<NewModuleWizard> {
  PageController _pageController = new PageController();
  final Duration _duration = new Duration(milliseconds: 250);
  final Curve _curve = Curves.linear;

  String networkName;

  void _showNextPage() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _pageController.nextPage(
        duration: _duration,
        curve: _curve);
  }

  void _showPreviousPage() {
    _pageController.previousPage(
        duration: _duration,
        curve: _curve);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Configure new module"),
      ),
      body: new Container(
        margin: const EdgeInsets.all(20.0),
        child: new Stack(
          children: <Widget>[
            new PageView(
              physics: new NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: <Widget>[
                new Center(child: new EnterNetworkStep(networkName, (value) {
                  networkName = value;
                })),
                new Center(child: new IdModuleStep(_showPreviousPage, _showNextPage)),
                new Center(child: new ModulePlugInStep(_showPreviousPage)),
              ],
            ),
            new Positioned(
              bottom: 0.0,
              left: 0.0,
              child: new FlatButton(onPressed: _showPreviousPage, child: const Text("Previous")),
            ),
            new Positioned(
              bottom: 0.0,
              right: 0.0,
              child: new FlatButton(onPressed: _showNextPage, child: const Text("Next")),
            )
          ]
        ),
      ),
    );
  }
}