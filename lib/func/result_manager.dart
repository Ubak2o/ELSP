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
  final String inputValue;
  String correctedResponse = '';
  String address = "http://172.20.10.2:8000";

  // 생성자에서 매개변수를 받아 클래스 필드에 저장
  ResultManager({ required this.quiz, required this.inputValue});

  Future<void> sendRequest(BuildContext context) async {

    Map<String, dynamic> responseBodyMap =  {};
    
    http.post(
      Uri.parse('$address/quiz/corrected-response/'),
      body: {
        'question' : quiz.question,
        'user_response': inputValue,
      },
    ).then((http.Response response) {
      
      if (response.statusCode == 200) {
        responseBodyMap = json.decode(response.body);

        String correctedResponse = responseBodyMap['corrected_response'];
        double similarity = responseBodyMap['similarity'];

        print(correctedResponse);
        print(similarity);

        Future.microtask(() {
          Navigator.push(context, MaterialPageRoute(builder: (c) {
            return ShowResult(quiz, inputValue, correctedResponse, similarity);
          }));
        });
      } else if(response.statusCode == 400){
        inputErrorDialog(context);  
      }
    });
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