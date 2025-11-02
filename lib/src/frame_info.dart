/// Metadata describing a decoded MP3 frame.
class Mp3FrameInfo {
  Mp3FrameInfo({
    this.frameBytes = 0,
    this.frameOffset = 0,
    this.channels = 0,
    this.sampleRateHz = 0,
    this.layer = 0,
    this.bitrateKbps = 0,
  });

  int frameBytes;
  int frameOffset;
  int channels;
  int sampleRateHz;
  int layer;
  int bitrateKbps;

  Mp3FrameInfo copy() => Mp3FrameInfo(
        frameBytes: frameBytes,
        frameOffset: frameOffset,
        channels: channels,
        sampleRateHz: sampleRateHz,
        layer: layer,
        bitrateKbps: bitrateKbps,
      );
}
