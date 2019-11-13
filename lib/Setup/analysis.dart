import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';



const String mobile = "MobileNet";
const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";
const String deeplab = "DeepLab";
const String posenet = "PoseNet";

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;
  File _image;
  List _recognitions;
  String _model = mobile;
  double _imageHeight;
  double _imageWidth;
  bool _busy = false;
  String _userId;


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  Future predictImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(image);
  }
  Future cameraPicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(image);
  }


  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        fileName);
    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    FirebaseDatabase.instance.reference().child('UserHistory').child(
        '$_userId')
        .child(_getDateNow()).set({
      'Date': _getDateNow(),
      'Url_Picture' : '$url',
      'Score' : _recognitions,
    });
    FirebaseDatabase.instance.reference().child('UserHistory').child(_getDateNow()).set({
      'UID' : '$_userId',
      'Date': _getDateNow(),
      'Url_Picture' : '$url',
      'Score' : _recognitions,
    });
  }

  Future uploadPic2(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        fileName);
    final StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

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
    FirebaseDatabase.instance.reference().child('ForExpertHistory').
    child('$_userId').child(_getDateNow()).set({
      'Date': _getDateNow(),
      'Url_Picture': '$url',
    },);
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
                  predictImagePicker();
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("กล้อง"),
                onTap: () {
                  cameraPicker();
                }, //onTap
              ) //GestureDetector
            ], //<>Widget[]
          ), //ListBody
        ), //SingleChildScrollView
      ); //AlertDialog
    });
  }

  Future predictImage(File image) async {
    if (image == null) return;

    switch (_model) {
//      case yolo:
//        await yolov2Tiny(image);
//        break;
//      case ssd:
//        await ssdMobileNet(image);
//        break;
//      case deeplab:
//        await segmentMobileNet(image);
//        break;
//      case posenet:
//        await poseNet(image);
//        break;
      default:
        await recognizeImage(image);
    // await recognizeImageBinary(image);
    }

    new FileImage(image)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }


  Future loadModel() async {
    Tflite.close();
    try {
      String res;
      switch (_model) {
//        case yolo:
//          res = await Tflite.loadModel(
//            model: "assets/yolov2_tiny.tflite",
//            labels: "assets/yolov2_tiny.txt",
//          );
//          break;
//        case ssd:
//          res = await Tflite.loadModel(
//              model: "assets/ssd_mobilenet.tflite",
//              labels: "assets/ssd_mobilenet.txt");
//          break;
//        case deeplab:
//          res = await Tflite.loadModel(
//              model: "assets/deeplabv3_257_mv_gpu.tflite",
//              labels: "assets/deeplabv3_257_mv_gpu.txt");
//          break;
//        case posenet:
//          res = await Tflite.loadModel(
//              model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
//          break;
        default:
          res = await Tflite.loadModel(
            //model: "assets/mobilenet_v1_1.0_224.tflite",
            //labels: "assets/mobilenet_v1_1.0_224.txt",
            model: "assets/mobilenet_v1_1.0_224.lite",
            labels: "assets/mobilenet_v1_1.0_224.txt",
          );
      }
      print(res);
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  Uint8List imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  Uint8List imageToByteListUint8(img.Image image, int inputSize) {
    var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
    var buffer = Uint8List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = img.getRed(pixel);
        buffer[pixelIndex++] = img.getGreen(pixel);
        buffer[pixelIndex++] = img.getBlue(pixel);
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  Future recognizeImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

  Future recognizeImageBinary(File image) async {
    var imageBytes = (await rootBundle.load(image.path)).buffer;
    img.Image oriImage = img.decodeJpg(imageBytes.asUint8List());
    img.Image resizedImage = img.copyResize(oriImage);
    var recognitions = await Tflite.runModelOnBinary(
      binary: imageToByteListFloat32(resizedImage, 224, 127.5, 127.5),
      numResults: 6,
      threshold: 0.05,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

//  Future yolov2Tiny(File image) async {
//    var recognitions = await Tflite.detectObjectOnImage(
//      path: image.path,
//      model: "YOLO",
//      threshold: 0.3,
//      imageMean: 0.0,
//      imageStd: 255.0,
//      numResultsPerClass: 1,
//    );
    // var imageBytes = (await rootBundle.load(image.path)).buffer;
    // img.Image oriImage = img.decodeJpg(imageBytes.asUint8List());
    // img.Image resizedImage = img.copyResize(oriImage, 416, 416);
    // var recognitions = await Tflite.detectObjectOnBinary(
    //   binary: imageToByteListFloat32(resizedImage, 416, 0.0, 255.0),
    //   model: "YOLO",
    //   threshold: 0.3,
    //   numResultsPerClass: 1,
    // );
//    setState(() {
//      _recognitions = recognitions;
//    });
//  }

//  Future ssdMobileNet(File image) async {
//    var recognitions = await Tflite.detectObjectOnImage(
//      path: image.path,
//      numResultsPerClass: 1,
//    );
    // var imageBytes = (await rootBundle.load(image.path)).buffer;
    // img.Image oriImage = img.decodeJpg(imageBytes.asUint8List());
    // img.Image resizedImage = img.copyResize(oriImage, 300, 300);
    // var recognitions = await Tflite.detectObjectOnBinary(
    //   binary: imageToByteListUint8(resizedImage, 300),
    //   numResultsPerClass: 1,
    // );
//    setState(() {
//      _recognitions = recognitions;
//    });
//  }

//  Future segmentMobileNet(File image) async {
//    var recognitions = await Tflite.runSegmentationOnImage(
//      path: image.path,
//      imageMean: 127.5,
//      imageStd: 127.5,
//    );

//    setState(() {
//      _recognitions = recognitions;
//    });
//  }

//  Future poseNet(File image) async {
//    var recognitions = await Tflite.runPoseNetOnImage(
//      path: image.path,
//      numResults: 2,
//    );

//    print(recognitions);

//    setState(() {
//      _recognitions = recognitions;
//    });
//  }

  onSelect(model) async {
    setState(() {
      _busy = true;
      _model = model;
      _recognitions = null;
    });
    await loadModel();

    if (_image != null)
      predictImage(_image);
    else
      setState(() {
        _busy = false;
      });
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;
    Color blue = Color.fromRGBO(37, 213, 253, 1.0);
    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: blue,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> renderKeypoints(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;

    var lists = <Widget>[];
    _recognitions.forEach((re) {
      var color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(1.0);
      var list = re["keypoints"].values.map<Widget>((k) {
        return Positioned(
          left: k["x"] * factorX - 6,
          top: k["y"] * factorY - 6,
          width: 100,
          height: 12,
          child: Container(
            child: Text(
              "● ${k["part"]}",
              style: TextStyle(
                color: color,
                fontSize: 12.0,
              ),
            ),
          ),
        );
      }).toList();

      lists..addAll(list);
    });

    return lists;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((user) {
      _userId = user.uid;
    });
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    if (_model == deeplab && _recognitions != null) {
      stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        child: _image == null
            ? Text('ไม่มีรูปที่จะวิเคราะห์.')
            : Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: MemoryImage(_recognitions),
                    fit: BoxFit.fill)),
            child: Opacity(opacity: 0.3, child: Image.file(_image))),
      ));
    } else {
      stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        child: _image == null ? Text('ไม่มีรูปที่จะวิเคราะห์.') : Image.file(_image),
      ));
    }

    if (_model == mobile) {
      stackChildren.add(Center(
        child: Column(
          children: _recognitions != null
              ? _recognitions.map((res) {
            return Text(
              "${res["index"]} - ${res["label"]}: ${res["confidence"].toStringAsFixed(3)}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                background: Paint()..color = Colors.white,
              ),
            );
          }).toList()
              : [],
        ),
       ),
      );
    } //else if (_model == ssd || _model == yolo) {
      //stackChildren.addAll(renderBoxes(size));
    //} else if (_model == posenet) {
     // stackChildren.addAll(renderKeypoints(size));
    //}

    if (_busy) {
      stackChildren.add(const Opacity(
        child: ModalBarrier(dismissible: false, color: Colors.grey),
        opacity: 0.3,
      ));
      stackChildren.add(const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: <Widget>[
          RaisedButton(
            color: Colors.blue,
            onPressed: (){
              uploadPic2(context);
            },
            child: Text('ส่งให้ผู้เชี่ยวชาญวิเคราะห์',style: TextStyle(color: Colors.white),),
          ),
          RaisedButton(
            color: Colors.blue,
            onPressed: (){
              uploadPic(context);
            },
            child: Text('บันทึกลงในประวัติการวิเคราะห์',style: TextStyle(color: Colors.white),),
          ),
//          PopupMenuButton<String>(
//            onSelected: onSelect,
//            itemBuilder: (context) {
//              List<PopupMenuEntry<String>> menuEntries = [
//                const PopupMenuItem<String>(
//                  child: Text('วิเคราะห์'),
//                  value: mobile,
//                ),
//                  const PopupMenuItem<String>(
//                  child: Text(yolo),
//                  value: yolo,
//                ),
//                const PopupMenuItem<String>(
//                  child: Text(deeplab),
//                  value: deeplab,
//                ),
//                const PopupMenuItem<String>(
//                  child: Text(posenet),
//                  value: posenet,
//                )ม
//             ];
//              return menuEntries;
//            },
//          ),
        ],
      ),
      body: Stack(
        children: stackChildren,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showChoiceDialog(context);
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.image),
      ),
    );
  }

  String _getDateNow() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  Future _goToMe() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              currentLocation.latitude,
              currentLocation.longitude),
        )));
  }

}



