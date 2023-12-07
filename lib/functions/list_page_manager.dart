import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:capstone/model/model_result.dart'; 

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
}
  