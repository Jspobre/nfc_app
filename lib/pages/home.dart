import 'package:flutter/material.dart';
import 'package:nfc_app/widgets/styledButton.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "NFC: Tag Reader",
          style: TextStyle(fontFamily: "Roboto", fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Image.asset('lib/images/image 3.png'),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 44),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Welcome to NFC: Tag Reader",
                  style: TextStyle(fontFamily: "Roboto", fontSize: 20),
                ),
              ],
            ),
            Image.asset(
              'lib/images/image 1.png',
            ),
            Column(
              children: [
                StyledButton(
                  btnText: "Read",
                  onClick: () {},
                  noShadow: true,
                  btnWidth: double.infinity,
                ),
                const SizedBox(
                  height: 10,
                ),
                StyledButton(
                  btnText: "Write",
                  onClick: () {},
                  noShadow: true,
                  btnWidth: double.infinity,
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
