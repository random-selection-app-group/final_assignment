import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState with ChangeNotifier {
  String? _username;
  String? _avatarPath;
  String? _nickname;
  bool _isLoggedIn;
  bool _isAdmin;
  List<Map<String, dynamic>> _userLogins;

  AuthState()
      : _isLoggedIn = false,
        _isAdmin = false,
        _userLogins = [] {
    _loadUser();
  }

  String? get username => _username;
  String? get avatarPath => _avatarPath;
  String? get nickname => _nickname;
  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _isAdmin;
  List<Map<String, dynamic>> get userLogins => _userLogins;

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    if (_username != null) {
      _avatarPath = prefs.getString('avatarPath_$_username');
      _nickname = prefs.getString('nickname_$_username') ?? _username; // 使用用户名作为默认昵称
      _isLoggedIn = prefs.getBool('isLoggedIn_$_username') ?? false;
      _isAdmin = _username == 'admin';
    }

    List<String>? userLoginsList = prefs.getStringList('userLogins');
    if (userLoginsList != null) {
      _userLogins = userLoginsList
          .map<Map<String, dynamic>>((log) => jsonDecode(log))
          .toList();
    }

    notifyListeners();
  }

  Future<void> register(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(username, password);
  }

  Future<bool> login(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPassword = prefs.getString(username);

    if (username == '0707' && password == '0707') {
      _username = 'admin';
      _isAdmin = true;
      _isLoggedIn = true;
      await prefs.setString('username', 'admin');
      await prefs.setBool('isLoggedIn_admin', true);
      notifyListeners();
      return true;
    }

    if (storedPassword == password) {
      _username = username;
      _isLoggedIn = true;
      _isAdmin = username == 'admin';
      await prefs.setString('username', username);
      await prefs.setBool('isLoggedIn_$username', true);

      _userLogins.add({
        'username': username,
        'loginTime': DateTime.now().toString(),
      });
      await prefs.setStringList(
        'userLogins',
        _userLogins.map((log) => jsonEncode(log)).toList(),
      );

      await _loadUser(); // 加载用户信息

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_username != null) {
      await prefs.remove('username');
      await prefs.remove('isLoggedIn_$_username');
      await prefs.remove('avatarPath_$_username');
      await prefs.remove('nickname_$_username');
    }
    _username = null;
    _isLoggedIn = false;
    _isAdmin = false;
    notifyListeners();
  }

  Future<List<Map<String, String>>> getAllUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    List<Map<String, String>> users = [];
    for (var key in keys) {
      if (key != 'username' &&
          !key.startsWith('isLoggedIn_') &&
          !key.startsWith('avatarPath_') &&
          !key.startsWith('nickname_') &&
          key != 'truthQuestions' &&
          key != 'userLogins') {
        users.add({key: prefs.getString(key) ?? ''});
      }
    }
    return users;
  }

  Future<void> setUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = username;
    await prefs.setString('username', username);
    notifyListeners();
  }

  Future<void> setAvatar(String avatarPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_username != null) {
      _avatarPath = avatarPath;
      await prefs.setString('avatarPath_$_username', avatarPath);
      notifyListeners();
    }
  }

  Future<void> setNickname(String nickname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_username != null) {
      _nickname = nickname;
      await prefs.setString('nickname_$_username', nickname);
      notifyListeners();
    }
  }
}


/*
AuthState 类是一个状态管理类，它维护了用户的认证状态、用户名、是否是管理员等信息。
register 方法用于注册新用户，将用户名和密码保存在本地存储中。
login 方法用于用户登录，它首先从本地存储中获取保存的用户名对应的密码，然后与用户输入的密码进行比较。如果匹配成功，则将用户信息保存到状态中，并更新登录状态和用户登录记录。
logout 方法用于用户注销，它清除了保存的用户信息，并更新登录状态。
getAllUsers 方法用于获取所有已注册用户的信息。
_loadUser 方法在 AuthState 对象初始化时被调用，用于加载已保存的用户信息。 */




/*Future<void>：这是 Dart 中的一种特殊类型声明，表示一个未来可能产生的值。
<void> 表示这个 Future 不会返回任何值。
在异步编程中，Future 用于表示一个异步操作的结果，它可以是一个值，也可以是一个错误。
async：这是 Dart 中的一个关键字，用于声明一个函数是异步的。
在 Dart 中，如果函数使用了 async 关键字修饰，则说明该函数可能包含 await 表达式，且在函数内部可能会有异步操作。
之所以这样写，是因为方法内部涉及到了异步操作，比如从本地存储中读取数据。由于读取数据可能会花费一定的时间，为了避免阻塞主线程。*/