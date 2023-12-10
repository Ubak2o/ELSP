import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:capstone/screen/navigation/drawer.dart';
import 'package:capstone/screen/features/myhome.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:capstone/functions/auth_manager.dart';
import 'package:capstone/functions/list_page_manager.dart';
import 'package:capstone/screen/navigation/appbar.dart';
import 'package:capstone/screen/navigation/bottom.dart';
import 'package:capstone/model/model_result.dart';
import 'package:capstone/screen/features/detail_page.dart'; 

/*
* 파일: my_list.dart
* 최초 작성일: 2023-12-07
* 설명: 사용자 조회 화면
*/

class MyListPage extends StatefulWidget {
  @override
  MyListPageState createState() => MyListPageState();
}

class MyListPageState extends State<MyListPage> {

  AuthManager authManager = AuthManager();
  ListManager listManager = ListManager();
  String userName = "";
  String userToken = "";

  List<Result> itemList = [];
  SwiperController controller = SwiperController();


  @override
  void initState() {
    super.initState();
    loadStatus();
  }

  Future<void> loadStatus() async {

    await authManager.loadToken();
    await authManager.loadUserInfo();

    setState(() {
      userToken = authManager.fetchedUserToken;
      userName = authManager.fetchedUserName;
    });

    await listManager.fetchUserItem(userToken);

    setState(() {
      itemList = listManager.itemList;
    });

  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 251, 249),
      
      appBar: buildAppBar(context),
      
      drawer: MyDrawer(),

      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color.fromARGB(255, 240, 251, 249)),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 208, 207, 207).withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 1),
              ),
            ],
          ),
          width: width * 0.85,
          height: height * 0.68,
          child: Swiper(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            loop: false,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return showList(context, width, height, index);
            },
          ),
        ),
      ),

      bottomNavigationBar: buildBottomNavigationBar(context, 0, (index) {
        if (index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));
        } else if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyListPage()));
        }
      }),
    );
  }


  Widget showList(BuildContext context, double width, double height, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color.fromARGB(255, 240, 251, 249), width: 0.6),
        color: Color.fromARGB(255, 240, 251, 249),
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.history, color: Colors.black),
              label: Text("My Page", style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(width * 0.75, height * 0.06),
                foregroundColor: Colors.black,
                backgroundColor: Color.fromARGB(255, 175, 229, 238),
              ),
            ),
          ),

          SizedBox(height: 3),
          
          SingleChildScrollView(
            child: 
            Container(
              width: width * 0.75,
              height: height * 0.53,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            
              padding: EdgeInsets.only(top: width * 0.012),
              
              child: ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  //Result객체 생성
                  Result result = itemList[index];
                  return ListTile(
                    leading: Icon(Icons.access_time),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          result.topic,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold
                          ), // 토픽 글씨 크기 조절
                        ),
                        AutoSizeText(
                          result.currentDate,
                          style: TextStyle(fontSize: 12.0), // 날짜 글씨 크기 조절
                        ),
                      ],
                    ),
                    onTap: () {
                    // 클릭 시 상세 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(result: result, userName: userName, userToken: userToken,),
                        ),
                      );
                    },
                  );
                },
              ),
             )
            ),
          ],
        ),
      );
    }
  }
