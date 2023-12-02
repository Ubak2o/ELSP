import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:capstone/screen/features/myhome.dart';
import 'package:capstone/model/model_quiz.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:capstone/screen/navigation/appbar.dart';
import 'package:capstone/screen/navigation/bottom.dart';
import 'package:flutter/services.dart';
//import 'package:vertical_barchart/extension/expandedSection.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
//import 'package:vertical_barchart/vertical-legend.dart';

class ShowResult extends StatefulWidget{

  final Quiz quiz;
  final String inputValue;
  final String correctedResponse;
  final double similarity;
  ShowResult(this.quiz, this.inputValue, this.correctedResponse, this.similarity);

  @override
  State<ShowResult> createState() =>  _ShowResult();
}

class _ShowResult extends State<ShowResult>{

  int currentIndex = 0;
  SwiperController controller = SwiperController();
    
  TextEditingController textController = TextEditingController();
  String inputText = ''; // 사용자 입력 값을 저장할 변수
  String outputText = ''; // 문법 교정된 문자열을 저장할 변수

  @override
  Widget build(BuildContext context) {
    
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
                  return checkText1(widget.quiz, widget.inputValue, widget.correctedResponse, width, height);
                }else{}
                  return checkText2(widget.quiz, widget.similarity, widget.correctedResponse, width, height);
              }
            )
          )
        ), 
        
        //하단바
        bottomNavigationBar: buildBottomNavigationBar(context, 0, (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));
          } else if (index == 1) {
            print('Record');
          }
        }),
      )
    );       
  }

  //첫번째 화면
  Widget checkText1(Quiz quiz, String inputValue, String correctedResponse, double width, double height){  
      return Container(
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

            SizedBox(height: 10),

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

              child: GestureDetector(
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: inputValue));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('텍스트가 복사되었습니다.'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              
                child: AutoSizeText(
                  inputValue,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.03,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

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
              child: AutoSizeText ( 
                //'수정된 답변이 들어가야함',
                ' $correctedResponse',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.03,
                ),
                )
            ),
            
            SizedBox(height: 20),

            //버튼
            ButtonBar(
              alignment: MainAxisAlignment.center, // 가로로 중앙 정렬
              children: <Widget>[
              ElevatedButton(
                onPressed: () { controller.next(); },
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
      );
  }
  //두번째 화면
  Widget checkText2(Quiz quiz, double similarity, String correctedAnswer, double width, double height){

      List<VBarChartModel> bardata = [

        VBarChartModel(
          index: 0,
          label: "녹음 시간",
          //colors: [Color.fromARGB(255, 192, 184, 240), Color.fromARGB(255, 240, 184, 192)],
          //jumlah: tmp,
          tooltip: "2:22초",
        ),

        VBarChartModel(
          index: 1,
          label: "주제 유사도",
          colors: [Color.fromARGB(255, 238, 179, 140),Color.fromARGB(255, 238, 179, 140)],
          jumlah: similarity,
          tooltip: "${(similarity).toStringAsFixed(1)}%",
        ),

        VBarChartModel(
          index: 2,
          label: "발음 정확도",
          colors: [Color.fromARGB(255, 192, 184, 240), Color.fromARGB(255, 192, 184, 240)],
          jumlah: 0.8,
          tooltip: "0.8%",
        ),

        VBarChartModel(
          index: 3,
          label: "문법 오답률",
          colors: [Color.fromARGB(255, 214, 240, 184),Color.fromARGB(255, 214, 240, 184)],
          jumlah: 1,
          tooltip: "1%",
        ),
      ];


      return Container(
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
                onPressed: () {
                
                },  
                icon: Icon(Icons.spellcheck, color: Colors.black), 
                label: Text("결과 확인하기", style: TextStyle(fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(width * 0.75, height * 0.06),
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 175, 229, 238)
                ),
              ),
            ),

            SizedBox(height: 10),

            // 교정된 답변 출력
            Container(
              width: width * 0.75,
              height: height * 0.39,
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
              child: buildGrafik(bardata),
            ),

            

            SizedBox(height: 20),
          
            //버튼
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
                  onPressed: () { },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 248, 224, 224)),
                    minimumSize: MaterialStateProperty.all(Size(width * 0.01, height * 0.05)),  
                  ),
                  child: Text('저장', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  onPressed: () { 
                    Navigator.push(context,
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
            maxX: 1,
            data: bardata,
            barStyle: BarStyle.DEFAULT,
            barSize: 15,
          ),
        ],
      );
  }
}
