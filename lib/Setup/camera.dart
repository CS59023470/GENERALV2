import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() {
  runApp(new MaterialApp(
    home: LandingScreen(),
  ));
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  String _value1 = null;
  List<String> _values1 = new List<String>();
  File imageFile;
  String _userId;

  _openGallary(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("คลังภาพ"),
                onTap: () {
                  _openGallary(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("กล้อง"),
                onTap: () {
                  _openCamera(context);
                }, //onTap
              ) //GestureDetector
            ], //<>Widget[]
          ), //ListBody
        ), //SingleChildScrollView
      ); //AlertDialog
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(imageFile.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        fileName);
    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);

    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    //FirebaseDatabase.instance.reference().child('UserHistory').child(
    //'$_userId')
    //.child(_getDateNow()).set({
    //'datetime': _getDateNow(),
    //'category' : '$_value1',
    //'Url_Picture' : '$url'
    //});
    FirebaseDatabase.instance.reference().child('ForExpert').
    child('2fIhRXsXwoRF65vihkQP9DHpkat2').child(_getDateNow()).set({
      'Date': _getDateNow(),
      'Url_Picture': '$url',
      'UID' : '$_userId'
    },);
    FirebaseDatabase.instance.reference().child('ForExpert').
    child('qghtUnU0fPQHe1MmEEKqxWne74v2').child(_getDateNow()).set({
      'Date': _getDateNow(),
      'Url_Picture': '$url',
      'UID' : '$_userId'
    },);
    FirebaseDatabase.instance.reference().child('ForExpert').
    child('q9R16J8Ge2Rnat6BZKc5q2Uh5y33').child(_getDateNow()).set({
      'Date': _getDateNow(),
      'Url_Picture': '$url',
      'UID' : '$_userId'
    },);
  }

//  @override
//  void initState(){
//    _values1.addAll(["","ชั้นดีเลิศ","ช้นดี","ชั้นปานกลาง","ชั้นพอใช้"]);
//    _value1 = _values1.elementAt(0);
//  }

  //Future uploadPic(BuildContext context) async {
  //String fileName = basename(imageFile.path);
  //StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
  //fileName);
  //StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
  //StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  //}

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((user) {
      _userId = user.uid;
    });
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              imageFile == null
                  ? Image.asset(
                "assets/picture.png", width: 400.0, height: 400.0,)
                  : Image.file(imageFile, width: 400.0, height: 400.0),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//
//                  Text('เกรดเนื้อ  :  ',style: TextStyle(fontSize: 15.0),),
//                  DropdownButton<String>(
//                    items: _values1.map<DropdownMenuItem<String>>((String value1){
//                      return DropdownMenuItem<String>(
//                        value: value1,
//                        child: Text(value1,style: TextStyle(color: Colors.black87),),
//                      );
//                    }).toList(),
//                    onChanged: (String newValueone){
//                      setState(() {
//                        this._value1 = newValueone;
//                     });
//                    },
//                  ),
//                ],
//              ),
              RaisedButton(
                  onPressed: () {
                    _showChoiceDialog(context);
                  },
                  child: Text("เลือกภาพ")),
              RaisedButton(
                onPressed: () {
                  uploadPic(context);
                },
                child: Text("ส่งให้ผู้เชี่ยวชาญวิเคราะห์"),
              )
            ], //<Widget>[]
          ), //Column
        ), //Center
      ), //Container
    );
  }

  String _getDateNow() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }
}