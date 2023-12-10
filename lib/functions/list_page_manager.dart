import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:capstone/model/model_result.dart';
import 'package:flutter/material.dart';
import 'package:capstone/screen/features/list_page.dart';

class ListManager{

  List<Result> itemList = [];
  String address = "http://172.20.10.2:8000";

  Future<void> fetchUserItem(String token) async {
    final getItem = Uri.parse('$address/quiz/list-page/');
    try{
      var response = await http.get(
        getItem,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        itemList = data.map((item) => Result.fromJson(item)).toList();
      } else {
        print('Failed to load items. Status code: ${response.statusCode}');
      } 
    }catch(e){
      print('Error fetching data: $e');
    }
  }

  Future<void> deleteUserItem(BuildContext context, String userName, String token, String currentDate) async {

    final url = Uri.parse('$address/quiz/delete-item/');

    try {
      await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
       },
        body: {
          'user': userName,
          'current_date' : currentDate,
        }
      ).then((http.Response response){
          if (response.statusCode == 201 || response.statusCode == 200) {
            print('저장되었습니다');
            showDeleteDialog(context, "삭제 성공", "성공적으로 삭제되었습니다.");
        }else {
          showDeleteDialog(context, "삭제 실패", "삭제에 실패하였습니다.");
        }
      });
    } catch (error) {
      print('Error deleting : $error');
    }
  }

  void showDeleteDialog(BuildContext context, String titleText, String contentText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: Text(contentText),
          actions: [
            TextButton(
              onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
                    return MyListPage();
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
  