class Tflite {
  static const MethodChannel _channel = const MethodChannel('tflite');

  static Future<String> loadModel({
    @required String model,
    String labels = "",
    int numThreads = 1,
  }) async {
    return await _channel.invokeMethod(
      'loadModel',
      {"model": model, "labels": labels, "numThreads": numThreads},
    );
  }

  static Future<List> runModelOnImage(
      {@required String path,
        double imageMean = 117.0,
        double imageStd = 1.0,
        int numResults = 5,
        double threshold = 0.1,
        bool asynch = true}) async {
    return await _channel.invokeMethod(
      'runModelOnImage',
      {
        "path": path,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "numResults": numResults,
        "threshold": threshold,
        "asynch": asynch,
      },
    );
  }

  static Future<List> runModelOnBinary(
      {@required Uint8List binary,
        int numResults = 5,
        double threshold = 0.1,
        bool asynch = true}) async {
    return await _channel.invokeMethod(
      'runModelOnBinary',
      {
        "binary": binary,
        "numResults": numResults,
        "threshold": threshold,
        "asynch": asynch,
      },
    );
  }

  static Future<List> runModelOnFrame(
      {@required List<Uint8List> bytesList,
        int imageHeight = 1280,
        int imageWidth = 720,
        double imageMean = 127.5,
        double imageStd = 127.5,
        int rotation: 90, // Android only
        int numResults = 5,
        double threshold = 0.1,
        bool asynch = true}) async {
    return await _channel.invokeMethod(
      'runModelOnFrame',
      {
        "bytesList": bytesList,
        "imageHeight": imageHeight,
        "imageWidth": imageWidth,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "rotation": rotation,
        "numResults": numResults,
        "threshold": threshold,
        "asynch": asynch,
      },
    );
  }

