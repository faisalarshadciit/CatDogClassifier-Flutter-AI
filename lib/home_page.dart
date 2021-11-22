import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _loading = true;
  File _image;
  List _output;
  final picker = ImagePicker();

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadModel().then((value) {
      setState(() {

      });
    });
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);

    if(image == null) {
      return null;
    }

    setState(() {
      _image = File(image.path);
    });
    
    detectImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    if(image == null) {
      return null;
    }

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.0),
            Text("Coding Cafe", style: TextStyle(
                color: Colors.white,
                fontSize: 20.0),
            ),
            SizedBox(height: 5.0),
            Text("Cats and Dogs Detector App",
              style: TextStyle(
                  //color: Color(0X7D9E9E),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 30.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50.0),
            Center(
              child: _loading
                  ? Container(
                width: 350.0,
                child: Column(
                  children: [
                    Image.asset("assets/cat_dog_icon.png"),
                    SizedBox(height: 50.0),
                  ],
                ),
              )
                  : Container(
                child: Column(
                  children: [
                    Container(
                      height: 250.0,
                      child: Image.file(_image),
                    ),
                    SizedBox(height: 20.0),
                    _output != null
                        ? Text('${_output[0]['label']}',
                      style: TextStyle(color: Colors.white, fontSize: 15.0),)
                        : Container(),
                    SizedBox(height: 10.0),
                  ],
                ),
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 200.0,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Text(
                        "Capture a Photo",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  GestureDetector(
                    onTap: () {
                      pickGalleryImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 200.0,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Text(
                        "Select from Gallery",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
