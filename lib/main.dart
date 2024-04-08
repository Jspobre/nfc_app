import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_app/pages/home.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC: Tag Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        // textTheme: GoogleFonts.robotoTextTheme().copyWith(
        //   bodyLarge: const TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.w500,
        //   ),
        //   titleLarge: const TextStyle(
        //       fontSize: 20, letterSpacing: 1, fontWeight: FontWeight.w500),
        // ),
        appBarTheme: const AppBarTheme(
          // centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: Color(0xFF252525),
          ), //w500 is medium
          color: Colors.white10,
          iconTheme: IconThemeData(color: Color(0xFF252525)),
          elevation: 0,
        ),
      ),
      home: const Home(),
    );
  }
}
