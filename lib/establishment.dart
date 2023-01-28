import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';

class Establishment extends StatefulWidget {
  final dynamic detail;
  Establishment(this.detail);
  @override
  EstablishmentState createState() => EstablishmentState();
}

class EstablishmentState extends State<Establishment> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isScannerVisible = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Marcellus',
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 40, 56),
          title: Text(
            'ESTABLISHMENT DASHBOARD',
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                'Establishment Details:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                '${widget.detail['establishment']}',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Text(
                '${widget.detail['location']}',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Text(
                '${widget.detail['owner']}',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: (isScannerVisible == false) ? 0 : 400,
              child: Expanded(
                flex: 3,
                child: Visibility(
                  visible: isScannerVisible,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: (isScannerVisible == false) ? 300 : 75,
              width: 350,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 40, 56),
                ),
                onPressed: () {
                  setState(() {
                    (isScannerVisible == false)
                        ? isScannerVisible = true
                        : isScannerVisible = false;
                  });
                },
                child: (isScannerVisible == false)
                    ? Text("Open Scanner", style: TextStyle(fontSize: 30))
                    : Text("Close Scanner", style: TextStyle(fontSize: 15)),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: (result != null)
                    ? FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(result!.code)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            dynamic userDetail = snapshot.data!.data();
                            return Text(
                              "USER ID: ${result!.code}\nNAME: ${userDetail['name']} \nLOCATION: ${userDetail['address']} ${userDetail['zipcode']} \nAGE: ${userDetail['age']}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900),
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error.toString()}");
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      )
                    : const Text("Scan the person's qr code ..."),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        isScannerVisible = false;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
