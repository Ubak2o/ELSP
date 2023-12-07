import 'package:auto_size_text/auto_size_text.dart';
import 'package:capstone/model/api_adapter.dart';
import 'package:capstone/screen/features/list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart' ;
import 'package:capstone/model/model_quiz.dart';
import 'package:capstone/screen/navigation/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:capstone/screen/navigation/appbar.dart';
import 'package:capstone/screen/navigation/bottom.dart';
import 'package:capstone/functions/auth_manager.dart';
import 'package:capstone/functions/result_manager.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'dart:typed_data';
import 'dart:io';

/*
* 파일: myhome.dart
* 최초 작성일: 2023-09-30
* 설명: 사용자가 질문을 듣고 녹음을 하는 화면입니다.

* 수정일: 2023-11-25
* 수정 내용: 사용자가 선택한 주제별로 질문을 재생하는 기능을 추가

* 수정일: 2023-12-05
* 수정 내용: flutter stt 라이브러리에서 구글 api로 변경
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
      
      body:  UserRecord(),
      
      bottomNavigationBar:buildBottomNavigationBar(context, 0, (index) {
        if (index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));
        } else if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyListPage()));
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
    WidgetsFlutterBinding.ensureInitialized();
    initTts(); 
    loadStatus(); //사용자의 토큰과 이름을 가져옴
    selectedSection = "선택주제";
  }

  Future<void> loadStatus() async {
    if(await authManager.loadToken() == null || await authManager.loadUserInfo() == 401){
      logoutAndNavigateToLoginPage();
    }
    setState(() {
      userToken = authManager.fetchedUserToken;
      userName = authManager.fetchedUserName;
    });
    //print(userName);
  }

  //TTS
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  //Record
  final FlutterSoundRecord audioRecorder = FlutterSoundRecord();
  bool isRecording = false;

  //사용자가 질문의 섹션을 선택할 수 있도록 하는데 필요한 변수
  final List<String> section= ['선택주제','돌발주제'];
  String? selectedSection;

  //퀴즈 모델 초기화 
  Quiz quiz = Quiz(question: '', topic: '', section: '');
  bool isLoading = false;
  String viewText = '질문을 보려면 버튼을 누르세요';
  String questionText = ''; // 현재 질문을 저장할 변수

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

            SizedBox(height: 50,),

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
              height: height * 0.28,
              
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

            SizedBox(height: 10),
  
            //녹음하기 버튼 
            ElevatedButton.icon(
              onPressed: () {
                isRecording? stopRecord() : startRecord();   
              },  
              icon: Icon(isRecording ? Icons.radio_button_checked : Icons.mic, color: Colors.red), 
              label: Text(isRecording ? "녹음중단" : "녹음하기", style: TextStyle(fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(width * 0.01, height * 0.06),
                foregroundColor: Colors.black,
                backgroundColor: Color.fromARGB(255, 175, 229, 238),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // 여기서 원하는 값을 지정
                ),
              ),
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

  //TTS
  Future<void> initTts() async{
    await flutterTts.setLanguage("en-US"); // 언어 설정
    await flutterTts.setPitch(1.0); // 음성 높낮이 설정
    await flutterTts.setSpeechRate(0.4); // 음성 속도 설정
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
    });});
  }

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

  Future<void> stopSpeaking() async{
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  Future<void> startRecord() async {
    try {
      if (await audioRecorder.hasPermission()) {
        print('get permission');
        if(!isRecording){
          setState(() {
            isRecording = true;
          });
          await audioRecorder.start();
        }
      }else{
        print('no permission');
      }
    }catch (e) {
      print(e);
    }
  }

  //대부분의 경우 오디오 녹음을 중지하는 작업은 시간이 걸리므로, 비동기 방식으로 처리하는 것이 일반적
  Future<void> stopRecord() async {
    String? result = await audioRecorder.stop();
    print("stopRecord: $result");

    setState(() {
      isRecording = false;
    });

    if (result != null) {
      Uint8List content = await File(result).readAsBytes();
      await sendAudioToServer(result, content);
    }
  }

//녹음 파일을 서버로 보내고 결과값을 반환함 
Future<void> sendAudioToServer(String filePath, Uint8List content) async {
  final apiUrl = Uri.parse('$address/quiz/upload-audio/');
  try {
    http.post(
      apiUrl,
      body: content,
    ).then((http.Response response) {
      // 응답을 제대로 받았다면
      if (response.statusCode == 200) {

        Map<String, dynamic> responseBodyMap = json.decode(response.body);
        String transcript = responseBodyMap['transcript'];
        double accuracy = responseBodyMap['accuracy'];
        String recordingTime = responseBodyMap['recording_time'];

        print('transcripts : $transcript');
        print('accuracy: $accuracy');
        print('recordingTime: $recordingTime');
        
        ResultManager resultManager = ResultManager(authManager: authManager , quiz: quiz, userResponse: transcript, accuracy: accuracy, recordingTime: recordingTime);
        resultManager.getSimilarity(context);

      } else {
        //응답을 받지 못했다면 
        print('Failed to send audio. Status code: ${response.statusCode}');
      }
    });
  } catch (error) {
    print('Error sending audio: $error');
  }
}

//선택된 주제가 없을 경우 경고 알림창
  void noSelectedTopicDialog() {
    authManager.showAuthDialog(context, "경고", "선택된 주제가 없습니다");
  }

  void logoutAndNavigateToLoginPage() {
    authManager.showAuthDialog(context,"세션 만료", "세션이 만료되었습니다. 다시 로그인해 주세요.");
  }
}
