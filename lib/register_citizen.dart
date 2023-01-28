import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'custom_input.dart';

class RegisterCitizen extends StatefulWidget {
  @override
  RegisterCitizenState createState() => RegisterCitizenState();
}

class RegisterCitizenState extends State<RegisterCitizen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputName = TextEditingController();
  TextEditingController inputAddress = TextEditingController();
  TextEditingController inputZipcode = TextEditingController();
  TextEditingController inputAge = TextEditingController();
  TextEditingController inputPass = TextEditingController();
  TextEditingController inputConPass = TextEditingController();

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
          title: Text('Citizen Registration'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: const AssetImage('assets/images/background1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Enter your Personal details ...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: CustomInput('Email Address', false, inputEmail),
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
                    child: CustomInput('Zip Code', false, inputZipcode),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: CustomInput('Age', false, inputAge),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1.0),
                    child: CustomInput('Password', true, inputPass),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: CustomInput('Confirm Password', true, inputConPass),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 0, 40, 56)),
                      onPressed: () async {
                        EasyLoading.dismiss();
                        EasyLoading.show(status: "Processing ...");

                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: inputEmail.text,
                                password: inputPass.text);

                        if (userCredential.user != null) {
                          String? uid = userCredential.user?.uid;
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(uid)
                              .set({
                            "name": inputName.text.toString(),
                            "address": inputAddress.text.toString(),
                            "zipcode": inputZipcode.text.toString(),
                            "age": inputAge.text.toString(),
                            "type": 'citizen',
                          });
                        }

                        EasyLoading.showSuccess('Registration Successful');
                        inputEmail.text = "";
                        inputName.text = "";
                        inputAddress.text = "";
                        inputZipcode.text = "";
                        inputAge.text = "";
                        inputPass.text = "";
                        inputConPass.text = "";
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
}
