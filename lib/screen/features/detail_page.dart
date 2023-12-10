import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:capstone/screen/features/myhome.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:capstone/screen/navigation/appbar.dart';
import 'package:capstone/screen/navigation/bottom.dart';
import 'package:capstone/functions/list_page_manager.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:capstone/model/model_result.dart';
import 'package:capstone/screen/features/list_page.dart';

class DetailScreen extends StatefulWidget{

  final Result result;
  final String userName;
  final String userToken;
  DetailScreen({required this.result, required this.userName, required this.userToken});
 
  @override
  State<DetailScreen> createState() =>  _DetailScreen();
}

class _DetailScreen extends State<DetailScreen>{

  ListManager listManager = ListManager();
  SwiperController controller = SwiperController();
  
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
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return showDetail(widget.result, width, height);
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

  //상세조회 화면
  Widget showDetail(Result result, double width, double height){

      List<VBarChartModel> bardata = [

        VBarChartModel(
          index: 0,
          label: "녹음 시간",
          //colors: [Color.fromARGB(255, 192, 184, 240), Color.fromARGB(255, 240, 184, 192)],
          tooltip: "${result.recordingTime}초",
        ),

        VBarChartModel(
          index: 2,
          label: "발음 신뢰도",
          colors: [Color.fromARGB(255, 192, 184, 240), Color.fromARGB(255, 192, 184, 240)],
          jumlah:  result.accuracy*100,
          tooltip: "${(result.accuracy*100).toStringAsFixed(1)}%",
        ),

        VBarChartModel(
          index: 1,
          label: "주제 유사도",
          colors: [Color.fromARGB(255, 238, 179, 140),Color.fromARGB(255, 238, 179, 140)],
          jumlah: result.similarity*100,
          tooltip: "${(result.similarity*100).toStringAsFixed(1)}%",
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
              SizedBox(
                //padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
                child: ElevatedButton.icon(
                  onPressed: () {},  
                  icon: Icon(Icons.search, color: Colors.black), 
                  label: Text("상세 조회", style: TextStyle(fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 0.75, height * 0.06),
                    foregroundColor: Colors.black,
                    backgroundColor: Color.fromARGB(255, 175, 229, 238)
                  ),
                ),
              ),

              SizedBox(
                child: ElevatedButton.icon(
                  onPressed: () {},  
                  icon: Icon(Icons.manage_search_outlined, color: Colors.black), 
                  label: Text("질문 - ${result.topic}", style: TextStyle(fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // 여기서 값을 조절하여 원하는 모양으로 변경
                    ),
                    minimumSize: Size(width * 0.75, height * 0.05),
                    foregroundColor: Colors.black,
                    backgroundColor: Color.fromARGB(255, 235, 248, 233)
                  ),
                ),
              ),


              //질문 
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
                    result.question,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.03,
                    ),
                  ),
                )
              ),

          
              SizedBox(
                child: ElevatedButton.icon(
                  onPressed: () {},  
                  icon: Icon(Icons.manage_search_outlined, color: Colors.black), 
                  label: Text("제출한 답변", style: TextStyle(fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // 여기서 값을 조절하여 원하는 모양으로 변경
                    ),
                    minimumSize: Size(width * 0.75, height * 0.05),
                    foregroundColor: Colors.black,
                    backgroundColor:  Color.fromARGB(255, 235, 248, 233)
                  ),
                ),
              ),

              //자신의 답변 
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
                    result.userResponse,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.03,
                    ),
                  ),
                )
              ),

               SizedBox(
                child: ElevatedButton.icon(
                  onPressed: () {},  
                  icon: Icon(Icons.manage_search_outlined, color: Colors.black), 
                  label: Text("교정된 답변", style: TextStyle(fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // 여기서 값을 조절하여 원하는 모양으로 변경
                    ),
                    minimumSize: Size(width * 0.75, height * 0.05),
                    foregroundColor: Colors.black,
                    backgroundColor:  Color.fromARGB(255, 235, 248, 233)
                  ),
                ),
              ),

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
                    result.correctedResponse,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.03,
                    ),
                  ),
                )
              ),

              SizedBox(
                child: ElevatedButton.icon(
                  onPressed: () {},  
                  icon: Icon(Icons.manage_search_outlined, color: Colors.black), 
                  label: Text("세부 사항", style: TextStyle(fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // 여기서 값을 조절하여 원하는 모양으로 변경
                    ),
                    minimumSize: Size(width * 0.75, height * 0.05),
                    foregroundColor: Colors.black,
                    backgroundColor: Color.fromARGB(255, 235, 248, 233)
                  ),
                ),
              ),

               //그래프(녹음시간, 신뢰도, 유사도) 
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

                child : Column (children: [
                  buildGrafik(bardata),                 
                ],)
              ),

            ButtonBar(
              alignment: MainAxisAlignment.center, // 가로로 중앙 정렬
              children: <Widget>[

              ElevatedButton(
                onPressed: () async{
                  print('dd');
                  await listManager.deleteUserItem(context, widget.userName, widget.userToken, result.currentDate);
                },
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 248, 224, 224)),
                minimumSize: MaterialStateProperty.all(Size(width * 0.01, height * 0.05)),
                ),
                child: Text('삭제', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
                    return MyListPage();
                  }));
                },
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 175, 229, 238)),
                minimumSize: MaterialStateProperty.all(Size(width * 0.01, height * 0.05)),
                ),
                child: Text('목록', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
            )
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
