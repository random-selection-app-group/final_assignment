import 'dart:ffi';
import 'dart:io' as io;
import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import '../state/truth_or_dare_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle; // 用于读取 assets 中的文件


class addTruthScreen extends StatefulWidget {
  @override
  _addTruthScreenState createState() => _addTruthScreenState();
}

class _addTruthScreenState extends State<addTruthScreen>{
  final TextEditingController _truthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int questionIndex = 0;
  List<String> questions = [];
  bool _reload = true;
  
  void initState() {
    super.initState();
    _loadQuestions();
  }

  // void show() {
  // final filePath = 'example.txt'; // 文件路径
  // final lines = File(filePath).readAsLinesSync();
  // final output = StringBuffer();
 
  // for (var i = 0; i < lines.length; i++) {
  //   output.write('${i + 1}. ${lines[i]}\n'); // 添加序号
  // }
 
  // File(filePath).writeAsStringSync(output.toString()); // 写回文件
  // }
  
  Future<void> _loadQuestions() async {
    try {
      final contents = await rootBundle.loadString('assets/truth.txt');
      setState(() {
        questions =
            contents.split('\n').where((line) => line.isNotEmpty).toList();
        //_getRandomQuestion();
      });
    } catch (e) {
      print('Error reading questions file: $e');
    }
  }

  Future<String> loadTextFromFile(String filePath) async {
      final file = File(filePath);
      return await file.readAsString();
  }

  @override
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
          '添加真心话',
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _truthController,
                labelText: '真心话',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入真心话';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: '添加',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Provider.of<TruthOrDareState>(context, listen: false)
                         .addTruthQuestion(_truthController.text);
                    setState(() {
                      _reload = true;
                    });
                    _truthController.clear(); //点击添加后，文本框清空
                  }
                  
                },
              ),
              SizedBox(height: 20),
              Text(
                '真心话列表',
                style: TextStyle(
                  fontFamily: "Font3",
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 2),
                      blurRadius: 1,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container( //信息可以完整显示
                height: 340,
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color:Color.fromARGB(255, 183, 220, 255)), // Add a blue border
                  borderRadius: BorderRadius.all(Radius.circular(10)), // Add a rounded corner
                ),
                child: SingleChildScrollView(
                  child:FutureBuilder(
                    future:  _reload ? loadTextFromFile('assets/truth.txt') : null,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _reload = false;
                        return Text(
                          snapshot.data.toString(),
                          style: TextStyle(
                            fontFamily: "仿宋-GB2312", // Replace with your desired font family
                            fontSize: 18, // Replace with your desired font size
                            color: Colors.black, // Replace with your desired text color
                          ),
                        );  
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )   
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
