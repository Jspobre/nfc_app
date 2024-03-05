import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_app/database/database_service.dart';
import 'package:nfc_app/provider/filterPage_provider.dart';

final subjectNameProvider = FutureProvider<String>((ref) async {
  final dbService = DatabaseService();
  final filters = ref.watch(filterProvider);

  final subjectName =
      await dbService.fetchSubjectName(filters['subject'] as int);

  return subjectName;
});
