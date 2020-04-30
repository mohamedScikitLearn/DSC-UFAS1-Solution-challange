import 'dart:io';
import 'package:covid19/displayResult.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ImagePreview extends StatefulWidget
{
    File image;
    ImagePreview({this.image});
    @override
    State<StatefulWidget> createState() {
      return ImagePreviewState();
    }
}
class ImagePreviewState extends State<ImagePreview>
{
    bool showActivityIncdicator = false;
    static BaseOptions options = new BaseOptions(connectTimeout: 30000,receiveTimeout: 30000,sendTimeout: 30000);
    static Dio dio = new Dio(options);
    static String api = "http://localhost:5008/predictCovid";  
    


    void initState()
    {
      super.initState();
    }
    @override
    Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      Widget submit_btn = SizedBox(
        width: width,
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
          elevation: 0,
          child: Text((!showActivityIncdicator ? "analyze scan" : "waiting...").toUpperCase(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Poppins",color: Colors.white),),
          color: (showActivityIncdicator) ? Colors.grey : Color(0xFF2DCE89),
          onPressed: submit,
        ),
      );
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(65),
                child: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top:10),
                      child: Icon(Icons.arrow_back_ios, color: Colors.black),
                    )
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(top:10),
                    child: Image.asset("assets/logo_black.png",width: 50),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              body: Builder(
                builder: (context) => Center(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Center(
                        child: (widget.image == null) ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.black)) : Center(
                          child: Image.file(widget.image,width: width,),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: submit_btn,
                        ),
                      )
                    ],
                  )
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
          ? Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
                      SizedBox(height: 30,),
                      Text("Sending scan to the server...",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12,fontFamily: "Poppins"),)
                    ],
                  ),
                ),
              ),
            )
          : Container(width: 0,height: 0,)
      ;
    }

    void submit() async
    {
          setState(() {
            showActivityIncdicator = true;
          });
          // starting request :
          String fileName = this.widget.image.path.split('/').last;
          FormData data = FormData.fromMap({
            "file": await MultipartFile.fromFile(
              widget.image.path,
              filename: fileName,
            ),
          });

          try{
            Response response = await dio.post(api,data: data);
            Color color;
            String text;
            setState(() {
              showActivityIncdicator = false;
            });
            if(response.data == "This might be a Pneumonia case")
            {
              text = "PNEUMONIA";
              color = Color(0xFFF5365C);
            }else{
              if(response.data =="POSITIVE COVID-19 Test")
              {
                text = "COVID POSITIVE";
                color = Color(0xFFF5365C);
              }else{
                text = "NORMAL";
                color = Color(0xFF2DCE89);
              }
            }
            Navigator.push(
              context,MaterialPageRoute(builder:(context) => DisplayResult(image: widget.image,text: text,color: color)),
            );
          }on DioError catch(e)
          {
              setState(() {
                showActivityIncdicator = false;
              });
              if (e.type == DioErrorType.RESPONSE) {
                _showDialog("Cannot connect to the server !");
              }
              if (e.type == DioErrorType.CONNECT_TIMEOUT) {
                _showDialog("Verify your internet connection !");
              }
              if (e.type == DioErrorType.SEND_TIMEOUT) {
                _showDialog("Verify your internet connection !");
              }
              if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
                _showDialog("Verify your internet connection !");
              }
              if (e.type == DioErrorType.CANCEL) {
                _showDialog("The request has been canceled !");
              }
              if (e.type == DioErrorType.DEFAULT) {
                _showDialog("Cannot connect to the server !");
              }
           }
    }

    void _showDialog(String body)
    {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Error",style: TextStyle(fontFamily: 'Poppins',color: Colors.black,fontWeight: FontWeight.bold),),
              content: new Text(body,style: TextStyle(fontFamily: "Poppins",color: Colors.black,fontWeight: FontWeight.bold),),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
    }

}
