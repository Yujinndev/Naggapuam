import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'citizen.dart';
import 'establishment.dart';
import 'custom_input.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputPass = TextEditingController();

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
          title: Text('Sign in your Account'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
            image: const AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          )),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'LOGIN ACCOUNT',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Enter your Email and Password ...',
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
                  padding: EdgeInsets.only(top: 20.0),
                  child: CustomInput('Email Address', false, inputEmail),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: CustomInput('Password', true, inputPass),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 40, 56)),
                    onPressed: () async {
                      EasyLoading.dismiss();
                      EasyLoading.show(status: 'Processing ...');

                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: inputEmail.text,
                        password: inputPass.text,
                      )
                          .then((UserCredential) async {
                        DocumentSnapshot userDetail = await FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(UserCredential.user?.uid)
                            .get();

                        EasyLoading.dismiss();

                        dynamic detail = userDetail.data();
                        if (detail['type'] == 'citizen') {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Citizen(detail)));
                        } else {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Establishment(detail)));
                        }
                      });
                    },
                    child: Text(
                      "Continue",
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
      builder: EasyLoading.init(),
    );
  }
}
