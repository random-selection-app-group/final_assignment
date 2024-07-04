import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import '../components/custom_button.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context);

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
          '管理员面板',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: () {
                Navigator.pushNamed(context, '/manage_questions');
              },
              text: '管理问题',
            ),
            SizedBox(height: 20),
            CustomButton(
              onPressed: () async {
                List<Map<String, String>> users = await authState.getAllUsers();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('用户列表'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var user in users)
                              Text('${user.keys.first}: ${user.values.first}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              text:'查看用户',
            ),
            SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                Navigator.pushNamed(context, '/instructions_for_app');
              },
              text: '软件说明',
            ),
          ],
        ),
      ),
    );
  }
}
/*管理员面板，用于展示管理员的功能选项。它包含两个按钮：

“管理问题”按钮：点击后将导航到问题管理页面。
“查看用户”按钮：点击后将显示用户列表的对话框。
在构建时，它使用 Provider.of 获取 AuthState 对象，以便与认证状态进行交互。在点击“查看用户”按钮时，它会调用 authState.getAllUsers() 方法来获取所有用户的信息，并将其显示在对话框中。

其中，对话框包含一个标题 “用户列表”，以及一个包含所有用户信息的列。每个用户的信息都以 “key: value” 的形式显示，其中键为用户名，值为用户ID。*/