  static const anchors = [
    0.57273,
    0.677385,
    1.87446,
    2.06253,
    3.33843,
    5.47434,
    7.88282,
    3.52778,
    9.77052,
    9.16828
  ];

//  static Future<List> detectObjectOnImage({
//    @required String path,
//    String model = "SSDMobileNet",
//    double imageMean = 127.5,
//    double imageStd = 127.5,
//    double threshold = 0.1,
//    int numResultsPerClass = 5,
//    // Used in YOLO only
//    List anchors = anchors,
//    int blockSize = 32,
//    int numBoxesPerBlock = 5,
//    bool asynch = true,
//  }) async {
//    return await _channel.invokeMethod(
//      'detectObjectOnImage',
//      {
//        "path": path,
//        "model": model,
//        "imageMean": imageMean,
//        "imageStd": imageStd,
//        "threshold": threshold,
//        "numResultsPerClass": numResultsPerClass,
//        "anchors": anchors,
//        "blockSize": blockSize,
//        "numBoxesPerBlock": numBoxesPerBlock,
//        "asynch": asynch,
//      },
//    );
//  }
//
//  static Future<List> detectObjectOnBinary({
//    @required Uint8List binary,
//    String model = "SSDMobileNet",
//    double threshold = 0.1,
//    int numResultsPerClass = 5,
//    // Used in YOLO only
//    List anchors = anchors,
//    int blockSize = 32,
//    int numBoxesPerBlock = 5,
//    bool asynch = true,
//  }) async {
//    return await _channel.invokeMethod(
//      'detectObjectOnBinary',
//      {
//        "binary": binary,
//        "model": model,
//        "threshold": threshold,
//        "numResultsPerClass": numResultsPerClass,
//        "anchors": anchors,
//        "blockSize": blockSize,
//        "numBoxesPerBlock": numBoxesPerBlock,
//        "asynch": asynch,
//      },
//    );
//  }
//
//  static Future<List> detectObjectOnFrame({
//    @required List<Uint8List> bytesList,
//    String model = "SSDMobileNet",
//    int imageHeight = 1280,
//    int imageWidth = 720,
//    double imageMean = 127.5,
//    double imageStd = 127.5,
//    double threshold = 0.1,
//    int numResultsPerClass = 5,
//    int rotation: 90, // Android only
//    // Used in YOLO only
//    List anchors = anchors,
//    int blockSize = 32,
//    int numBoxesPerBlock = 5,
//    bool asynch = true,
//  }) async {
//    return await _channel.invokeMethod(
//      'detectObjectOnFrame',
//      {
//        "bytesList": bytesList,
//        "model": model,
//        "imageHeight": imageHeight,
//        "imageWidth": imageWidth,
//        "imageMean": imageMean,
//        "imageStd": imageStd,
//        "rotation": rotation,
//        "threshold": threshold,
//        "numResultsPerClass": numResultsPerClass,
//        "anchors": anchors,
//        "blockSize": blockSize,
//        "numBoxesPerBlock": numBoxesPerBlock,
//        "asynch": asynch,
//      },
//    );
//  }

