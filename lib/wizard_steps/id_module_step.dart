import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class IdModuleStep extends StatefulWidget {
  final String _initialModuleID;
  final Function submitListener;

  IdModuleStep(this._initialModuleID, this.submitListener);

  @override
  _IdModuleStepState createState() => new _IdModuleStepState(_initialModuleID);
}

class _IdModuleStepState extends State<IdModuleStep> {
  String _moduleID;
  TextEditingController _textController = new TextEditingController();

  _IdModuleStepState(this._moduleID);

  void submitData(value) {
    _moduleID = value;
    widget.submitListener(value);
  }

  void _scanQRCode() async {
    final File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    final BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    final List<Barcode> barcodes = await barcodeDetector.detectInImage(visionImage);

    for(Barcode barcode in barcodes) {
      setState(() {
        _moduleID = barcode.rawValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = _moduleID;

    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Enter module ID'),
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
          new Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: new RaisedButton(
              child: const Text('Scan QR code'),
              onPressed: _scanQRCode,
            ),
          )
        ],
      ),
    );
  }

}