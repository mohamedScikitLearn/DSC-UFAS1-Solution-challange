import 'dart:io';
import 'dart:async';
import 'package:covid19/imagePreview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}
class HomeState extends State<Home>
{


    File _image;

    bool showActivityIncdicator = false;
    void initState()
    {
      super.initState();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    Future getFromCamera() async {
        var image = await ImagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          _image = image;
          if(_image!=null)
            Navigator.push(
              context,MaterialPageRoute(builder:(context) => ImagePreview(image: _image)),
            );
        });
    }

    Future getFromGallery() async {
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _image = image;
          if(_image!=null)
            Navigator.push(
              context,MaterialPageRoute(builder:(context) => ImagePreview(image: _image)),
            );
        });
    }

    @override
    Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Scaffold(
              backgroundColor: Colors.white,
              body: Builder(
                builder: (context) => Center(
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Image.asset("assets/logo_black.png",width: width/3,),
                            SizedBox(height: 20),
                            Center(
                              child: Text("AI COVID-19 Detection",style: TextStyle(color: Colors.black,fontFamily: "Poppins",fontSize: 13,fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Center(
                              child: Text("Choose a Chest-Xray Image to analyze",style: TextStyle(color: Colors.black.withOpacity(0.5),fontFamily: "Poppins",fontSize: 12,fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(height: 25,),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap:()
                                    {
                                        getFromCamera();
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(90),
                                              color: Color(0xFF8259E8)
                                          ),
                                          padding: EdgeInsets.all(20),
                                          child: Icon(Icons.photo_camera,color: Colors.white,size: 40,),
                                        ),
                                        SizedBox(height: 10,),
                                        Text("Camera",style: TextStyle(color: Color(0xFF8259E8),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: "Poppins"),)
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: ()
                                    {
                                        getFromGallery();
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(90),
                                              color: Color(0xFF8259E8)
                                          ),
                                          padding: EdgeInsets.all(20),
                                          child: Icon(Icons.photo_library,color: Colors.white,size: 40,),
                                        ),
                                        SizedBox(height: 10,),
                                        Text("Gallery",style: TextStyle(color: Color(0xFF8259E8),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: "Poppins"),)
                                      ],
                                    ),
                                  )
                                ],
                            )
                          ],
                        ),
                        Container()
                      ],
                    ),
                  ),
                ),
              )
          ),
          _buildActivityIndicator(context),
        ],
      );
    }

    Widget _buildActivityIndicator(BuildContext context)
    {
      return (showActivityIncdicator)
          ? Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
        ),
      )
          : Container(width: 0,height: 0,)
      ;
    }
}
