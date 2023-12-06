import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:capstone/screen/features/show_result.dart';
import 'package:capstone/screen/features/myhome.dart';
import 'package:capstone/model/model_quiz.dart';
import 'dart:convert'; 

/*
* 파일: result_manager.dart
* 최초 작성일: 2023-11-28
* 설명: 사용자 답변을 받아 결과를 처리하는 부분
*/

class ResultManager{

  final Quiz quiz;
  final String userResponse;
  final double accuracy;  //발음 신뢰도
  final String recordingTime; // 녹음 시간
  double similarity;  //유사도

  String address = "http://172.20.10.2:8000";

  // 생성자에서 매개변수를 받아 클래스 필드에 저장
  ResultManager({ required this.quiz, required this.userResponse , required this.accuracy, required this.recordingTime, this.similarity = 0});

  Future<void> getSimilarity(BuildContext context) async {
    //print(quiz.question);
    var response = await http.post(
      Uri.parse('$address/quiz/get-similarity/'),
      body: {
        'question' : quiz.question,
        'user_response': userResponse,
      },
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      similarity = responseData['similarity'];
      Future.microtask(() {
          Navigator.push(context, MaterialPageRoute(builder: (c) {
            return ShowResult(ResultManager(
              quiz: quiz,
              userResponse: userResponse,
              accuracy: accuracy,
              recordingTime: recordingTime,
              similarity: similarity
            ));
          }));
        });
    } else{
      print('fail to get similarity');
    }
  }

  void inputErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('경고'),
          content: Text('질문 또는 답변이 존재하지 않습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return MyHome();
                }));
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}