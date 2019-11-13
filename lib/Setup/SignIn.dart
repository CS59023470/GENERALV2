import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mass/Setup/HomeV2.dart';
import 'package:mass/Setup/SignUp.dart';
import 'package:mass/Setup/home.dart';

import 'ForGot.dart';

class LoginPageV2 extends StatefulWidget {
  @override
  _LoginPageV2State createState() => _LoginPageV2State();
}

class _LoginPageV2State extends State<LoginPageV2> {
  get assetsImage => null;
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: double.infinity,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image(image: new AssetImage("assets/mbicons.png"),
              width: 180,height: 180,),
            new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: new Container(
                      alignment: Alignment.center,
                      height: 37.0,
                      decoration: new BoxDecoration(
                          color: Color(0xFF5DB7DE),borderRadius: new BorderRadius.circular(30.0)
                      ),
                      child: new Text("เข้าสู่ระบบ",style: new TextStyle(fontSize: 25.0),),
                    ),//Container
                  ),//Padding
                ),//Expanded
              ],//<Widget>
            ),//Row
            new Form(
              key: _formKey,
              child: Theme(
                data: new ThemeData(brightness: Brightness.light,
                    primarySwatch: Colors.lightBlue,
                    inputDecorationTheme: new InputDecorationTheme(
                        labelStyle: new TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return '';
                          }
                        },
                        onSaved: (input) => _email = input,
                        decoration: InputDecoration(
                            labelText: 'อีเมล'
                        ),
                      ),
                      TextFormField(
                        validator: (input) {
                          if (input.length > 6) {
                            return 'รหัสผ่านของท่านต้องมีอย่างน้อย 6 ตัวขึ้นไป';
                          }
                        },
                        onSaved: (input) => _password = input,
                        decoration: InputDecoration(
                            labelText: 'พาสเวิร์ด'
                        ),
                        obscureText: true,
                      ),
                    ],//<Widget>[]
                  ),//Column
                ),//Padding
              ),//Theme
            ),//Form
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 150.0, right: 150.0, top: 0.0),
                    child: Container(
                      child: RaisedButton(
                        onPressed: signIn,
                        color: Color(0xFF5DB7DE),
                        child: Text('ล็อคอิน'),
                      ),//Container
                    ),//RaisedButton
                  ),//Padding
                ),//Expanded
              ],//<Widget>[]
            ),//Row
            SizedBox(
              height: 20,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 10.0, top: 10.0),
                    child: new Container(
                      alignment: Alignment.center,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 45.0),
                            child: GestureDetector(
                              onTap: () {
                              },
                              child: new Image(
                                image: AssetImage("assets/facebook.png"),
                                width: 50.0, height: 50.0,
                              ),//Image
                            ),//Padding
                          ),//Padding
                        ],//<Widget>[]
                      ),//Column
                    ),//Container
                  ),//Padding
                ),//Expanded
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 20.0, top: 10.0),
                    child: new Container(
                      alignment: Alignment.center,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 45.0),
                            child: GestureDetector(
                              onTap: () {
                                //loginWithGoogle(context);
                                loginWithGoogle(context);
                              },
                              child: new Image(
                                image: AssetImage("assets/google.png"),
                                width: 50.0, height: 50.0,
                              ),//Image
                            ),//Ges
                          ),//Padding
                        ],//<Widget>[]
                      ),//Column
                    ),//Container
                  ),//Padding
                ),//Expanded
              ],//<Widget>[]
            ),//Row
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ForGot()));
                      },//onTap
                      child: new Text("เปลี่ยนรหัสผ่าน",style: new TextStyle(
                          fontSize: 17.0, color: Colors.lightBlue)),
                    ),//GestureDetector
                  ),//Padding
                ],//<Widget>[]
              ),//Column
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SignUp()));
                      },//onTap
                      child: new Text("สมัครบัญชีผู้ใช้",style: new TextStyle(
                          fontSize: 17.0, color: Colors.lightBlue)),
                    ),//GestureDetector
                  ),//Padding
                ],//<Widget>[]
              ),//Column
            ),
          ],//<Widget>[]
        ),//Column
      ),//Container
    );
  }

//  void signIn() async {
//    final formState = _formKey.currentState;
//    if(formState.validate()){
//      formState.save();
//      try{
//        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)) as FirebaseUser;
//        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeV2(user: user)));
//      }catch(e){
//      }
//    }
//  }

  void signIn() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeV2()));

      }catch(e){
        print(e.message);
      }
    }
  }
  Future loginWithGoogle(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount user = await _googleSignIn.signIn();
    GoogleSignInAuthentication userAuth = await user.authentication;

    await _firebaseAuth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: userAuth.idToken, accessToken: userAuth.accessToken));
    await
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeV2()));
  }
}