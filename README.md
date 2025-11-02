# minimp3_dart

Pure Dart port of the [minimp3](https://github.com/lieff/minimp3) MP3 decoder.
This package mirrors the structure of the original single-header C implementation
to make auditing and maintenance straightforward.

## Features

- ✅ Full Layer III (MP3) decoding
- ✅ Frame synchronization and free-format support
- ✅ Bit reservoir management
- ✅ Mono and stereo (including intensity/MS stereo)
- ✅ Short/long/mixed blocks with IMDCT
- ✅ Polyphase synthesis filterbank
- ⚠️ Layer I/II support omitted (MP3-only)
- ⚠️ No SIMD optimizations (scalar fallback only)

## Status

The core MP3 decoding pipeline is complete and produces bit-accurate output
(within floating-point precision tolerance). Golden tests decode ISO conformance
vectors and verify PCM output against the reference C implementation.

## Example

```dart
import 'dart:io';
import 'dart:typed_data';

import 'package:minimp3_dart/minimp3.dart';

void main() {
  final decoder = Mp3Decoder();
  decoder.initialize();
  
  final bytes = File('song.mp3').readAsBytesSync();
  int offset = 0;
  
  final List<int> allPcm = [];
  
  while (offset < bytes.length) {
    final frame = decoder.decodeFrame(bytes, offset: offset);
    if (frame == null) {
      break;
    }
    
    allPcm.addAll(frame.pcm);
    offset = frame.nextOffset;
    
    print('Decoded ${frame.samples} samples at ${frame.info.sampleRateHz} Hz, '
          '${frame.info.channels} channel(s)');
  }
  
  print('Total decoded: ${allPcm.length} PCM samples');
}
```

## Testing

Golden tests verify decoder output against ISO conformance vectors:

```bash
dart test
```

The `decoder_golden_test.dart` also writes a WAV file to `test/output/` for
manual inspection.

## Performance

Since this is a direct port prioritizing correctness over speed, performance is
not optimized. SIMD paths from the original are intentionally omitted; only the
scalar fallback is implemented. For production use cases requiring high
throughput, consider FFI bindings to the native minimp3 library.

## Contributing

When porting additional functionality, please mirror the C source structure as
closely as possible before refactoring. Comments mapping Dart code back to
original line numbers are welcome.

## License

Like the original minimp3, this code is released to the public domain (CC0).
