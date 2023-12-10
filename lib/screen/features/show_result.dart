import 'package:capstone/functions/result_manager.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:capstone/screen/features/myhome.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:capstone/screen/navigation/appbar.dart';
import 'package:capstone/screen/navigation/bottom.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:capstone/model/model_result.dart';
import 'package:intl/intl.dart';
import 'package:capstone/screen/features/list_page.dart';

class ShowResult extends StatefulWidget{

  final ResultManager resultManager;
  ShowResult(this.resultManager);
 
  @override
  State<ShowResult> createState() =>  _ShowResult();
}

class _ShowResult extends State<ShowResult>{

  String userModifiedAnswer = "";
  String correctedResponse = "";
  SwiperController controller = SwiperController();
  String address = "http://172.20.10.2:8000";
  bool feedbackPressed = false;
  
    
  @override
  Widget build(BuildContext context) {
  TextEditingController textController = TextEditingController(text: widget.resultManager.userResponse);
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    
    return SafeArea(
      child: Scaffold(
        //배경 색
        backgroundColor:  Color.fromARGB(255, 240, 251, 249),
        
        //상단바
        appBar : buildAppBar(context),

        //body
        body : Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius : BorderRadius.circular(20),
              border: Border.all(color: Color.fromARGB(255, 240, 251, 249)),
               boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 208, 207, 207).withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
            ),
            width: width * 0.85,
            height: height * 0.68,
            child: Swiper(
              controller : controller,  
              physics: NeverScrollableScrollPhysics(),
              loop: false,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                if(index == 0){
                  return checkText1(textController, widget.resultManager, width, height);
                }else {
                  return checkText2(widget.resultManager, userModifiedAnswer, correctedResponse, width, height);
                }
              }
            )
          )
        ), 
        
        //하단바
        bottomNavigationBar: buildBottomNavigationBar(context, 0, (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyListPage()));
          }
        }),
      )
    );       
  }

  //첫번째 화면
  Widget checkText1(TextEditingController textController, ResultManager resultManager, double width, double height){

      List<VBarChartModel> bardata = [

        VBarChartModel(
          index: 0,
          label: "녹음 시간",
          //colors: [Color.fromARGB(255, 192, 184, 240), Color.fromARGB(255, 240, 184, 192)],
          tooltip: "${resultManager.recordingTime}초",
        ),

        VBarChartModel(
          index: 2,
          label: "발음 신뢰도",
          colors: [Color.fromARGB(255, 192, 184, 240), Color.fromARGB(255, 192, 184, 240)],
          jumlah:  resultManager.accuracy*100,
          tooltip: "${(resultManager.accuracy*100).toStringAsFixed(1)}%",
        ),

        VBarChartModel(
          index: 1,
          label: "주제 유사도",
          colors: [Color.fromARGB(255, 238, 179, 140),Color.fromARGB(255, 238, 179, 140)],
          jumlah: resultManager.similarity*100,
          tooltip: "${(resultManager.similarity*100).toStringAsFixed(1)}%",
        ),
      ];

      return SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color.fromARGB(255, 240, 251, 249), width: 0.6),
            color: Color.fromARGB(255, 240, 251, 249),
          ),
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              //제목
              Container(
                padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
                child: ElevatedButton.icon(
                  onPressed: () {},  
                  icon: Icon(Icons.spellcheck, color: Colors.black), 
                  label: Text("답변 수정", style: TextStyle(fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 0.75, height * 0.06),
                    foregroundColor: Colors.black,
                    backgroundColor: Color.fromARGB(255, 175, 229, 238)
                  ),
                ),
              ),

              // 자신의 답변 출력 
              Container(
                width: width * 0.75,
                height: height * 0.46,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),

                child : Column (children: [
                  buildGrafik(bardata),

                  TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.5, color: Color.fromARGB(255, 240, 237, 237),),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      focusedBorder: OutlineInputBorder( // 포커스된 상태의 외곽선 스타일 설정
                        borderSide: BorderSide(width: 1.5, color: Color.fromARGB(255, 240, 237, 237),),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    maxLines: 6,
                    style: TextStyle(
                      fontSize: width * 0.038, // 원하는 크기로 조절
                    ),
                  ),
                ],)
              ),

            ButtonBar(
              alignment: MainAxisAlignment.center, // 가로로 중앙 정렬
              children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  userModifiedAnswer = textController.text;
                  http.post(
                    Uri.parse('$address/quiz/get-corrected-response/'),
                    body: {
                      'user_response': userModifiedAnswer,
                    },
                  ).then((http.Response response){
                    if (response.statusCode == 200){
                      var responseData = json.decode(response.body);
                      setState(() {
                         correctedResponse = responseData['corrected_response'];   
                      });
                    }
                  });
                  controller.next(); 
                },
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 175, 229, 238)),
                minimumSize: MaterialStateProperty.all(Size(width * 0.01, height * 0.05)),
                ),
                child: Text('다음', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
            )
          ],
        ),
      )
      );
  }

  //두번째 화면
  Widget checkText2(ResultManager resultManager, String userModifiedAnswer, String correctedResponse, double width, double height){  
    return SingleChildScrollView(
      
      child : Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color.fromARGB(255, 240, 251, 249), width: 0.6),
          color: Color.fromARGB(255, 240, 251, 249),
        ),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            //제목
            Container(
              padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
              child: ElevatedButton.icon(
                onPressed: () {},  
                icon: Icon(Icons.spellcheck, color: Colors.black), 
                label: Text("문법 수정", style: TextStyle(fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(width * 0.75, height * 0.06),
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 175, 229, 238)
                ),
              ),
            ),

            // 자신의 답변 출력 
            Container(
              width: width * 0.75,
              height: height * 0.18,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              
              padding: EdgeInsets.only(top: width * 0.012),
              
              child: SingleChildScrollView(
                child : AutoSizeText(
                userModifiedAnswer,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.03,
                ),
              ),
            )),

            SizedBox(height: 11),
            // 교정된 답변 출력
            Container(
              width: width * 0.75,
              height: height * 0.18,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              
              padding: EdgeInsets.only(top: width * 0.012),
              
              child: SingleChildScrollView(
                child : AutoSizeText(
                correctedResponse,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.03,
                ),
              ),
            )),

            Align(
              alignment: Alignment.bottomRight,
              child:  IconButton(
                onPressed: () async{
                  print(feedbackPressed);
                  if(!feedbackPressed){
                    int status = await resultManager.getUserFeedback(context, userModifiedAnswer, correctedResponse);
                    if (status == 201){
                      feedbackPressed = true;
                    }                  
                  }
                },
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.thumb_up_alt,
                      size: 15,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5), // Adjust the spacing between the icon and text
                    Text(
                      "답변에 만족합니다!",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ),
            ),
            
            ButtonBar(
              alignment: MainAxisAlignment.center, // 가로로 중앙 정렬
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {controller.previous(); },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 175, 229, 238)),
                    minimumSize: MaterialStateProperty.all(Size(width * 0.01, height * 0.05)),
                  ),
                  child: Text('이전', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
          
                ElevatedButton(
                  onPressed: ()  async {

                    DateTime date = DateTime.now();
                    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
     
                    Result result = Result(
                      user: resultManager.authManager.fetchedUserName, 
                      question: resultManager.quiz.question,
                      topic: resultManager.quiz.topic,
                      userResponse: userModifiedAnswer, 
                      correctedResponse: correctedResponse, 
                      recordingTime: resultManager.recordingTime, 
                      accuracy: resultManager.accuracy, 
                      similarity: resultManager.similarity, 
                      currentDate: currentDate,  
                    );

                    try{
                      await resultManager.saveResult(context, result);
                    }catch(e){
                      print('Error saving result: $e');
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 248, 224, 224)),
                    minimumSize: MaterialStateProperty.all(Size(width * 0.01, height * 0.05)),  
                  ),
                  child: Text('저장', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  onPressed: () { 
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (c){
                      return MyHome();
                    })); },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 175, 229, 238)),
                    minimumSize: MaterialStateProperty.all(Size(width * 0.01, height * 0.05)),
                  ),
                  child: Text('종료', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget buildGrafik(List<VBarChartModel> bardata) {
    return Column(
        children: [
          VerticalBarchart(
            //background: Colors.transparent,
            labelColor: Color(0xff283137),
            labelSizeFactor: 10,
            tooltipColor: Color(0xff8e97a0),
            maxX: 100,
            data: bardata,
            barStyle: BarStyle.DEFAULT,
            barSize: 15,
          ),
        ],
      );
  }
}
