import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Scanner {
  Future<String> newScan() async {
    String read = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", 'Cancel', true, ScanMode.DEFAULT);
    return read;
  }
}