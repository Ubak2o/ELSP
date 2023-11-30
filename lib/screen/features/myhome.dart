import 'package:auto_size_text/auto_size_text.dart';
import 'package:capstone/model/api_adapter.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart' ;
import 'package:capstone/model/model_quiz.dart';
import 'package:capstone/screen/navigation/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:capstone/screen/navigation/appbar.dart';
import 'package:capstone/screen/navigation/bottom.dart';
import 'package:capstone/func/auth_manager.dart';
import 'package:capstone/func/result_manager.dart';

/*
* 파일: myhome.dart
* 최초 작성일: 2023-09-30
* 설명: 사용자가 질문을 듣고 녹음을 하는 화면입니다.

* 수정일: 2023-11-25
* 수정 내용: 사용자가 선택한 주제별로 질문을 재생하는 기능을 추가 
*/

class MyHome extends StatefulWidget{
  @override
  State<MyHome> createState() => _MyHome();
}

class _MyHome extends State<MyHome>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 240, 251, 249),
      
      appBar: buildAppBar(context),
      
      drawer: MyDrawer(),
      
      body: SingleChildScrollView(
        child : UserRecord(),
      ),

      bottomNavigationBar:buildBottomNavigationBar(context, 0, (index) {
        if (index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));
        } else if (index == 1) {
          print('Record');
        }
      }),
    );
  }
}

class UserRecord extends StatefulWidget {
  @override
  State<UserRecord> createState() => _UserRecord();
}

class _UserRecord extends State<UserRecord>{

  AuthManager authManager = AuthManager();
  String userToken = "";
  String userName = "";
  String address = "http://172.20.10.2:8000";

