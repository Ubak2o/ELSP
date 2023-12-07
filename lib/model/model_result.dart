class Result {
  String user;
  String question;
  String topic;
  String userResponse;
  String correctedResponse;
  String recordingTime;
  double accuracy;
  double similarity;
  String currentDate; // 추가: 현재 날짜와 시간

  Result({
    required this.user,
    required this.question,
    required this.topic,
    required this.userResponse,
    required this.correctedResponse,
    required this.recordingTime,
    required this.accuracy,
    required this.similarity,
    required this.currentDate, // 추가
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      user: json['user'],
      question: json['question'],
      topic : json['topic'],
      userResponse: json['user_response'],
      correctedResponse: json['corrected_response'],
      recordingTime: json['recording_time'],
      accuracy: json['accuracy'],
      similarity: json['similarity'],
      currentDate: json['current_date'], // JSON에서 DateTime으로 변환
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'question': question,
      'topic' : topic,
      'user_response': userResponse,
      'corrected_response': correctedResponse,
      'recording_time': recordingTime,
      'accuracy': accuracy,
      'similarity': similarity,
      'current_date': currentDate, // DateTime을 ISO 8601 형식의 문자열로 변환
    };
  }
}