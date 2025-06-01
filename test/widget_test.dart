import 'package:flutter_test/flutter_test.dart';
import 'package:strezzlah/Pages/dass21_flutter_app.dart';

void main() {
  testWidgets('Start Survey button navigates to SurveyPage', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Check if the landing page contains the start button.
    expect(find.text('Start Survey'), findsOneWidget);

    // Tap the button and wait for navigation.
    await tester.tap(find.text('Start Survey'));
    await tester.pumpAndSettle();

    // Check if SurveyPage is now visible.
    expect(find.text('DASS-21 Survey'), findsOneWidget);
  });
}