  static Future close() async {
    return await _channel.invokeMethod('close');
  }

  static Future<Uint8List> runPix2PixOnImage(
      {@required String path,
        double imageMean = 0,
        double imageStd = 255.0,
        String outputType = "png",
        bool asynch = true}) async {
    return await _channel.invokeMethod(
      'runPix2PixOnImage',
      {
        "path": path,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "asynch": asynch,
        "outputType": outputType,
      },
    );
  }

  static Future<Uint8List> runPix2PixOnBinary(
      {@required Uint8List binary,
        String outputType = "png",
        bool asynch = true}) async {
    return await _channel.invokeMethod(
      'runPix2PixOnBinary',
      {
        "binary": binary,
        "asynch": asynch,
        "outputType": outputType,
      },
    );
  }

  static Future<Uint8List> runPix2PixOnFrame({
    @required List<Uint8List> bytesList,
    int imageHeight = 1280,
    int imageWidth = 720,
    double imageMean = 0,
    double imageStd = 255.0,
    int rotation: 90, // Android only
    String outputType = "png",
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runPix2PixOnFrame',
      {
        "bytesList": bytesList,
        "imageHeight": imageHeight,
        "imageWidth": imageWidth,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "rotation": rotation,
        "asynch": asynch,
        "outputType": outputType,
      },
    );
  }

