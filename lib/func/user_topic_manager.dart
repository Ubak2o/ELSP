import 'package:http/http.dart' as http;
import 'dart:convert';

class UserTopicManager{

  List<String> surveyAllTopics = [];
  List<String> surveyUserTopics = [];
  List<bool> checkboxStates = [];

  //모든 선택주제의 토픽을 가져오는 함수
  Future<void> fetchAllServeyTopic() async {
    var getAllTopic = Uri.http('127.0.0.1:8000', '/quiz/all-survey-topics/');
  
    try {
      var getAllTopicResponse = await http.get(getAllTopic);
      
      //모든 서베이 토픽을 잘 가져 왔다면
      if (getAllTopicResponse.statusCode == 200) {
          List<dynamic> data = json.decode(utf8.decode(getAllTopicResponse.bodyBytes));
          //print("in user_topic_manager's fetchAllServeyTopic  : $data");
          surveyAllTopics = data.map((item) => item.toString()).toList();
        } else {
          print('Failed to load data, status code: ${getAllTopicResponse.statusCode}');
        }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  //유저가 선택한 선택주제의 토픽을 가져오는 함수
  Future<void> fetchUserTopic(String token) async {

    var getUserTopic = Uri.http('127.0.0.1:8000', '/quiz/user-topics-select/');
  
    try {
      var getUserTopicUrlResponse = await http.get(
        getUserTopic ,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      //사용자 서베이 토픽을 잘 가져 왔다면 
      if (getUserTopicUrlResponse .statusCode == 200) {
        List <dynamic> data = json.decode(utf8.decode(getUserTopicUrlResponse .bodyBytes));
        
        for (int i = 0; i < data.length; i++) {
          String topic = data[i]['topic'];
          surveyUserTopics.add(topic);
        }
        
        //print("in user_topic_manager's fetchUserTopic : $surveyUserTopics");
        checkboxStates = surveyAllTopics.map((topic) => surveyUserTopics.contains(topic)).toList();

      } else {
        print('Failed to load data, status code: ${getUserTopicUrlResponse .statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  // 유저가 선택한 토픽을 데이터베이스에 저장하는 API를 호출하는 함수
  Future<void> saveUserTopic(String selectedTopic, String userName, String token) async {
    var url = Uri.http('127.0.0.1:8000', 'quiz/user-topic-create/');

    try {
      var response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'user': userName,
          'topic' : selectedTopic,
        }
      );
      print(response.statusCode);
    } catch (error) {
      print('Error saving user topic $selectedTopic: $error');
    }
  }

  // 유저가 선택 해제한 단일 토픽을 데이터베이스에서 삭제하는 API를 호출하는 함수
  Future<void> deleteUserTopic(String unselectedTopic, String userName, String token) async {
    var url = Uri.http('127.0.0.1:8000', 'quiz/user-topic-delete/'); // 적절한 API 경로로 수정

    try {
      var response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
       },
        body: {
          'user': userName,
          'topic' : unselectedTopic,
        }
      );
      print(response.statusCode);
    } catch (error) {
      print('Error deleting user topic $unselectedTopic: $error');
    }
  }

}