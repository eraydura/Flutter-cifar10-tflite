import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: ResimSecimi()
            )
        )
    );
  }
}

class ResimSecimi extends StatefulWidget {
  @override
  ResimSecimiState createState() => ResimSecimiState();
}

class ResimSecimiState extends State<ResimSecimi> {
  bool modelLoaded;
  File imageURI;
  String result;
  String path;

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageURI = image;
      path = image.path;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageURI = image;
      path = image.path;
    });
  }
  Future classifyImage() async {
    await Tflite.loadModel(model: "assets/finalmodel.tflite",labels: "assets/label.txt");
    var output = await Tflite.runModelOnImage(path: path);
    setState(() {
      result = output.last["label"].toString().toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageURI == null
                      ? Text('Resim seçilmedi.')
                      : Image.file(imageURI,
                      width: 300, height: 200, fit: BoxFit.cover),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: FlatButton.icon(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () => getImageFromCamera(),
                        label: Text('Kamerayı Aç'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: FlatButton.icon(
                        icon: Icon(Icons.image),
                        onPressed: () => getImageFromGallery(),
                        label: Text('Galeriden Seç'),
                        textColor: Colors.white,
                        color: Colors.orange,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: FlatButton.icon(
                        icon: Icon(Icons.play_circle_outline),
                        onPressed: () => classifyImage(),
                        label: Text('Görüntüyü Sınıflandır'),
                        textColor: Colors.white,
                        color: Colors.green,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),
                  result == null
                      ? Text(
                    'Sonuç:',
                    style: TextStyle(fontSize: 22),
                  )
                      : Text(result, style: TextStyle(fontSize: 22))
                ])));
  }

  static Future<String> loadModel() async{
    return Tflite.loadModel(
      model: "assets/finalmodel.tflite",
      labels: "assets/label.txt",
    );
  }
  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
        modelLoaded = true;
      });
    });
  }


}



