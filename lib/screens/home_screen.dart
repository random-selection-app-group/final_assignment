import 'package:dod1/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import '../state/auth_state.dart';
import 'random_selection_screen.dart'; // 新增的导入

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context);

    List<Widget> _pages = [
      Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // 顶部图片
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'images/top_image.jpg', // 将此路径更新为实际图片路径
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // 按钮行
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // 第一个按钮
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RandomChoiceScreen()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.healing),
                          SizedBox(width: 10),
                          Text('治好你的选择困难症'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 183, 220, 255),
                        minimumSize: Size(double.infinity, 60), // 设置按钮的最小尺寸
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // 第二个按钮
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/gathering_tool');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.party_mode),
                          SizedBox(width: 10),
                          Text('聚会神器'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 183, 220, 255),
                        minimumSize: Size(double.infinity, 60), // 设置按钮的最小尺寸
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/truth_or_dare');
                      },
                      child: Text('开始游戏'),
                    ),
                    if (authState.isAdmin) ...[
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/admin');
                        },
                        child: Text('管理员面板'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ProfileScreen(),
    ];

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
        title: Image.asset(
          'images/FortuneFling.png',
          height: 30,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authState.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 226, 240, 254),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: GNav(
          rippleColor: Color.fromARGB(255, 176, 207, 255),
          hoverColor: Color.fromARGB(255, 255, 255, 255),
          haptic: true,
          tabBorderRadius: 15,
          tabActiveBorder: Border.all(
              color: const Color.fromARGB(255, 255, 255, 255), width: 1),
          tabBorder: Border.all(
              color: const Color.fromARGB(0, 255, 255, 255), width: 0),
          tabShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 183, 221, 255).withOpacity(0.5),
                blurRadius: 8)
          ],
          curve: Curves.easeOutExpo,
          duration: Duration(milliseconds: 200),
          gap: 8,
          color: Color.fromARGB(255, 63, 114, 208),
          activeColor: Colors.white,
          iconSize: 24,
          tabBackgroundGradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 150, 200, 255),
              Color.fromARGB(255, 206, 229, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
              backgroundGradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 150, 200, 255),
                  Color.fromARGB(255, 206, 229, 255)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            GButton(
              icon: LineIcons.user,
              text: 'Profile',
              backgroundGradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 150, 200, 255),
                  Color.fromARGB(255, 206, 229, 255)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
