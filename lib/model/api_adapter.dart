import 'dart:convert';
import 'model_quiz.dart';
//JSON 배열(List)에서 첫 번째 퀴즈 객체만을 추출하여 파싱합니다.
//JSON 데이터가 배열 형태이므로, 첫 번째 항목을 사용하여 Quiz 객체로 변환합니다.
Quiz parseQuiz(String responseBody) {
  final List<dynamic> parsedList = json.decode(responseBody);
  if (parsedList.isNotEmpty && parsedList.first is Map<String, dynamic>) {
    return Quiz.fromJason(parsedList.first);
  } else {
    throw Exception("Invalid JSON format");
  }
}

Quiz parseQuiz_(String responseBody) {
  final dynamic parse = json.decode(responseBody);
  return Quiz.fromJason(parse);}