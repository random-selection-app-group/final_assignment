import 'dart:io';
import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import '../state/truth_or_dare_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class addDareScreen extends StatefulWidget {
  @override
  _addDareScreenState createState() => _addDareScreenState();
}

class _addDareScreenState extends State<addDareScreen>{
  final TextEditingController _dareController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _reload = true;

  Future<String> loadTextFromFile(String filePath) async {
      final file = File(filePath);
      return await file.readAsString();
  }

  Future<void> writeCounter(String counter) async { //可以正常在文件后面追加内容了
    final file = await File('assets/dare.txt');
    final sink = file.openWrite(mode: FileMode.append);
    sink.write('\n$counter');
    await sink.close();
  }

  @override
  Widget build(BuildContext context) {
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
          '添加大冒险',
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
                controller: _dareController,
                labelText: '大冒险',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入大冒险';
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
                        .addDareQuestion(_dareController.text);
                    setState(() {
                      _reload = true;
                    });
                    _dareController.clear(); //点击添加后，文本框清空
                  }
                },
              ),
              SizedBox(height: 20),
              Text(
                '大冒险列表',
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
                height: 340, // fixed height
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color:Color.fromARGB(255, 183, 220, 255)), // Add a grey border
                  borderRadius: BorderRadius.all(Radius.circular(10)), // Add a rounded corner
                ),
                child: SingleChildScrollView(
                  child:FutureBuilder(
                    future: _reload ? loadTextFromFile('assets/dare.txt') : null,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data.toString(),
                          style: TextStyle(
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
