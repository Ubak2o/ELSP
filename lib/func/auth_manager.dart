import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 
import 'package:capstone/screen/auth/sign_in.dart';

/*
* 파일: auth_manager.dart
* 최초 작성일: 2023-11-25
* 설명: 로그인, 로그아웃, 사용자 정보 조회 기능
*/

class AuthManager{

  String fetchedUserToken = ""; // `String`로 변경
  String fetchedUserName = "";
  String fetchedUserEmail = "";

  // 토큰을 저장하고 로드하는 함수 
  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    fetchedUserToken = prefs.getString('token') ?? ""; // null-aware 연산자를 사용하여 기본값을 제공
  return prefs.getString('token');
}

  // 사용자 정보를 가져와서 유저이름과 이메일을 반환합니다.
  Future<void> loadUserInfo() async {

    final token = await loadToken(); // 토큰을 가져오는 함수
  
    if (token != null) {
      final apiUrl = Uri.parse('http://127.0.0.1:8000/quiz/profile/');

      final response = await http.get(
        apiUrl,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // 사용자 정보 가져오기 성공
        final userInfo = json.decode(response.body);
        fetchedUserName = userInfo['username'];
        fetchedUserEmail  = userInfo['email'];
        
        print(fetchedUserName);
        print(fetchedUserEmail);

      } else {
        // 사용자 정보 가져오기 실패
        print('Failed to load user info. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  }

  //로그아웃
  Future<void> logout(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token != null) {
      final apiUrl = Uri.parse('http://127.0.0.1:8000/quiz/logout/');

      http.post(
        apiUrl,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      ).then((http.Response response) {
        if (response.statusCode == 200) {
          // 서버 측에서 로그아웃 성공
          prefs.remove('token');
          Navigator.push(context, MaterialPageRoute(builder: (c) {
            return LoginPage();
          }));
        } else {
          // 서버 측에서 로그아웃 실패
          print('Failed to logout. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      });
    }
  }

  Future<int> deleteUser(BuildContext context) async {

    final token = await loadToken(); // 토큰을 가져오는 함수
    final apiUrl = Uri.parse('http://127.0.0.1:8000/quiz/delete/');
    int statusCode = 0;

    try {
      final response = await http.delete(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      statusCode = response.statusCode;

      if (statusCode == 204) {
        print('User deleted successfully');
      } else {
        print('Failed to delete user. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting user: $error');
  }
  //print(statusCode);
  return statusCode;
}

Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    var apiUrl = Uri.parse('http://127.0.0.1:8000/quiz/register/');
    Map<String, dynamic> responseBodyMap =  {};

    final http.Response response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      //회원가입 성공
      print('Registration successful');
    } else {
     // 회원가입 실패
      //print('Failed to register. Status code: ${response.statusCode}');
      responseBodyMap = json.decode(response.body);
      //List<dynamic> usernameErrors = responseBodyMap['username'] ?? [];
      //List<dynamic> emailErrors = responseBodyMap['email'] ?? [];
      //print('Username errors: $usernameErrors');
      //print('Email errors: $emailErrors');
    }
    
    return responseBodyMap;
  }
  
}