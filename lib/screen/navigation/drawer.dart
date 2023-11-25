import 'package:flutter/material.dart';
import 'package:capstone/screen/features/myhome.dart';
import 'package:capstone/screen/features/survey.dart';
import 'package:capstone/func/auth_manager.dart';

/*
* 파일: bottom.dart
* 작성자: 오예진
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
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    // await를 사용하여 비동기 함수 기다리기
    await authManager.loadUserInfo(); 
    // setState 메서드를 사용해서 loadUserInfo 함수가 완료된 후에 build 메서드에서 UI를 업데이트
    setState(() {
      userName = authManager.fetchedUserName;
      userEmail = authManager.fetchedUserEmail;
    });
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
                          return UserSurvey();
                        }));
                       },
                      icon: Icon(Icons.checklist),
                      tooltip: 'Survey',
                    ),
                    SizedBox(width: 10,),
                    Text('Background Survey'),
                  ],
                ),
                
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                       
                      },
                      icon: Icon(Icons.settings),
                      tooltip: 'Settings',
                    ),
                    SizedBox(width: 10,),
                    Text('Settings'),
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
                      tooltip: 'Log out',
                    ),
                    SizedBox(width: 10,),
                    Text('Log out'),
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
              CircleAvatar(
                radius: 60,
                backgroundColor: Color.fromARGB(255, 175, 221, 238),
                backgroundImage: AssetImage('user.png'),
              ),
              
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