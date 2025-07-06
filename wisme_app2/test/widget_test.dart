// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:wisme_app2/app.dart';

void main() {
  testWidgets('WismeApp builds and shows home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const WismeApp());

    // Check for the presence of the app title or a known widget on the home screen
    expect(find.text('Wisme - Microlearning App'), findsOneWidget);
    // Optionally, check for a widget you know is on the home screen, e.g. a navigation bar or a button
    // expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
