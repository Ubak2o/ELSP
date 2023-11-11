import 'package:capstone/screen/auth/reset_password.dart';
import 'package:capstone/screen/auth/sign_up.dart';
import 'package:capstone/screen/myhome.dart';
import 'package:flutter/material.dart';

//로그인 페이지
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

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
                            decoration: InputDecoration(
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
                          
                          SizedBox(
                            height: 20.0,
                          ),
                          
                          //비밀 번호 입력
                          TextField(
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
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (c){
                                    //일단 바로 MyHome으로 가게 해뒀음. 원래는 로그인이 완료되고 이동 가능해야함 !!
                                  return MyHome();
                                }));
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