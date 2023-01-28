import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'custom_input.dart';

class RegisterEstablishment extends StatefulWidget {
  @override
  RegisterEstablishmentState createState() => RegisterEstablishmentState();
}

class RegisterEstablishmentState extends State<RegisterEstablishment> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputEstablishment = TextEditingController();
  TextEditingController inputOwner = TextEditingController();
  TextEditingController inputLoc = TextEditingController();
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
          title: Text('Establishment Registration'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          height: double.infinity,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: const AssetImage('assets/images/background1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
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
                      'Enter your Establishment details ...',
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
                    child: CustomInput('Name of Owner', false, inputOwner),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: CustomInput(
                        'Establishment Name', false, inputEstablishment),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child:
                        CustomInput('Establishment Location', false, inputLoc),
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
                            "establishment": inputEstablishment.text.toString(),
                            "owner": inputOwner.text.toString(),
                            "location": inputLoc.text.toString(),
                            "type": 'establishment',
                          });
                        }

                        EasyLoading.showSuccess('Registration Successful');

                        inputEmail.text = "";
                        inputOwner.text = "";
                        inputEstablishment.text = "";
                        inputLoc.text = "";
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
