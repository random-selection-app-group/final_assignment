import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/theme_provider.dart';
import '../components/custom_button.dart';
import 'RoulettePage.dart';

class CreateThemeScreen extends StatefulWidget {
  final int? themeIndex;

  CreateThemeScreen({this.themeIndex});

  @override
  _CreateThemeScreenState createState() => _CreateThemeScreenState();
}

class _CreateThemeScreenState extends State<CreateThemeScreen> {
  final _themeNameController = TextEditingController(); // 主题名称
  final _descriptionController = TextEditingController(); // 描述
  final List<TextEditingController> _optionControllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.themeIndex != null) {
      final theme = Provider.of<ThemeProvider>(context, listen: false)
          .themes[widget.themeIndex!];
      _themeNameController.text = theme.name;
      _descriptionController.text = theme.description;
      for (var option in theme.options) {
        _optionControllers.add(TextEditingController(text: option));
      }
    } else {
      _optionControllers.add(TextEditingController());
    }
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    setState(() {
      _optionControllers.removeAt(index);
    });
  }

  void _saveTheme() {
    final theme = ThemeModel(
      name: _themeNameController.text,
      description: _descriptionController.text,
      options: _optionControllers.map((controller) => controller.text).toList(),
    );

    if (widget.themeIndex == null) {
      Provider.of<ThemeProvider>(context, listen: false).addTheme(theme);
    } else {
      Provider.of<ThemeProvider>(context, listen: false)
          .updateTheme(widget.themeIndex!, theme);
    }

    Navigator.pop(context);
  }

  void _startChoosing() {
    List<String> options =
        _optionControllers.map((controller) => controller.text).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoulettePage(options: options),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          widget.themeIndex == null ? '创建主题' : '编辑主题',
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
      backgroundColor: Color.fromARGB(255, 226, 240, 254),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _themeNameController,
                decoration: InputDecoration(
                  labelText: '主题名称，例如：聚餐',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: '描述，例如：今天吃什么',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              Text('选项设置', style: TextStyle(fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _optionControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _optionControllers[index],
                            decoration: InputDecoration(
                              labelText: '名称，例如：瓦香鸡',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () => _removeOption(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
              CustomButton(
                onPressed: _addOption,
                text: '添加选项',
              ),
              SizedBox(height: 10),
              CustomButton(
                onPressed: _startChoosing,
                text: '开始选择',
              ),
              SizedBox(height: 10),
              CustomButton(
                onPressed: _saveTheme,
                text: '保存到 “我的主题”',
              ),
              SizedBox(height: 80), // 确保底部内容不被键盘遮挡
            ],
          ),
        ),
      ),
    );
  }
}
