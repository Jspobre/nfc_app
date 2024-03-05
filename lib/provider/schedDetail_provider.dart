import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_app/database/database_service.dart';
import 'package:nfc_app/provider/filterPage_provider.dart';

final schedDetailProvider = FutureProvider<String>((ref) async {
  final dbService = DatabaseService();
  final filters = ref.watch(filterProvider);

  final schedDetail =
      await dbService.fetchSchedDetails(filters['sched'] as int);

  return schedDetail;
});
