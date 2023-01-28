import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'custom_input.dart';

class Citizen extends StatefulWidget {
  final dynamic detail;
  Citizen(this.detail);
  @override
  CitizenState createState() => CitizenState();
}

class CitizenState extends State<Citizen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  TextEditingController inputName = TextEditingController();
  TextEditingController inputAddress = TextEditingController();
  TextEditingController inputAge = TextEditingController();
  TextEditingController inputID = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputName = TextEditingController(text: widget.detail['name']);
    inputAddress = TextEditingController(text: widget.detail['address']);
    inputAge = TextEditingController(text: widget.detail['age']);
    inputID = TextEditingController(text: getDocumentID());
  }

  String getDocumentID() {
    final user = FirebaseAuth.instance.currentUser;
    String id = user!.uid;

    // if (user != null) {
    //   FirebaseFirestore.instance
    //       .collection("users")
    //       .where("uid", isEqualTo: user.uid)
    //       .get(doc.Id)
    //       .then((querySnapshot) {
    //     querySnapshot.docs.forEach((doc) {
    //       final String documentId = doc.id;
    //     });
    //   });
    // }

    return id;
  }

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
            'CITIZEN DASHBOARD',
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'My Account Details',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                QrImage(
                  data: getDocumentID(),
                  version: QrVersions.auto,
                  size: 300.0,
                ),
                Divider(
                  color: Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                  child: Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: CustomInput('Full Name', false, inputName),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: CustomInput('Address', false, inputAddress),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: CustomInput('Age', false, inputAge),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 40,
                  width: 240,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 40, 56)),
                    onPressed: () async {
                      EasyLoading.dismiss();
                      EasyLoading.show(status: 'Processing ...');

                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(getDocumentID())
                          .update({
                        "name": inputName.text.toString(),
                        "address": inputAddress.text.toString(),
                        "age": inputAge.text.toString(),
                      });

                      EasyLoading.showSuccess('Update Successful');
                    },
                    child: Text(
                      "Update",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
}
