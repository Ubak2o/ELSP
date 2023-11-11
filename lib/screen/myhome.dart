import 'package:auto_size_text/auto_size_text.dart';
import 'package:capstone/model/api_adapter.dart';
import 'package:capstone/screen/show_result.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart' ;
import 'package:capstone/model/model_quiz.dart';
import 'package:capstone/screen/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:dropdown_button2/dropdown_button2.dart';

class MyHome extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 251, 249),
     
      //상단바
      appBar:AppBar(
          backgroundColor: Color.fromARGB(255, 175, 221, 238),
          title: const Text('Capstone Design', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          //centerTitle: true,
      ),

      //Drawer
      drawer: MyDrawer(),
      
      //중간부분
      body: UserRecord(),
  
      //하단바
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 175, 221, 238),
        unselectedItemColor: Colors.black,
        fixedColor: Colors.black,
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.task_alt, color: Colors.black), label: 'check'),
          BottomNavigationBarItem(icon: Icon(Icons.list, color: Colors.black), label: 'my record')
       ],
       onTap: (int index){
        if(index == 0){
            Navigator.push(context,
              MaterialPageRoute(builder: (c){
                return MyHome();
          }));
        }else if(index == 1){
          Navigator.push(context,
              MaterialPageRoute(builder: (c){
                return MyHome();
          }));
        }
       },
      )
    );
  }
}

//Body의 UserRecord정의
class UserRecord extends StatefulWidget {
  @override
  State<UserRecord> createState() => _UserRecord();
}

class _UserRecord extends State<UserRecord>{

  //DropdownButton
  final List<String> second = ['3','20','25','30'];
  String? selectedSecond;
  
  final List<String> section= ['선택주제','돌발주제'];
  String? selectedSection;

  //퀴즈 모델 초기화 
  Quiz quiz = Quiz(question: ' ', topic: ' ', section: ' ');
  bool isLoading = false;
  String viewText = '질문을 보려면 버튼을 누르세요';
  String questionText = ''; // 현재 질문을 저장할 변수

  //stt(음성->텍스트)
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;
  String speechToText = ' ';
  
  //tts(텍스트->음성)
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  
  //녹음된 결과를 담는 컨트롤러
  TextEditingController textController = TextEditingController();
  String inputValue = ' ';
  
