import 'package:flutter_riverpod/flutter_riverpod.dart';

int dayValue = 0; //0 for today
int monthValue = 0; //0 for this month
DateTime? datePickerSelected;

// DateTime selectedDay =
//     (datePickerSelected ?? DateTime.now()).add(Duration(days: dayValue));
// DateTime selectedMonth =
//     DateTime(selectedDay.year, selectedDay.month + monthValue, selectedDay.day);
// // Format the current date into "MONTH DAY, YEAR" format
// String formattedDate = DateFormat('MMMM dd, yyyy').format(selectedMonth);

// FOR ATTENDANCE REPORT
final dayValueProvider = StateProvider<int>((ref) => 0);
final monthValueProvider = StateProvider<int>((ref) => 0);
final datePickerSelectedProvider = StateProvider<DateTime?>((ref) => null);





// FOR ANALYTICS

