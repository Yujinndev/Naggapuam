import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  String label;
  bool isObscure;
  TextEditingController controller;

  CustomInput(this.label, this.isObscure, this.controller);

  CustomInputState createState() => CustomInputState(isObscure);
}

class CustomInputState extends State<CustomInput> {
  bool isObscure;

  CustomInputState(this.isObscure);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          initialValue: null,
          controller: widget.controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a value";
            } else {
              return null;
            }
          },
          obscureText: isObscure,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purple),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            suffixIcon: widget.label.contains("Password")
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility),
                    // icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility)
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
