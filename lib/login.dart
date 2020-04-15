import 'dart:ffi';

import 'package:crossover/data/network/Webservice.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password = "";
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          padding: EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Image(
                      image: AssetImage('assets/images/xo_logo.png'),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (email) => EmailValidator.validate(email) ? null : 'Invalid email address',
                    onSaved: (email) => _email = email,
                    decoration: InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email)),
                    onFieldSubmitted: (_) => fieldFocusChange(context, _emailFocusNode, _passwordFocusNode),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    focusNode: _passwordFocusNode,
                    obscureText: true,
                    textInputAction: TextInputAction.go,
                    validator: (password) => password.isNotEmpty ? null : 'Password required',
                    onSaved: (password) => _password = password,
                    decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          login(_email, _password);
                        } else {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                      },
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 48.0),
                      textColor: Colors.white,
                      color: Theme.of(context).accentColor,
                      child: const Text('Login', style: TextStyle(fontSize: 20))),
                ],
              ),
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      persistentFooterButtons: [
        Text('This app is not affiliated with Crossover.'),
      ],
    );
  }

  login(String email, String password) async {
    return WebService()
        .authorize(email, password)
        .catchError((error) => toastMessage("Invalid credentials!: $error"))
        .then((success) => success != null ? toastMessage("Done!") : Void);
  }
}

void toastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
}

void fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
