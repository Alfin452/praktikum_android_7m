class QuizQuestion {
  const QuizQuestion(
    required this.id,
    required this.text,
    required this.answer,
    );

  final String text;
  final List<String> answers;

  List<String> getShuffledAnswer() {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}
