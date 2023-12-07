import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:capstone/screen/navigation/drawer.dart';
import 'package:capstone/screen/features/myhome.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:capstone/functions/auth_manager.dart';
import 'package:capstone/functions/impromptu_topic_manager.dart';
import 'package:capstone/screen/navigation/appbar.dart';
import 'package:capstone/screen/navigation/bottom.dart';
import 'package:capstone/screen/features/list_page.dart';

/*
* 파일: impromptu_topic_select.dart
* 최초 작성일: 2023-11-26
* 설명: 사용자가 돌발질문에 대한 주제를 선택할 수 있는 화면
*/

class ImpromptuTopicSelect extends StatefulWidget {
  @override
  State<ImpromptuTopicSelect> createState() => _ImpromptuTopicSelect();
}

class _ImpromptuTopicSelect extends State<ImpromptuTopicSelect> {

  AuthManager authManager = AuthManager();
  String userName = "";
  String userToken = "";

  ImromptuTopicManager userTopicManager = ImromptuTopicManager();
  
  int currentIndex = 0;
  SwiperController controller = SwiperController();
  List<String> impromptuAllTopics = [];
  List<String> impromptuUserTopics = [];
  List<bool> checkboxStates = []; // 추가: 각 설문 주제의 선택 상태를 저장할 리스트

  @override
  void initState() {
    super.initState();
    loadStatus();
  }

  Future<void> loadStatus() async {

    await authManager.loadToken();
    await authManager.loadUserInfo();
    await userTopicManager.fetchAllTopic();

    setState(() {
      userToken = authManager.fetchedUserToken;
      userName = authManager.fetchedUserName;
      impromptuAllTopics = userTopicManager.impromptuAllTopics;
    });

    await userTopicManager.fetchTopic(userToken);
    
    setState(() {
      impromptuUserTopics  = userTopicManager.ipromptuUserTopics;
      checkboxStates = userTopicManager.checkboxStates;
    });

    //print("in loadUserStatus [surveyAllTopics] : $userToken");
    //print("in loadUserStatus [impromptuAllTopics] : $impromptuAllTopics");
    print("in loadUserStatus [impromptuUserTopics] : $impromptuUserTopics ");
    //print("in loadUserStatus [checkboxStates] : $checkboxStates");

  }

  //유저가 선택한 토픽을 데이터베이스에 반영하는 함수 
  Future<void> onSaveButtonPressed() async {
    for (int i = 0; i < checkboxStates.length; i++) {
      if (checkboxStates[i]) {
        await userTopicManager.saveTopic(impromptuAllTopics[i], userName, userToken); // 선택된 토픽을 추가
      } else {
        await userTopicManager.deleteTopic(impromptuAllTopics[i], userName, userToken); // 선택 해제된 토픽을 삭제
      }
    }
    showSaveConfirmationDialog(); //작업 완료 후 성공 메시지 
  }

  // 토픽 변경 뒤 띄우는 창
  void showSaveConfirmationDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('저장 완료'),
            content: Text('성공적으로 저장되었습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
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
              return showCheckbox(context, width, height, index);
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

  Widget buildCheckbox(BuildContext context, int index, Function(List<bool>) setStatus) {
    //print("surveyAllTopics.length: ${impromptuAllTopics.length}");
    //print("checkboxStates.length: ${checkboxStates.length}");
    //print("index: $index");

    if (index < impromptuAllTopics.length && index < checkboxStates.length) {
      return CheckboxListTile(

        dense: true, // Reduces the height of the ListTile
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),

        title: AutoSizeText(impromptuAllTopics[index]),
        value: checkboxStates[index],
        onChanged: (bool? value) {
          setStatus(List.from(checkboxStates)..[index] = value!);
        },
      );
    }else {
      // 유효하지 않은 인덱스에 대한 처리 추가 (예: 에러 메시지 출력 또는 빈 컨테이너 반환)
      return Container();
    }
  }
  
  Widget showCheckbox(BuildContext context, double width, double height, int index) {
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
              icon: Icon(Icons.task_alt, color: Colors.black),
              label: Text("돌발질문 주제 선택", style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(width * 0.75, height * 0.06),
                foregroundColor: Colors.black,
                backgroundColor: Color.fromARGB(255, 175, 229, 238),
              ),
            ),
          ),

          SizedBox(height: 3),
          
          Container(
            width: width * 0.75,
            height: height * 0.44,
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
              itemCount: impromptuAllTopics.length,
              itemBuilder: (context, index) {
                return buildCheckbox(context, index, (List<bool> updatedStates) {
                  setState(() {
                    checkboxStates = updatedStates;
                  });
                });
              },
            ),
          ),

          SizedBox(height: 3),
          
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  onSaveButtonPressed();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 248, 224, 224)),
                  minimumSize: MaterialStateProperty.all(Size(width * 0.01, height * 0.05)),
                ),
                child: Text('저장', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }
}