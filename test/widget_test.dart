import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';

void main() {
  testWidgets('QuizApp renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizApp());
    expect(find.byType(QuizApp), findsOneWidget);
  });
}
