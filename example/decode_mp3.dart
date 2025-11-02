import 'dart:io';
import 'dart:typed_data';

import 'package:minimp3_dart/minimp3.dart';

/// Simple example showing how to decode an MP3 file to PCM samples.
void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart example/decode_mp3.dart <input.mp3> [output.pcm]');
    print('');
    print('Decodes an MP3 file and optionally writes raw PCM to output file.');
    exit(1);
  }

  final inputPath = args[0];
  final outputPath = args.length > 1 ? args[1] : null;

  final mp3File = File(inputPath);
  if (!mp3File.existsSync()) {
    print('Error: Input file not found: $inputPath');
    exit(1);
  }

  print('Decoding $inputPath...');
  final stopwatch = Stopwatch()..start();

  final mp3Data = mp3File.readAsBytesSync();
  final decoder = Mp3Decoder();
  decoder.initialize();

  final List<int> allPcm = <int>[];
  int offset = 0;
  int frameCount = 0;
  Mp3FrameInfo? firstFrameInfo;

  while (offset < mp3Data.length) {
    final frame = decoder.decodeFrame(mp3Data, offset: offset);
    if (frame == null) {
      break;
    }

    if (frameCount == 0) {
      firstFrameInfo = frame.info;
      print('Format: ${frame.info.channels} ch, '
          '${frame.info.sampleRateHz} Hz, '
          '${frame.info.bitrateKbps} kbps, '
          'Layer ${frame.info.layer}');
    }

    allPcm.addAll(frame.pcm);
    offset = frame.nextOffset;
    frameCount++;
  }

  stopwatch.stop();
  print('Decoded $frameCount frames in ${stopwatch.elapsedMilliseconds} ms');
  print('Total samples: ${allPcm.length}');

  if (firstFrameInfo != null) {
    final durationSec =
        allPcm.length / (firstFrameInfo.sampleRateHz * firstFrameInfo.channels);
    print('Duration: ${durationSec.toStringAsFixed(2)} seconds');
  }

  if (outputPath != null) {
    final pcmData = Int16List.fromList(allPcm);
    final bytes = Uint8List.view(pcmData.buffer);
    File(outputPath).writeAsBytesSync(bytes);
    print('Wrote ${bytes.length} bytes to $outputPath');
  }
}
