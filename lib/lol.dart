import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mass/Setup/HisForExpert.dart';
import 'package:mass/Setup/History.dart';
import 'package:mass/Setup/Location.dart';
import 'package:mass/Setup/SignIn.dart';
import 'package:mass/Setup/analysis.dart';

class LOL extends StatelessWidget {
  const LOL({
    Key key,
    @required this.user
  }) : super(key: key);
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return Scaffold(
      backgroundColor: Color(0xFFEBE4D6),
      appBar: new AppBar(
        backgroundColor: Color(0xFFEBE4D6),
        title: new Center(child: new Text('',textAlign: TextAlign.center,style: TextStyle(fontSize: 50),)),
      ),
      body: new ListView(children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Function1(teks: "วิเคราะห์เกรดเนื้อ"),
                Function2(teks: "ตำแหน่งเนื้อ"),
              ],),
            SizedBox(
              height: 50.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Function3(teks: "ประวัติการวิเคราะห์"),
                Function4(teks: "ประวัติส่งให้ผู้เชี่ยวชาญ"),
              ],),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Function5(teks: "ออกจากระบบ"),
//                Function6(teks: "ให้คะแนนแอป"),
              ],
            ),
          ],
        ),
      ],
      ),
    );
  }
}

class Function1 extends StatelessWidget{ //class สร้างfunction

  Function1 ({this.teks});

  final String teks;

  @override
  Widget build(BuildContext context){
    return new Container(
      decoration: new BoxDecoration(
          color: Color(0xFFEBE4D6),borderRadius: new BorderRadius.circular(0.0)
      ),
      alignment: Alignment.center,
      padding: new EdgeInsets.only(left: 5.0, right: 5.0, top: 30.0, bottom: 30.0),//ระยะห่างของแต่ละบรรทัด
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => App()
          )); //MaterialPageRoute
        },
        child: new Column(
          children: <Widget>[
            new Image.asset('assets/research.png',width: 125.0,height: 125.0,fit: BoxFit.cover,),
            new Text(teks, style: new TextStyle(fontSize: 20.0,color: Colors.black54),),
            new Padding(padding: new EdgeInsets.all(0.0),),

          ],
        ),
      ),
    );
  }
}
class Function2 extends StatelessWidget{ //class สร้างfunction

  Function2 ({this.teks});

  final String teks;

  @override
  Widget build(BuildContext context){
    return new Container(
      decoration: new BoxDecoration(
          color: Color(0xFFEBE4D6),borderRadius: new BorderRadius.circular(0.0)),
      alignment: Alignment.center,
      padding: new EdgeInsets.only(left: 5.0, right: 5.0, top: 30.0, bottom: 30.0),//ระยะห่างของแต่ละบรรทัด
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => LocationPage()
          )); //MaterialPageRoute
        },
        child: new Column(
          children: <Widget>[
            new Image.asset('assets/position.png',width: 125.0,height: 125.0,fit: BoxFit.cover,),
            new Text(teks, style: new TextStyle(fontSize: 20.0,color: Colors.black54),),
            new Padding(padding: new EdgeInsets.all(0.0),),
          ],
        ),
      ),
    );
  }
}

class Function3 extends StatelessWidget{ //class สร้างfunction

  Function3 ({this.teks});

  final String teks;

  @override
  Widget build(BuildContext context){
    return new Container(
      decoration: new BoxDecoration(
          color: Color(0xFFEBE4D6),borderRadius: new BorderRadius.circular(0.0)
      ),
      alignment: Alignment.center,
      padding: new EdgeInsets.only(left: 5.0, right: 5.0, top: 30.0, bottom: 30.0),//ระยะห่างของแต่ละบรรทัด
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => HisAna()
          )); //MaterialPageRoute
        },
        child: new Column(
          children: <Widget>[
            new Image.asset('assets/hisana.png',width: 125.0,height: 125.0,fit: BoxFit.cover,),
            new Text(teks, style: new TextStyle(fontSize: 20.0,color: Colors.black54),),
            new Padding(padding: new EdgeInsets.all(0.0),),
          ],
        ),
      ),
    );
  }
}

class Function4 extends StatelessWidget{ //class สร้างfunction

  Function4 ({this.teks});

  final String teks;

  @override
  Widget build(BuildContext context){
    return new Container(
      decoration: new BoxDecoration(
          color: Color(0xFFEBE4D6),borderRadius: new BorderRadius.circular(0.0)
      ),
      alignment: Alignment.center,
      padding: new EdgeInsets.only(left: 5.0, right: 5.0, top: 30.0, bottom: 30.0),//ระยะห่างของแต่ละบรรทัด
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => HisForEx()
          )); //MaterialPageRoute
        },
        child: new Column(
          children: <Widget>[
            new Image.asset('assets/checklist.png',width: 125.0,height: 125.0,fit: BoxFit.cover,),
            new Text(teks, style: new TextStyle(fontSize: 20.0,color: Colors.black54),),
            new Padding(padding: new EdgeInsets.all(0.0),),
          ],
        ),
      ),
    );
  }
}

class Function5 extends StatelessWidget{ //class สร้างfunction

  Function5 ({this.teks});

  final String teks;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context){
    return new Container(
      decoration: new BoxDecoration(
          color: Color(0xFFEBE4D6),borderRadius: new BorderRadius.circular(0.0)
      ),
      alignment: Alignment.center,
      padding: new EdgeInsets.only(left: 5.0, right: 5.0, top: 30.0, bottom: 30.0),//ระยะห่างของแต่ละบรรทัด
      child: GestureDetector(
        onTap: () {
          signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => LoginPageV2()
          )); //MaterialPageRoute
        },
        child: new Column(
          children: <Widget>[
            new Image.asset('assets/logout.png',width: 125.0,height: 125.0,fit: BoxFit.cover,),
            new Text(teks, style: new TextStyle(fontSize: 20.0,color: Colors.black54),),
            new Padding(padding: new EdgeInsets.all(0.0),),
          ],
        ),
      ),
    );
  }
  void signOut() async{
    _firebaseAuth.signOut();
  }
}

