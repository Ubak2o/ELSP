class Quiz {
  
  String section;
  String question;
  String topic;

  Quiz({required this.question, required this.topic, required this.section});

  Quiz.fromJason(Map<String, dynamic> json) 
    : section = json['section'],
      question = json['question'],
      topic = json['topic'];
}