  @override
  void initState() {
    super.initState();
    initTts(); // TTS 초기화
    selectedSection = "선택주제";
    selectedSecond = "20";
    loadStatus(); //사용자의 토큰과 이름을 가져옴 
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadStatus() async {

    if(await authManager.loadToken() == null || await authManager.loadUserInfo() == 401){
      logoutAndNavigateToLoginPage();
    }
    setState(() {
      userToken = authManager.fetchedUserToken;
      userName = authManager.fetchedUserName;
    });
  }

  void logoutAndNavigateToLoginPage() {
    authManager.showAuthDialog(context,"세션 만료", "세션이 만료되었습니다. 다시 로그인해 주세요.");
  }

  //STT
  SpeechToText speech = SpeechToText();
  bool isListening = false;
  String speechToText = ' ';

  //Timer
  Timer? timer;
  int time = 20; 
  bool isPlaying = false;

  //TTS
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  //사용자가 초를 선택할 수 있도록 하는데 필요한 변수
  final List<String> second = ['20','25','30'];
  String? selectedSecond;

  //사용자가 질문의 섹션을 선택할 수 있도록 하는데 필요한 변수
  final List<String> section= ['선택주제','돌발주제'];
  String? selectedSection;

  //퀴즈 모델 초기화 
  Quiz quiz = Quiz(question: ' ', topic: ' ', section: ' ');
  bool isLoading = false;
  String viewText = '질문을 보려면 버튼을 누르세요';
  String questionText = ''; // 현재 질문을 저장할 변수

  //녹음된 결과를 담는 컨트롤러
  TextEditingController textController = TextEditingController();
  String inputValue = ' ';
  
  @override
  Widget build(BuildContext context){

    // MediaQuery를 통해 현재 화면의 크기 및 다양한 속성에 액세스
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Container(
      width: width , 
      height: height, 
      padding: EdgeInsets.all(10),

        child: Column(
          
          children: [
            //제목 
            ElevatedButton(
                onPressed: () {}, 
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(width * 0.87, height * 0.073), 
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 175, 229, 238), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), 
                  ),
                ),
                child: Text("Self OPic Test", style: TextStyle(fontWeight: FontWeight.bold),),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonBar(children: [
                   //사용자가 질문 섹션을 선택
                  DropdownButton2<String>(
                    hint: const Row(
                      children: [
                        Text(
                          '주제 선택',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    value: selectedSection,
                    items: section.map((e) => DropdownMenuItem(value: e, child: Text(e),)).toList(),
                    onChanged: (String? value){setState(() {
                      selectedSection = value;
                    });}
                  ),

                  //재생하기 버튼 
                  IconButton(
                    onPressed: () async {
                      //print('재생 버튼 누를 때의 버튼 값 :  $selectedSection');
                      if(isSpeaking){
                        stopSpeaking();
                      }else{
                        speak();
                      }
                    },
                    icon: Icon(isSpeaking ? Icons.stop_circle : Icons.play_circle, color: Colors.red), 
                    iconSize: 30,
                    tooltip: "재생",
                  ),

                  //질문 보기 버튼 
                  ElevatedButton(
                    onPressed: (){ 
                      setState(() { 
                        if (questionText == quiz.question) {
                            // 버튼을 한 번 더 눌렀을 때 현재 질문과 같으면 초기화
                            questionText = '';
                            viewText = '질문을 보려면 버튼을 누르세요';
                        } else {
                            questionText = quiz.question;
                            viewText = quiz.question;
                          }
                        }
                      );
                    },  
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width * 0.01, height * 0.05), // 현재 화면 너비의 80%
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 224, 241, 248),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 여기서 원하는 값을 지정
                      ),
                    ),
                    child : Icon(Icons.description, size: 18),
                  ),

                  //질문바꾸기 버튼
                  ElevatedButton(
                    onPressed: (){ 
                      setState(() { 
                        viewText = '질문을 보려면 버튼을 누르세요';
                      });
                      fetchQuiz(); 
                    }, 
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width * 0.01, height * 0.05), // 현재 화면 너비의 80%
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 224, 241, 248),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 여기서 원하는 값을 지정
                      ),
                    ),
                    child: Icon(Icons.replay_circle_filled, size: 18),
                  ),
                ],),   
              ],
            ),

            Container( 
              width: width * 0.87, 
              height: height * 0.12,
              
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ], 
              ),
            
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: AutoSizeText(
                  ' $viewText',
                  style: TextStyle(fontSize: 15, height: 1.5, color: const Color.fromARGB(255, 61, 61, 61)), 
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              ButtonBar(children: [
              //사용자가 녹음할 시간을 선택
                DropdownButton2<String>(
                    hint: const Row(
                      children: [
                        Text(
                          '초 선택',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  value: selectedSecond,
                  items: second.map((e) => DropdownMenuItem(value: e, child: Text(e),)).toList(),
                  onChanged: (String? value){setState(() {
                    selectedSecond = value;
                    time = int.parse(value!);
                  });}),

                SizedBox( 
                  width: width * 0.2, // 화면 너비의 80%
                  height: height * 0.05, // 화면 높이의 80%
                  child: Text(
                    '$time 초',
                    style: TextStyle(fontSize: 17, height: 2.3, color: const Color.fromARGB(255, 61, 61, 61)), 
                    textAlign: TextAlign.center
                  ),
                ),

                //녹음하기 버튼 
                ElevatedButton.icon(
                  onPressed: () {
                    listen();
                    print('Recording Result:  $speechToText');
                    textController.text = speechToText;
                  },  
                  icon: Icon(isListening ? Icons.radio_button_checked : Icons.mic, color: Colors.red), 
                  label: Text(isListening ? "녹음중단" : "녹음하기", style: TextStyle(fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 0.01, height * 0.06),
                    foregroundColor: Colors.black,
                    backgroundColor: Color.fromARGB(255, 175, 229, 238),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 여기서 원하는 값을 지정
                    ),
                  ),
                ),
              ],), 
            ],),

            //녹음을 텍스트로 바꿔줌
            Container(
              width: width * 0.87, // 화면 너비의 80%
              height: height * 0.18, // 화면 높이의 80%
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              
              //녹음된 음성이 보여지는 필드
              child: TextFormField(
                controller: textController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '녹음된 음성이 여기에 표시됩니다.',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.cancel, color: Color.fromARGB(255, 133, 129, 129)),
                    onPressed: () {textController.clear();},
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Color.fromARGB(255, 240, 251, 249),),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  focusedBorder: OutlineInputBorder( // 포커스된 상태의 외곽선 스타일 설정
                    borderSide: BorderSide(width: 1.5, color: const Color.fromARGB(255, 186, 186, 186),),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                maxLines: 3,
              ),
            ),

            SizedBox(height: 8),
          
            // 제출하기
            ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [ ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    
                    inputValue = textController.text;
                    print('input : $inputValue');
                    ResultManager resultManager = ResultManager(quiz: quiz, inputValue : inputValue);
                    resultManager.sendRequest(context);
                    
                    textController.clear();
                    
                  });
                },
                icon: Icon(Icons.check, color: Color.fromARGB(255, 20, 137, 46)), 
                label: Text("제출하기", style: TextStyle(fontWeight: FontWeight.bold),), 
                style : ElevatedButton.styleFrom(
                  minimumSize: Size(width * 0.01, height * 0.06),
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 175, 229, 238),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 여기서 원하는 값을 지정
                  ),
                ),
              ),
              ],
          ), 
        ],
      )
    );
  }
  //질문을 불러오는 함수
  Future<void> fetchQuiz() async {
    
    setState(() {
      isLoading = true;
    });

    var url;
    var response;

    //사용자가 선택한 주제에 따라서 다른 API앤드포인트 호출 
    if (selectedSection == '선택주제') {
      
      url = Uri.parse('$address/quiz/survey/');

      response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $userToken',
        },
      ); 

    } else if (selectedSection == '돌발주제') {

      url = Uri.parse('$address/quiz/impromptu/');

      response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $userToken',
        },    
      ); 
    }

    if (response.statusCode == 200) {
      final newQuiz = parseQuiz_(utf8.decode(response.bodyBytes));
      setState(() {
        quiz = newQuiz;
        isLoading = false;
      });
      
      print("section : ${quiz.section}, topic : ${quiz.topic}, question : ${quiz.question}");
    
    } else if(response.statusCode == 500){
      noSelectedTopicDialog();
      quiz = Quiz(question: ' ', topic: ' ', section: ' ');
      
    } else {
      throw Exception('failed to load selected quiz');
    }
  }

  //STT 녹음 함수
  Future<void> listen() async {
    if (!isListening) { //녹음이 되고 있지 않다면 녹음을 시작
      bool available = await speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      
      // 녹음이 시작되면 타이머 시작
      if (available) {
        setState(() {
          isListening = true;
          startTimer(); 
        });
      
      //녹음 시작 
      speech.listen(
        onResult: (val) => setState(() {
          speechToText = val.recognizedWords;
          textController.text = val.recognizedWords; // 음성을 controller에 업데이트
        }),);
      }
    } else { //녹음이 되고 있다면 녹음을 중단 
      setState(() {
        isListening = false;
        resetTimer(); // 녹음 중단 시 타이머 초기화
      });
      speech.stop();
   }
 }

  //TTS 초기화 및 관련 함수
  Future<void> initTts() async{
    await flutterTts.setLanguage("en-US"); // 언어 설정
    await flutterTts.setPitch(1.0); // 음성 높낮이 설정
    await flutterTts.setSpeechRate(0.3); // 음성 속도 설정
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
    });});
  }

  //TTS 시작 함수
  Future<void> speak() async{
    //퀴즈의 섹션이 바뀌었다면 퀴즈를 다시 불러옴
    if (quiz.section != selectedSection) {
      await fetchQuiz();
    } 
    await flutterTts.speak(quiz.question);
    setState(() {
      isSpeaking = true;
    });
  }

  //TTS 중단 함수
  Future<void> stopSpeaking() async{
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  //타이머 시작 함수 
  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 1000), (Timer timer) {
      setState(() {
        time --;
        if (time == 0){
          setState(() {
          timer.cancel();
          isPlaying = false;
          speech.stop();
          isListening = false;
          if (selectedSecond != null) {
            // selectedsecond!에서 느낌표는 "null 연산자"입니다. 
            // 이 연산자는 변수나 표현식 뒤에 사용되며, 그 값이 null이 아님을 단정할 때 사용됩니다.
            time = int.parse(selectedSecond!);
          }else{
            time = 3; //귀찮아서 일단 3으로 해둠 나중에 20으로 바꾸기
          }
          });
        }
      });
    });
  }
  
  //타이머 리셋 함수
  void resetTimer() {
    setState(() {
      timer?.cancel();
      time = int.parse(selectedSecond!);
      isPlaying = false;
    });
  }

  //선택된 주제가 없을 경우 경고 알림창
  void noSelectedTopicDialog() {
    authManager.showAuthDialog(context, "경고", "선택된 주제가 없습니다");
  }
}

