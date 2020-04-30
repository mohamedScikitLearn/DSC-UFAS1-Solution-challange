import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayResult extends StatefulWidget
{
  File image;
  String text;
  Color color;
  DisplayResult({this.image,this.text,this.color});
  @override
  State<StatefulWidget> createState() {
    return DisplayResultState();
  }
}
class DisplayResultState extends State<DisplayResult>
{
  void initState()
  {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                        Navigator.of(context).pop(true);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top:10),
                      child: Icon(Icons.close, color: Colors.black),
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
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                              Image.file(widget.image,width: width,),
                              SizedBox(height: 20,),
                              Column(
                                children: <Widget>[
                                  Icon(CupertinoIcons.check_mark_circled,color:  Color(0xFF8259E8), size: 120,),
                                  SizedBox(height: 5,),
                                  Text("Finished",style: TextStyle(fontFamily: "Poppins",fontSize: 12,color:  Color(0xFF8259E8),fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(height: 20,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                                child: SizedBox(
                                  width: width,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                      decoration: BoxDecoration(
                                        color:this.widget.color,
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                    child: Center(
                                      child: Text(this.widget.text.toUpperCase(),style:TextStyle(fontFamily: "Poppins",fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold) ,),
                                    )
                                  ),
                                ),
                              )
                          ],
                        ),
                      )
                    ],
                  )
              ),
            )
        ),
      ],
    );
  }

}
