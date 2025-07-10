import 'package:flutter_test/flutter_test.dart';
import 'package:wisme_app2/models/result.dart';

void main() {
  group('Result Tests', () {
    test('Success result should work correctly', () {
      final result = Result.success('test data');
      
      expect(result.isSuccess, true);
      expect(result.isFailure, false);
      expect(result.isLoading, false);
      expect(result.data, 'test data');
      expect(result.error, null);
    });

    test('Failure result should work correctly', () {
      final failure = NetworkFailure(
        message: 'Network error',
        code: 'network_error',
      );
      final result = Result<String>.failure(failure);
      
      expect(result.isSuccess, false);
      expect(result.isFailure, true);
      expect(result.isLoading, false);
      expect(result.data, null);
      expect(result.error, failure);
    });

    test('Loading result should work correctly', () {
      final result = Result<String>.loading('Loading...');
      
      expect(result.isSuccess, false);
      expect(result.isFailure, false);
      expect(result.isLoading, true);
      expect(result.data, null);
      expect(result.error, null);
    });

    test('should handle result chaining with map', () {
      final successResult = Result.success(10);
      final mappedResult = successResult.map((value) => value * 2);
      
      expect(mappedResult.isSuccess, true);
      expect(mappedResult.data, 20);
    });

    test('should handle result chaining with flatMap', () {
      final successResult = Result.success(10);
      final flatMappedResult = successResult.flatMap((value) => 
        Result.success(value.toString())
      );
      
      expect(flatMappedResult.isSuccess, true);
      expect(flatMappedResult.data, '10');
    });

    test('should handle error cases in map', () {
      final failure = NetworkFailure(
        message: 'Network error',
        code: 'network_error',
      );
      final failureResult = Result<int>.failure(failure);
      final mappedResult = failureResult.map((value) => value * 2);
      
      expect(mappedResult.isFailure, true);
      expect(mappedResult.error, failure);
    });
  });

  group('WismeFailure Tests', () {
    test('NetworkFailure should have correct properties', () {
      final failure = NetworkFailure(
        message: 'Connection timeout',
        code: 'timeout',
      );
      
      expect(failure.message, 'Connection timeout');
      expect(failure.code, 'timeout');
      expect(failure.isRetryable, true);
      expect(failure.userMessage, 'Request timed out. Please try again.');
    });

    test('AuthFailure should have correct properties', () {
      final failure = AuthFailure(
        message: 'Invalid credentials',
        code: 'wrong_password',
      );
      
      expect(failure.message, 'Invalid credentials');
      expect(failure.code, 'wrong_password');
      expect(failure.requiresAuth, true);
      expect(failure.userMessage, 'Incorrect password. Please try again.');
    });

    test('ValidationFailure should have correct properties', () {
      final failure = ValidationFailure(
        message: 'Invalid email format',
        code: 'invalid_email',
      );
      
      expect(failure.message, 'Invalid email format');
      expect(failure.code, 'invalid_email');
      expect(failure.userMessage, 'Please enter a valid email address.');
    });

    test('AIFailure should have correct properties', () {
      final failure = AIFailure(
        message: 'API quota exceeded',
        code: 'quota_exceeded',
      );
      
      expect(failure.message, 'API quota exceeded');
      expect(failure.code, 'quota_exceeded');
      expect(failure.isRetryable, false);
      expect(failure.userMessage, 'AI service limit reached. Please try again later.');
    });
  });
}
