import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wisme_app2/UI/widgets/error_boundary.dart';

void main() {
  group('ErrorBoundary Widget Tests', () {
    testWidgets('should display error message correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorBoundary.createErrorWidget(
            title: 'Test Error',
            message: 'This is a test error message',
            onRetry: () {},
          ),
        ),
      );

      expect(find.text('Test Error'), findsOneWidget);
      expect(find.text('This is a test error message'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should call onRetry when retry button is pressed', (tester) async {
      bool retryPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorBoundary.createErrorWidget(
            title: 'Test Error',
            message: 'This is a test error message',
            onRetry: () {
              retryPressed = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryPressed, true);
    });

    testWidgets('NetworkError should display correct content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NetworkError(onRetry: () {}),
        ),
      );

      expect(find.text('No Internet Connection'), findsOneWidget);
      expect(find.text('Please check your internet connection and try again.'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('LoadingError should display correct content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoadingError(
            message: 'Failed to load data',
            onRetry: () {},
          ),
        ),
      );

      expect(find.text('Failed to Load'), findsOneWidget);
      expect(find.text('Failed to load data'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });

    testWidgets('NotFoundError should display correct content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NotFoundError(
            message: 'Content not found',
            onGoHome: () {},
          ),
        ),
      );

      expect(find.text('Content Not Found'), findsOneWidget);
      expect(find.text('Content not found'), findsOneWidget);
    });

    testWidgets('GenericError should display correct content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GenericError(
            message: 'Something went wrong',
            onRetry: () {},
          ),
        ),
      );

      expect(find.text('Something Went Wrong'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
    });
  });
}
