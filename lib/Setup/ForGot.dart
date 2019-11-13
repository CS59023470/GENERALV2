import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ForGot extends StatefulWidget {

  @override
  _ForGotState createState() => _ForGotState();
}

class _ForGotState extends State<ForGot> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _email;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: new IconThemeData(color: Color(0xFF5DB7DE))),//AppBar
      backgroundColor: Colors.white,
      body:  new ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("เปลี่ยนรหัสผ่าน",style: new TextStyle(fontSize: 40.0)),
                  new Form(
                    child: new Theme(
                      data: new ThemeData(
                          brightness: Brightness.light,
                          primarySwatch: Colors.lightBlue,
                          inputDecorationTheme: new InputDecorationTheme(
                              labelStyle: new TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 20.0))),//text // input //ThemeData
                      child: Container(
                        padding: const EdgeInsets.all(50.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new TextFormField(
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Please type an email';
                                }
                              },
                              onSaved: (input) => _email = input,
                              decoration: InputDecoration(
                                  labelText: 'อีเมล'
                              ),
                            ),
                          ],//<Widget>[]
                        ),//Column
                      ),//Container
                    ),//Theme
                  ),//Form
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 10.0),
                          child: new Container(
                            alignment: Alignment.center,
                            height: 40.0,
                            child: RaisedButton(
                              onPressed: resetPassword,
                              color: Color(0xFF5DB7DE),
                              child: Text('เปลี่ยนรหัสผ่าน'),
                            ),//Container
                          ),//Padding
                        ),//Expanded
                      ),
                    ],//<Widget>[]
                  ),//Row
                ],//<Widget>[]
              ),//Column
            ),//Container
          ),//Padding
        ],//<Widget>[]
      ),
    );
  }
  void resetPassword() async {
    //if (_formKey.currentState.validate()) {
      //_formKey.currentState.save();
      //try {
        //await _firebaseAuth.sendPasswordResetEmail(email: _email);
      //} catch (e) {
        //print(e);
      //}
    //}

    _firebaseAuth.sendPasswordResetEmail(email: _email);
  }
}