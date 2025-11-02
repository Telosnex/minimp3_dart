import 'dart:typed_data';

import 'package:minimp3_dart/minimp3.dart';
import 'package:test/test.dart';

void main() {
  test('returns null for insufficient data', () {
    final decoder = Mp3Decoder();
    final frame = decoder.decodeFrame(Uint8List(0));
    expect(frame, isNull);
  });
}
