import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:capstone/screen/features/myhome.dart';
import 'package:capstone/model/model_quiz.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ShowResult extends StatefulWidget{
  final String inputValue;
  final Quiz quiz;
  ShowResult(this.inputValue, this.quiz, );

  @override
  State<ShowResult> createState() =>  _ShowResult();
}

class _ShowResult extends State<ShowResult>{
  int currentIndex = 0;
  SwiperController controller = SwiperController();
    
  TextEditingController textController = TextEditingController();
  String inputText = ''; // 텍스트 값을 저장할 변수

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
        appBar : AppBar(
            title: const Text('Capstone Design', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            //centerTitle: true,
            backgroundColor:  Color.fromARGB(255, 175, 221, 238),
            leading: IconButton(
              icon: Icon(Icons.navigate_before, color: Colors.black,),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (c){
                    return MyHome();
                }));
              },
             ),
        ),

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
                  return checkText1(widget.inputValue, widget.quiz, width, height);
                }else{}
                  return checkText2(widget.inputValue, widget.quiz, width, height);
              }
            )
          )
        ), 
        
        //하단바
        bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 175, 221, 238),
        unselectedItemColor: Colors.black,
        fixedColor: Colors.black,
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.task_alt, color: Colors.black), label: 'check'),
          BottomNavigationBarItem(icon: Icon(Icons.list, color: Colors.black), label: 'my record')
       ],)  
      )
    );       
  }

  //첫번째 화면
  Widget checkText1(String inputValue, Quiz quiz, double width, double height){  
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
                  minimumSize: Size(width * 0.8, height * 0.07), // 가로 길이를 조절합니다.
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 175, 229, 238)
                ),
              ),
            ),

            SizedBox(height: 30),

            // 자신의 답변 출력 
            Container(
              width: width * 0.75,
              height: height * 0.17,
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
                ' $inputValue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.03,
                ),
                )
            ),

            SizedBox(height: 20),

            // 교정된 답변 출력
            Container(
              width: width * 0.75,
              height: height * 0.17,
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
                //' $inputValue',
                ' ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.03,
                ),
                )
            ),
            
            SizedBox(height: 30),

            //버튼
            ButtonBar(
              alignment: MainAxisAlignment.center, // 가로로 중앙 정렬
              children: <Widget>[
              ElevatedButton(
                onPressed: () { controller.next(); },
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 175, 229, 238)),),
                child: Text('다음', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
            )
          ],
        ),
      );
  }
  //두번째 화면
  Widget checkText2(String inputValue, Quiz quiz, double width, double height){
      
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
                label: Text("결과 확인하기", style: TextStyle(fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(width * 0.8, height * 0.07), // 가로 길이를 조절합니다.
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 175, 229, 238)
                ),
              ),
            ),

            SizedBox(height : 330),

            //버튼
            ButtonBar(
              alignment: MainAxisAlignment.center, // 가로로 중앙 정렬
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {controller.previous(); },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 175, 229, 238)),),
                  child: Text('이전', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
          
                ElevatedButton(
                  onPressed: () { },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 248, 224, 224)),),
                  child: Text('저장', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(
                  onPressed: () { 
                    Navigator.push(context,
                      MaterialPageRoute(builder: (c){
                      return MyHome();
                    })); },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 175, 229, 238)),),
                  child: Text('종료', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      );
  }
}
