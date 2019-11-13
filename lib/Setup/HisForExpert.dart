import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HisForEx extends StatefulWidget {
  @override
  _HisForExState createState() => _HisForExState();
}

class _HisForExState extends State<HisForEx> {

  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;
  FirebaseUser currentUser;
  DatabaseReference watchRef;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    item = Item("", "", "","","",);
    _initDB();

  }

  void _initDB() async{
    final FirebaseDatabase database = FirebaseDatabase.instance;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    currentUser = await firebaseAuth.currentUser();
    itemRef = watchRef = database.reference().
    child('ForExpertHistory').
    child(currentUser.uid).
    reference();
    itemRef.onChildAdded.listen(_onEntryAdded);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      itemRef.push().set(item.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (itemRef == null) {
      return Text('ไม่พบข้อมูล....',
        style: TextStyle(fontSize: 40.0, color: Colors.white),);
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text('ประวัติส่งให้ผู้เชี่ยวชาญ'),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Flexible(
              child: FirebaseAnimatedList(
                query: itemRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Image.network(items[index].Picture, width: 200.0,
                                height: 150.0,),
                              SizedBox(height: 10.0),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(items[index].Date),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}

class Item {
  String key;
  String Picture;
  String Date;
  String _userId;
  String value1;
  String value2;

  Item(this.Picture, this.Date, this._userId, this.value1, this.value2);

  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        Picture = snapshot.value["Url_Picture"],
        Date = snapshot.value["Date"],
        _userId = snapshot.value["UID"];

  toJson() {
    return {
      "Url_Picture": Picture,
      "Date": Date,
      "UID": _userId,
    };
  }
}