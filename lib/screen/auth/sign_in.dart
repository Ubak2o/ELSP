import 'package:capstone/screen/auth/reset_password.dart';
import 'package:capstone/screen/auth/sign_up.dart';
import 'package:capstone/screen/features/myhome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';  // jsonEncode를 사용하기 위해 추가

/*
* 파일: sign_in.dart
* 최초 작성일: 2023-10-15
* 설명: 로그인 페이지
*/


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
  }

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void loginUser() {
    if (nameController.text.isEmpty || passwordController.text.isEmpty) {
      // 경고 창 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('경고'),
            content: Text('이름과 비밀번호를 입력해주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  nameController.clear();
                  passwordController.clear();
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return; // 함수 종료
    }

    final apiUrl = Uri.parse('http://127.0.0.1:8000/quiz/token/');
    final Map<String, dynamic> userData = {
      'username': nameController.text,
      'password': passwordController.text,
    };

    http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    ).then((http.Response response) {
      if (response.statusCode == 200) {
        // 로그인 성공
        print('Login successful');

      // 서버 응답에서 토큰 추출
        final token = json.decode(response.body)['access'];
        //print('Token: $token');

      // 여기에서 적절한 화면 전환 또는 처리를 수행할 수 있습니다.
        nameController.clear();
        passwordController.clear();
        saveToken(token);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));
      
      }else if (response.statusCode == 401) {
        // 사용자 정보가 없는 경우
        // 경고 창 표시
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('경고'),
              content: Text('사용자 정보가 없습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    nameController.clear();
                    passwordController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      } else {
        // 로그인 실패
        print('Failed to login. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color.fromARGB(255, 175, 221, 238),
                  Color.fromARGB(255, 175, 221, 238)
                ],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                
                //제목 
                Expanded(
                  flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 36.0, horizontal: 24.0
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const[
                          Text(
                              'Capstone Design Project',
                            style: TextStyle(
                              color: Color.fromARGB(255, 35, 35, 35),
                              fontSize: 30.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Please login in or sign up to continue using out app.',
                            style: TextStyle(
                              color: Color.fromARGB(255, 104, 103, 103),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
                
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          //이메일 입력
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Color(0xFFe7edeb),
                              hintText: 'Name',
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          
                          SizedBox(
                            height: 20.0,
                          ),
                          
                          //비밀 번호 입력
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Color(0xFFe7edeb),
                              hintText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          
                          SizedBox(
                            height: 50.0,
                          ),
                          
                          //로그인 버튼
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (){
                                loginUser();
                                //print(nameController.text);
                                //print(passwordController.text);       
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 175, 221, 238)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  "로그인",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(
                            height: 20.0,
                          ),
                         
                          //회원가입 버튼 
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (c){
                                  return SignupPage();
                                }));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 175, 221, 238)),
                              //color: Colors.blue[800],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  "회원가입",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),

                          //비밀 번호 찾기 
                          GestureDetector(
                            onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordPage()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  'Forget your password?',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 7, 7, 7),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}