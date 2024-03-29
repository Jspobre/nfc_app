import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:nfc_app/widgets/styledButton.dart';

class ScanModal extends StatelessWidget {
  final String? details;

  const ScanModal({Key? key, this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (details != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                details!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          const Text(
            "Ready to Scan",
            style: TextStyle(
              fontSize: 25,
              color: Color(0xff939393),
            ),
          ),
          Image.asset('lib/images/image 4.png'),
          const Text(
            "Approach an NFC Tag",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          StyledButton(
            noShadow: true,
            textColor: Colors.black,
            btnColor: const Color(0xffCECECE),
            btnText: "Cancel",
            onClick: () async {
              await FlutterNfcKit.finish();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