  //질문 불러오기
  Future<void> fetchQuiz() async {
    
    setState(() {
      isLoading = true;
    });

    //난수를 생성하기 위해 Random 객체를 만듦 
    Random random = Random();
    int randomNumber = 0;
    String quizType =  ' ';

    //사용자가 선택한 주제에 따라서 다른 API앤드포인트 호출 
    if (selectedSection == '선택주제') {
      quizType = 'survey';
      randomNumber = random.nextInt(12) + 1;      //nextInt에는 질문의 개수가 들어가야 함(수정)
    } else if (selectedSection == '돌발주제') {
      quizType = 'impromptu';
      randomNumber = random.nextInt(5) + 1;
    }

    // GET 방식으로 호출 
    var url = Uri.http('127.0.0.1:8000', '/quiz/$quizType/$randomNumber');
    var response = await http.get(url); 


    print('Response body: ${response.body}');

    //정상적으로 받아왔다면(satuts = 200) quiz에 넣어줌 
    if (response.statusCode == 200) {
      final newQuiz = parseQuiz_(utf8.decode(response.bodyBytes));
      setState(() {
        quiz = newQuiz;
        isLoading = false;
      });
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
  Future<void> initTts( ) async{
    await flutterTts.setLanguage("en-US"); // 언어 설정
    await flutterTts.setPitch(1.0); // 음성 높낮이 설정
    await flutterTts.setSpeechRate(0.8); // 음성 속도 설정
    flutterTts.setCompletionHandler(() {setState(() {
      isSpeaking = false;
    });});
  }

  //TTS 시작 함수
  Future<void> speak(String text) async{

    //퀴즈의 섹션이 바뀌었다면 퀴즈를 다시 패치
    if (quiz.section != selectedSection) {
      print('선택한 주제가 바뀌었습니다');
      await fetchQuiz();
    } 

    //TTS 시작
    await flutterTts.speak(text);
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

  //타이머
  Timer? timer;
  int time = 20;  //귀찮아서 일단 3으로 해둠 나중에 20으로 바꾸기 
  bool isPlaying = false;

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
  
  //타이머 리셋
  void resetTimer() {
    setState(() {
      timer?.cancel();
      time = int.parse(selectedSecond!);
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  
  // 초기화 함수
  @override
  void initState() {
    super.initState();
    initTts(); // TTS 초기화
    selectedSection = "선택주제";
    selectedSecond = "3";
    fetchQuiz();
  }
  
  @override
  Widget build(BuildContext context){
    return Container(
        width: 500,
        height: 700,
        padding: EdgeInsets.all(30),
        
        child: Column(
          children: [
            //제목 
            ElevatedButton(
                onPressed: () {}, 
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(440, 50), // 가로 길이 조절
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 175, 229, 238)
                ),
                child: Text("Self OPic Test", style: TextStyle(fontWeight: FontWeight.bold),),
            ),

            // 간격 늘리기
            SizedBox(height: 10),
       
            Row(children: [
              ButtonBar(children: [
                 
                 //Dropdown 버튼 (사용자가 질문 섹션을 선택)
                DropdownButton2<String>(
                  hint: const Row(
                    children: [
                      Text(
                        '주제 선택',
                        style: TextStyle(
                          fontSize: 14,
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
                    print('재생 버튼 누를 때의 버튼 값 :  $selectedSection');
                    if(isSpeaking){
                      stopSpeaking();
                    }else{
                      speak(quiz.question);
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
                    });
                  },  
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 224, 241, 248),
                  ),
                  child :  Text("질문 보기", style: TextStyle(fontWeight: FontWeight.bold),),
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
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 224, 241, 248),
                  ),
                  child: Text("바꾸기", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ],),   
            ],),
            
            SizedBox(height: 10),
            
            Container( 
              width: 440, height: 100,
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
            
              child: AutoSizeText(
                ' $viewText',
                style: TextStyle(fontSize: 15, height: 1.5, color: const Color.fromARGB(255, 61, 61, 61)), 
                  textAlign: TextAlign.center
                ),
            ),
            
            SizedBox(height: 10),

            //녹음 하기
            ButtonBar(children: [
              
              //Dropdown버튼(사용자가 녹음할 시간을 선택)
              DropdownButton2<String>(
                  hint: const Row(
                    children: [
                      Text(
                        '주제',
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

                SizedBox(width: 10),

                Container( 
                  width: 130, height: 40,
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
            
                  child: Text(
                    '$time : 00',
                    style: TextStyle(fontSize: 17, height: 2.3, color: const Color.fromARGB(255, 61, 61, 61)), 
                    textAlign: TextAlign.center
                  ),
              ),

              SizedBox(width: 10),

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
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 175, 229, 238),
                ),
              ),
            ],), 
      
            SizedBox(height: 10),
            
            //녹음을 텍스트로 바꿔줌
            Container(
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
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder( // 포커스된 상태의 외곽선 스타일 설정
                    borderSide: BorderSide(width: 1.5, color: const Color.fromARGB(255, 186, 186, 186),),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                maxLines: 3,
              ),
            ),
           
            SizedBox(height: 10),
          
            // 제출하기
            ButtonBar(children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    inputValue = textController.text;
                    print('input : $inputValue');
                    Navigator.push(context,
                    MaterialPageRoute(builder: (c){
                      return ShowResult(inputValue, quiz);
                    }));
                  });
                },
                icon: Icon(Icons.check, color: Color.fromARGB(255, 20, 137, 46)), 
                label: Text("제출하기", style: TextStyle(fontWeight: FontWeight.bold),), 
                style : ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 175, 229, 238),
                ),
              ),
            ],
          ), 
        ],
      )
    );
  }
}

