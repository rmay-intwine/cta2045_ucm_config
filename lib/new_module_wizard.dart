import 'package:flutter/material.dart';

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

  void _showNextPage() {
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
      body: new Stack(
        children: <Widget>[
          new PageView(
            physics: new NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: <Widget>[
              new Center(child: new EnterNetworkStep(_showNextPage)),
              new Center(child: new IdModuleStep(_showPreviousPage, _showNextPage)),
              new Center(child: new ModulePlugInStep(_showPreviousPage)),
            ],
          ),
        ]
      ),
    );
  }
}