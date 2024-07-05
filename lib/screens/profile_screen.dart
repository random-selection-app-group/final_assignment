import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../state/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  ImageProvider<Object>? _avatarImage; // 修改类型为 ImageProvider<Object>?

  @override
  void initState() {
    super.initState();
    _loadPrefs(); // 初始化时加载图片路径
  }

  Future<void> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authState = Provider.of<AuthState>(context, listen: false);
    String? imagePath = prefs.getString('avatarPath_${authState.username}');
    setState(() {
      if (imagePath != null && imagePath.isNotEmpty) {
        _avatarImage = FileImage(File(imagePath)); // 使用 FileImage 加载图片
      } else {
        _avatarImage = AssetImage('images/vv.jpg'); // 默认头像
      }
    });
  }

  Future<void> _saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authState = Provider.of<AuthState>(context, listen: false);
    prefs.setString('avatarPath_${authState.username}', imagePath);
  }

  void _updateSelectedImage(File image) {
    setState(() {
      _avatarImage = FileImage(image); // 更新头像图片
    });
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 226, 240, 254),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: _avatarImage, // 显示头像
                  radius: 50,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    '昵称: ${authState.nickname}', // 显示用户名
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.pushNamed(context, '/change_nickname');
                      if (result != null && result is String) {
                        authState.setNickname(result); // 更新昵称并通知UI
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.keyboard,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '修改昵称',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 25, 125, 255),
                      backgroundColor: Color.fromARGB(255, 183, 220, 255),
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _updateSelectedImage(File(pickedFile.path)); // 更新头像
                        _saveImagePath(pickedFile.path); // 保存头像路径
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mms,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '修改头像',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 25, 125, 255),
                      backgroundColor: Color.fromARGB(255, 183, 220, 255),
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/change_password');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.password,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '修改密码',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 25, 125, 255),
                      backgroundColor: Color.fromARGB(255, 183, 220, 255),
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/history');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '历史记录',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 25, 125, 255),
                      backgroundColor: Color.fromARGB(255, 183, 220, 255),
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '退出登录',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 25, 125, 255),
                      backgroundColor: Color.fromARGB(255, 183, 220, 255),
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
