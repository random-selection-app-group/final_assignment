import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class instructionScreen extends StatefulWidget {
  @override
  _instructionScreenState createState() => _instructionScreenState();
}

class _instructionScreenState extends State<instructionScreen>{

  Future<String> loadTextFromFile(String filePath) async {
      final file = File(filePath);
      return await file.readAsString();
  }

  Widget build(BuildContext context) {
    Dio _dio = Dio();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 226, 240, 254),
      appBar:  AppBar(
        backgroundColor: Color.fromARGB(255, 183, 220, 255),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(
          '软件说明',
          style: TextStyle(
            fontFamily: "Font3",
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.normal,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:Container(
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 3, color:Color.fromARGB(255, 183, 220, 255)), // Add a grey border
              borderRadius: BorderRadius.all(Radius.circular(10)), // Add a rounded corner
          ),
          child:SingleChildScrollView(
            child:FutureBuilder(
              future: _dio.get("https://hyyellowwin.github.io/random-selection-data/"),//可以从远程读取数据，但是网不好的话会握手失败
              //future:loadTextFromFile('assets/index.html'),
              builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                   }
                  final htmlDoc = parse(snapshot.data.toString());
                  final boxElement = htmlDoc.querySelector('.box');
                  final textContent = boxElement?.text;
                   return Text(
                    textContent ?? '',
                     style: TextStyle(
                      fontFamily: "仿宋-GB2312",
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ),
        )
      ),
    );
  }
}