  // https://github.com/meetshah1995/pytorch-semseg/blob/master/ptsemseg/loader/pascal_voc_loader.py
  static List<int> pascalVOCLabelColors = [
    Color.fromARGB(255, 0, 0, 0).value, // background
    Color.fromARGB(255, 128, 0, 0).value, // aeroplane
    Color.fromARGB(255, 0, 128, 0).value, // biyclce
    Color.fromARGB(255, 128, 128, 0).value, // bird
    Color.fromARGB(255, 0, 0, 128).value, // boat
    Color.fromARGB(255, 128, 0, 128).value, // bottle
    Color.fromARGB(255, 0, 128, 128).value, // bus
    Color.fromARGB(255, 128, 128, 128).value, // car
    Color.fromARGB(255, 64, 0, 0).value, // cat
    Color.fromARGB(255, 192, 0, 0).value, // chair
    Color.fromARGB(255, 64, 128, 0).value, // cow
    Color.fromARGB(255, 192, 128, 0).value, // diningtable
    Color.fromARGB(255, 64, 0, 128).value, // dog
    Color.fromARGB(255, 192, 0, 128).value, // horse
    Color.fromARGB(255, 64, 128, 128).value, // motorbike
    Color.fromARGB(255, 192, 128, 128).value, // person
    Color.fromARGB(255, 0, 64, 0).value, // potted plant
    Color.fromARGB(255, 128, 64, 0).value, // sheep
    Color.fromARGB(255, 0, 192, 0).value, // sofa
    Color.fromARGB(255, 128, 192, 0).value, // train
    Color.fromARGB(255, 0, 64, 128).value, // tv-monitor
  ];

  static Future<Uint8List> runSegmentationOnImage(
      {@required String path,
        double imageMean = 0,
        double imageStd = 255.0,
        List<int> labelColors,
        String outputType = "png",
        bool asynch = true}) async {
    return await _channel.invokeMethod(
      'runSegmentationOnImage',
      {
        "path": path,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "labelColors": labelColors ?? pascalVOCLabelColors,
        "outputType": outputType,
        "asynch": asynch,
      },
    );
  }

  static Future<Uint8List> runSegmentationOnBinary(
      {@required Uint8List binary,
        List<int> labelColors,
        String outputType = "png",
        bool asynch = true}) async {
    return await _channel.invokeMethod(
      'runSegmentationOnBinary',
      {
        "binary": binary,
        "labelColors": labelColors ?? pascalVOCLabelColors,
        "outputType": outputType,
        "asynch": asynch,
      },
    );
  }

  static Future<Uint8List> runSegmentationOnFrame(
      {@required List<Uint8List> bytesList,
        int imageHeight = 1280,
        int imageWidth = 720,
        double imageMean = 0,
        double imageStd = 255.0,
        int rotation: 90, // Android only
        List<int> labelColors,
        String outputType = "png",
        bool asynch = true}) async {
    return await _channel.invokeMethod(
      'runSegmentationOnFrame',
      {
        "bytesList": bytesList,
        "imageHeight": imageHeight,
        "imageWidth": imageWidth,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "rotation": rotation,
        "labelColors": labelColors ?? pascalVOCLabelColors,
        "outputType": outputType,
        "asynch": asynch,
      },
    );
  }

  static Future<List> runPoseNetOnImage(
      {@required String path,
        double imageMean = 127.5,
        double imageStd = 127.5,
        int numResults = 5,
        double threshold = 0.5,
        int nmsRadius = 20,
        bool asynch = true}) async {
    return await _channel.invokeMethod(
      'runPoseNetOnImage',
      {
        "path": path,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "numResults": numResults,
        "threshold": threshold,
        "nmsRadius": nmsRadius,
        "asynch": asynch,
      },
    );
  }

  static Future<List> runPoseNetOnBinary(
      {@required Uint8List binary,
        int numResults = 5,
        double threshold = 0.5,
        int nmsRadius = 20,
        bool asynch = true}) async {
    return await _channel.invokeMethod(
      'runPoseNetOnBinary',
      {
        "binary": binary,
        "numResults": numResults,
        "threshold": threshold,
        "nmsRadius": nmsRadius,
        "asynch": asynch,
      },
    );
  }

  static Future<List> runPoseNetOnFrame(
      {@required List<Uint8List> bytesList,
        int imageHeight = 1280,
        int imageWidth = 720,
        double imageMean = 127.5,
        double imageStd = 127.5,
        int rotation: 90, // Android only
        int numResults = 5,
        double threshold = 0.5,
        int nmsRadius = 20,
        bool asynch = true}) async {
    return await _channel.invokeMethod(
      'runPoseNetOnFrame',
      {
        "bytesList": bytesList,
        "imageHeight": imageHeight,
        "imageWidth": imageWidth,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "rotation": rotation,
        "numResults": numResults,
        "threshold": threshold,
        "nmsRadius": nmsRadius,
        "asynch": asynch,
      },
    );
  }
}