import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/record.dart';

// void resetNfcTag(NFCTag tag) async {
//    try {
//     // Connect to the NFC tag
//     NfcTag tag = await _connectToNfcTag();

//     // Read existing data
//     NdefMessage existingData = await _readNfcTag(tag);

//     // Define the new data to be written (replace this with actual reset data)
//     NdefMessage resetData = NdefMessage([
//       NdefRecord.text("Reset Content", "en"),
//     ]);

//     // Write the new data to the tag
//     await _writeNfcTag(tag, resetData);

//     // Verify the reset
//     NdefMessage newData = await _readNfcTag(tag);

//     print("NFC tag successfully reset!");
//     print("Existing Data: $existingData");
//     print("New Data: $newData");
//   } catch (error) {
//     print("Error resetting NFC tag: $error");
//   }
// }


// Future<NfcTag> _connectToNfcTag() async {
//   // Use flutter_nfc_kit to connect to the NFC tag
//   NfcTag tag = await FlutterNfcKit.poll();
//   return tag;
// }

// Future<NdefMessage> _readNfcTag(NfcTag tag) async {
//   // Use flutter_nfc_kit to read NDEF data from the NFC tag
//   NdefMessage data = await FlutterNfcKit.readNDEF(tag);
//   return data;
// }

// Future<void> _writeNfcTag(NfcTag tag, NdefMessage data) async {
//   // Use flutter_nfc_kit to write NDEF data to the NFC tag
//   await FlutterNfcKit.writeNDEF(tag, data);
// }
