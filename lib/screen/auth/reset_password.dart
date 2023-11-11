import 'package:flutter/material.dart';
import 'package:capstone/screen/auth/sign_in.dart';

class ResetPasswordPage extends StatelessWidget {
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
                              'Forgot password?',
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
                            'Enter your email address and we will send instructions to reset your password.',
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
                              hintText: 'E-mail Address',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          
                          SizedBox( height: 70.0,),
                          
                         
                          //이메일로 새로운 패스워드 보내기  
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (){
                                /*Navigator.push(context,
                                  MaterialPageRoute(builder: (c){
                                  return SignupPage();
                                }));*/
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 175, 221, 238)),
                              //color: Colors.blue[800],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  "제출하기",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox( height: 20.0,),
                          

                          SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (c){
                                  return LoginPage();
                                }));
                              },
                            style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                "돌아가기",
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
  }}