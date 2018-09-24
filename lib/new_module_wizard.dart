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

  static const int _pageCount = 3;

  bool _isBackButtonEnabled = false;
  bool _isNextButtonEnabled = true;

  String _networkName;
  String _moduleID;

  void _showNextPage() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _pageController.nextPage(
        duration: _duration,
        curve: _curve);
    PageView test = new PageView();
  }

  void _showPreviousPage() {
    FocusScope.of(context).requestFocus(new FocusNode());
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
              onPageChanged: (value) {
                setState(() {
                  debugPrint('onPageChanged: $value');
                  if(value == 0) {
                    _isBackButtonEnabled = false;
                  }
                  else {
                    _isBackButtonEnabled = true;
                  }

                  if(value == _pageCount - 1) {
                    _isNextButtonEnabled = false;
                  }
                  else {
                    _isNextButtonEnabled = true;
                  }
                });
              },
              children: <Widget>[
                new Center(child: new EnterNetworkStep(_networkName, (value) {
                  _networkName = value;
                })),
                new Center(child: new IdModuleStep(
                  _moduleID,
                  (value) {
                    _moduleID = value;
                  }
                )),
                new Center(child: new ModulePlugInStep(_showPreviousPage)),
              ],
            ),
            new Positioned(
              bottom: 0.0,
              left: 0.0,
              child: new FlatButton(
                onPressed: _isBackButtonEnabled ? _showPreviousPage : null,
                child: const Text("Back")
              ),
            ),
            new Positioned(
              bottom: 0.0,
              right: 0.0,
              child: new FlatButton(
                onPressed: _isNextButtonEnabled ? _showNextPage : null,
                child: const Text("Next")
              ),
            )
          ]
        ),
      ),
    );
  }
}