import 'package:capstone/functions/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:capstone/screen/features/show_result.dart';
import 'package:capstone/screen/features/myhome.dart';
import 'package:capstone/model/model_quiz.dart';
import 'package:capstone/model/model_result.dart';
import 'dart:convert'; 

/*
* 파일: result_manager.dart
* 최초 작성일: 2023-11-28
* 설명: 사용자 답변을 받아 결과를 처리하는 부분
*/

class ResultManager{

  final AuthManager authManager;
  final Quiz quiz;
  final String userResponse;
  final double accuracy;  //발음 신뢰도
  final String recordingTime; // 녹음 시간
  double similarity;  //유사도

  String address = "http://172.20.10.2:8000";

  // 생성자에서 매개변수를 받아 클래스 필드에 저장
  ResultManager({ required this.authManager, required this.quiz, required this.userResponse , required this.accuracy, required this.recordingTime, this.similarity = 0});

  Future<void> getSimilarity(BuildContext context) async {

    print(quiz.question);
    if(quiz.question == ''){ 
      showResultDialog(context, '경고', '질문이 존재하지 않습니다.');
    }else{
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
              authManager: authManager,
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
  }

  Future<void> saveResult(BuildContext context, Result result) async {
    //print('${authManager.fetchedUserName}, ${authManager.fetchedUserToken}');
    await http.post(
      Uri.parse('$address/quiz/responses/'),
      headers: {
        'Authorization': 'Bearer ${authManager.fetchedUserToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(result.toJson()),
    ).then((http.Response response){
      if (response.statusCode == 201) {
        print('저장되었습니다');
        showResultDialog(context, '저장 성공', '성공적으로 저장되었습니다.');
      } else {
        print('Server Response: ${response.body}');
        showResultDialog(context, '저장 실패', '저장에 실패하였습니다.');
    }

    });
  }

  Future<int> getUserFeedback(BuildContext context, String userAnswer, String correctedAnswer) async {
    
    int status = 0;

    final Map<String, dynamic> data = {
      'user_answer': userAnswer,
      'corrected_answer': correctedAnswer
    };

    await http.post(
      Uri.parse('$address/quiz/feedback/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data)
    ).then((http.Response response){
      status = response.statusCode;
      if (response.statusCode == 201) {
        print('저장되었습니다');
        showResultDialog(context, '피드백 성공', '피드백이 성공적으로 전송되었습니다.');
        
      }else {
        print('Failed to load items. Status code: ${response.body}');
        showResultDialog(context, '피드백 실패', '피드백 전송에 실패하였습니다.');
      }
    });
    return status;
  }
  
  void showResultDialog(BuildContext context, String titleText, String contentText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: Text(contentText),
          actions: [
            TextButton(
              onPressed: () {
                if(titleText == '저장 성공'){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
                    return MyHome();
                  }));
                }else{
                  Navigator.of(context).pop();
                }
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}