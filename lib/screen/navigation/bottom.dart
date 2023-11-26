import 'package:flutter/material.dart';

/*
* 파일: bottom.dart
* 최초 작성일: 2023-09-25
* 설명: 하단바 생성. 
*/

Widget buildBottomNavigationBar(BuildContext context, int selectedIndex, Function(int) onTap) {
    return BottomNavigationBar(
      backgroundColor: Color.fromARGB(255, 175, 221, 238),
      unselectedItemColor: Colors.black,
      fixedColor: Colors.black,
      currentIndex: selectedIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.task_alt, color: Colors.black), label: 'check'),
        BottomNavigationBarItem(icon: Icon(Icons.list, color: Colors.black), label: 'my record'),
      ],
      onTap: onTap,
    );
  }
