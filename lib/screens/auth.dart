import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_roads/constants/text_styles.dart';
import 'package:safe_roads/functions/firebase_auth.dart';
import 'package:safe_roads/screens/home.dart';
import 'package:safe_roads/widgets/form_container_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var login = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _rtppassword = TextEditingController();
  final TextEditingController _machineId = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('/images/background_auth.jpg'),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Container(
                  height: 590,
                  width: 941,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(61),
                    // color: Colors.black.withOpacity(0.6)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(61),
                                  bottomLeft: Radius.circular(61)),
                              color: Colors.black.withOpacity(0.2)),
                          child: const Center(
                              child: Text(
                            'Safe Roads',
                            style: TextStyle(
                                fontFamily: 'JejuHallasan',
                                color: Colors.white,
                                fontSize: 65),
                          )),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(61),
                                  bottomRight: Radius.circular(61)),
                              color: Colors.black.withOpacity(0.7)),
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  login?SizedBox():FormContainerWidget(
                                    width: double.infinity,
                                      hintText: "Machine Id",
                                      controller: _machineId,
                                      hintTextStyle: FORM_HINT_STYLE,
                                      validator: (value) {
                                        try{
                                          FirebaseFirestore.instance.collection('machines').doc(value).get();
                                        }catch(e){
                                          return "Machine not found";
                                        }                                        
                                      }),
                                  const SizedBox(height: 20),
                                  FormContainerWidget(
                                    width: double.infinity,
                                      hintText: "Email",
                                      controller: _email,
                                      hintTextStyle: FORM_HINT_STYLE,
                                      validator: (value) {
                                        if (value == null ||
                                            !value.contains('@')) {
                                          return "email is incorrect";
                                        }
                                      }),
                                  const SizedBox(height: 20),
                                  FormContainerWidget(
                                    width: double.infinity,
                                    hintText: "Password",
                                    controller: _password,
                                    hintTextStyle: FORM_HINT_STYLE,
                                    isPasswordField: true,
                                    validator: (value) {
                                      if (value == null || value.length < 6) {
                                        return "minimum characters is 6";
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  login
                                      ? SizedBox()
                                      : FormContainerWidget(
                                        width: double.infinity,
                                          hintText: "Retype Password",
                                          controller: _rtppassword,
                                          hintTextStyle: FORM_HINT_STYLE,
                                          isPasswordField: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                value != _password.text) {
                                              return "Field has a different value";
                                            }
                                          }),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: (){if (_formKey.currentState!.validate()) {
                                  if (login) {
                                    signin(
                                        email: _email.text.trim(),
                                        password: _password.text);
                                  } else {
                                    signup(
                                        email: _email.text.trim(),
                                        password: _password.text,machineId:_machineId.text.trim());}}},
                                      child: Container(
                                    height: 50,
                                    width: 191,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.green,
                                    ),
                                    child: Center(
                                        child: Text(login ? "SIGN IN" : "SIGN UP",
                                            style: FORM_HINT_STYLE)),
                                  )),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomePage()));
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 191,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(18),
                                          color: Colors.green,
                                        ),
                                        child: Center(
                                            child: Text("ADMIN",
                                                style: FORM_HINT_STYLE)),
                                      )),
                                      Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    login ? "Not Signed up?" : "Already Signed up?",
                                    style: BODY_TEXT_STYLE),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        login = !login;
                                      });
                                    },
                                    child: Text(login ? "Sign Up" : "Sign In",
                                        style: LINK_TEXT_STYLE))
                              ],
                            ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ))),
        ),
      ),
    );
  }
}
