import 'package:capstone/func/auth_manager.dart';
import 'package:capstone/screen/auth/sign_in.dart';
import 'package:flutter/material.dart';

/*
* 파일: sign_up.dart
* 최초 작성일: 2023-10-15
* 설명: 회원가입 페이지
*/

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {

  AuthManager authManager = AuthManager();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
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
                
                // 상단 타이틀 부분
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 36.0, horizontal: 24.0
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Create Your Account',
                          style: TextStyle(
                            color: Color.fromARGB(255, 35, 35, 35),
                            fontSize: 23.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Please sign up to enter in app',
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
                
                // 실제 회원가입 입력 폼 부분
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
                          
                          // 이름 입력
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
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
                          SizedBox(height: 8.0,),
                          
                          // 이메일 입력
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Color(0xFFe7edeb),
                              hintText: 'E-mail',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 8.0,),
                          
                          // 패스워드 입력
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
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
                          
                          SizedBox(height: 8.0,),
                          
                          // 패스워드 재입력
                          TextField(
                            controller : confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Color(0xFFe7edeb),
                              hintText: 'Confirm Password',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 30.0,),
                          
                          // 회원가입 버튼
                          
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: ()async {
                                
                                List<String> userData = [nameController.text, emailController.text, passwordController.text, confirmPasswordController.text];
                                authManager.register(context, userData);
                                
                                nameController.clear();
                                emailController.clear();
                                passwordController.clear();
                                confirmPasswordController.clear();
                                
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 175, 221, 238),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          
                          SizedBox(height: 8.0,),
                          
                          // 이미 계정이 있다면 로그인 버튼
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // 이미 계정이 있다면 로그인 버튼 클릭 시 동작
                                Navigator.push(context, MaterialPageRoute(builder: (c) {
                                  return LoginPage();
                                }));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "이미 계정이 있으신가요?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
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