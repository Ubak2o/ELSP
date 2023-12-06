import 'package:flutter/material.dart';
import 'package:capstone/screen/features/myhome.dart';
import 'package:capstone/screen/features/survey_topic_select.dart';
import 'package:capstone/screen/features/impromptu_topic_select.dart';
import 'package:capstone/functions/auth_manager.dart';

/*
* 파일: bottom.dart
* 최초 작성일: 2023-09-25
* 설명: 사용자 인터페이스 옆에서 나오는 패널 생성.
*/

class MyDrawer extends StatefulWidget {
  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {

  AuthManager authManager = AuthManager();
  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    loadStatus();
  }

  Future<void> loadStatus() async {
    if(await authManager.loadUserInfo() == 401){
      logoutAndNavigateToLoginPage();
    }
    setState(() {
      userName = authManager.fetchedUserName;
      userEmail = authManager.fetchedUserEmail;
    });
  }

  void logoutAndNavigateToLoginPage() {
    authManager.showAuthDialog(context,"세션 만료", "로그인 세션이 만료되었습니다. 다시 로그인 해주세요.");
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header part of the drawer
          InkWell(
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => MyHome(),
              ),
            ),
            child: buildHeader(context, userName, userEmail),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return SurveyTopicSelect();
                        }));
                       },
                      icon: Icon(Icons.checklist),
                      //tooltip: '',
                    ),
                    SizedBox(width: 10,),
                    Text('주제선택(선택질문)'),
                  ],
                ),
                
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return ImpromptuTopicSelect();
                        }));        
                      },
                      icon: Icon(Icons.checklist),
                      //tooltip: 'Settings',
                    ),
                    SizedBox(width: 10,),
                    Text('주제선택(돌발질문)'),
                  ],
                ),
                
                const Divider( height: 50, color: Colors.black, thickness: 1,),
                
                 Row(
                  children: [
                    IconButton(
                      onPressed: () { 
                        authManager.logout(context);
                      },
                      icon: Icon(Icons.logout),
                      tooltip: '로그아웃',
                    ),
                    SizedBox(width: 10,),
                    Text('로그아웃'),
                  ],
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        authManager.deleteUser(context);
                      },
                      icon: Icon(Icons.delete_outline),
                      tooltip: '탈퇴',
                    ),
                    SizedBox(width: 10,),
                    Text('탈퇴'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildHeader(BuildContext context, String userName, String userEmail) => GestureDetector(

      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 175, 221, 238),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
          ),
        ),
        
        child: Container(
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 20,
          ),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              
              Text(
                userName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 5),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userEmail,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );