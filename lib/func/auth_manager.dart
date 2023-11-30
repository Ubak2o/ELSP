import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 
import 'package:capstone/screen/auth/sign_in.dart';
import 'package:capstone/screen/features/myhome.dart';

/*
* 파일: auth_manager.dart
* 최초 작성일: 2023-11-25
* 설명: 로그인, 로그아웃, 사용자 정보 조회 기능
*/

class AuthManager{

  String fetchedUserToken = ""; // `String`로 변경
  String fetchedUserName = "";
  String fetchedUserEmail = "";
  String address = "http://172.20.10.2:8000";


  // 토큰을 저장하는 함수 
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
  }

  // 토큰을 로드하는 함수 
  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    fetchedUserToken = prefs.getString('token') ?? ""; // null-aware 연산자를 사용하여 기본값을 제공
    return  prefs.getString('token');
  }

  // 사용자 정보를 가져와서 유저이름과 이메일을 반환합니다.
  Future<int> loadUserInfo() async {

    final token = await loadToken();
    int result = 0;
    final apiUrl = Uri.parse('$address/quiz/profile/');
    final response = await http.get(
      apiUrl,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      }
    );
    result = response.statusCode;
    // 사용자 정보 가져오기 성공
    if (response.statusCode == 200) {
      final userInfo = json.decode(response.body);
      fetchedUserName = userInfo['username'];
      fetchedUserEmail  = userInfo['email'];
      //print("username : $fetchedUserName");
      //print("useremail : $fetchedUserEmail");
    } else {
      // 사용자 정보 가져오기 실패
      print('Failed to load user info. Status code: ${response.statusCode}');
    }
    return result;
  }

  //로그아웃
  Future<void> logout(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token != null) {
      final apiUrl = Uri.parse('$address/quiz/logout/');

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
        }
      });
    }
  }

  //회원 탈퇴
  Future<void> deleteUser(BuildContext context) async {
    
    final token = await loadToken(); // 토큰을 가져오는 함수
    final apiUrl = Uri.parse('$address/quiz/delete/');

    await http.delete(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
      }
    ).then((http.Response response){
      if (response.statusCode == 204) {
        showAuthDialog(context, "탈퇴 성공", "탈퇴가 성공적으로 완료되었습니다.");
      } else {
        print('Failed to delete user. Status code: ${response.statusCode}');
      }
    }); 
  }

 //회원 가입
  Future<void> register(BuildContext context, List<String> getUserData) async {
    var apiUrl = Uri.parse('$address/quiz/register/');
    Map<String, dynamic> responseBodyMap =  {}; //회원가입 실패시 리턴값을 받아오기위함
    
    //비밀번호가 일치하지 않을 경우
    if(getUserData[2] != getUserData[3]){
      showAuthDialog(context, "회원가입 실패", "비밀번호가 일치하지 않습니다.");
    }

    //비밀번호가 일치하면 userData 생성
    final Map<String, dynamic> userData = {
      'username': getUserData[0],
      'email': getUserData[1],
      'password': getUserData[2],
    };

    await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData)
    ).then((http.Response response){

      if (response.statusCode == 201) {
      //회원가입 성공
        print('Registration successful');
        showAuthDialog(context, "회원가입 성공", "회원가입에 성공했습니다.");
      } else {

      // 회원가입 실패
        print('Failed to register. Status code: ${response.statusCode}');
        responseBodyMap = json.decode(response.body);
        if(responseBodyMap['username'] != null && responseBodyMap['email'] == null){
          showAuthDialog(context, "회원가입 실패", "이미 사용 중인 사용자명입니다.");
        }else if(responseBodyMap['username'] == null && responseBodyMap['email'] != null){
          showAuthDialog(context, "회원가입 실패", "옳바르지 않은 이메일 형식입니다.");
        }else{
          showAuthDialog(context, "회원가입 실패", "이미 사용중인 사용자명입니다. 이메일 형식이 옳바르지 않습니다");
        }
      }
    });
  }

  //로그인
  Future<void> loginUser(BuildContext context, String name, String passwd) async{
    
    if (name.isEmpty || passwd.isEmpty) {
      showAuthDialog(context, "로그인 실패", "이름과 비밀번호를 입력해주세요.");
    }

    final apiUrl = Uri.parse('$address/quiz/api-jwt-auth/');
    final Map<String, dynamic> userData = {
      'username': name,
      'password': passwd,
    };

    http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    ).then((http.Response response) {  
      // 로그인 성공
      if (response.statusCode == 200) {
        print('Login successful');
        // 서버 응답에서 토큰 추출
        final token = json.decode(response.body)['access'];
        saveToken(token);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHome()));
      }else if (response.statusCode == 401) {
        // 사용자 정보가 없는 경우
        showAuthDialog(context, "로그인 실패", "사용자 정보가 없습니다.");
      } else {
        // 로그인 실패
        print('Failed to login. Status code: ${response.statusCode}');
      }
    }); 
  }

  //알림창
  void showAuthDialog(BuildContext context, String titleText, String contentText) {
    showDialog(
       context: context,
       builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: Text(contentText),
          actions: [
            TextButton(
              onPressed: () {
                if(titleText == "세션 만료" || titleText == "탈퇴 성공"){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
                    return LoginPage();
                  }));
                }else if(titleText == '회원가입 성공'){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
                    return LoginPage();
                  }));
                }
                else{
                  Navigator.of(context).pop();
                }
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    ) ;
  }
}