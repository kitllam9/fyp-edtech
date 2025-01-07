enum QuestionType {
  short,
  mc;

  static QuestionType fromString(String? str) {
    switch (str) {
      case 'short':
        return short;
      case 'mc':
        return mc;
      default:
        return short;
    }
  }
}

class Question {
  final String question;
  final String answer;
  final QuestionType type;
  final List<dynamic>? choices;

  Question({
    required this.question,
    required this.answer,
    required this.type,
    this.choices,
  });

  static Question fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      answer: json['answer'],
      type: QuestionType.fromString(json['type']),
      choices: json['mc'],
    );
  }
}
