import 'package:drift/native.dart';

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class LocalDatabaseException implements Exception {
  final String message;
  final String? explanation;
  final int? errorCode;

  const LocalDatabaseException._({
    required this.message,
    this.explanation,
    this.errorCode,
  });

  factory LocalDatabaseException(dynamic error) {
    if (error is SqliteException) {
      return LocalDatabaseException._(
          message: error.message,
          explanation: error.explanation,
          errorCode: error.extendedResultCode);
    }
    return const LocalDatabaseException._(message: 'Unknown error');
  }
}
