import 'package:flutter/material.dart';

/*
* 파일: bottom.dart
* 작성자: 오예진
* 최초 작성일: 2023-09-25
* 설명: 상단바를 생성합니다.
*/

AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 175, 221, 238),
      title: const Text('Capstone Design', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      // centerTitle: true,
    );
}

