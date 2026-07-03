// Web-specific audio alerts using the Web Audio API.
// This file is only compiled on the web platform.
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart' as web;

/// Plays a two-tone kitchen alert chime (new order arrived).
void playKitchenAlert() {
  try {
    final ctx = web.AudioContext();

    // First tone
    final osc1 = ctx.createOscillator();
    final gain1 = ctx.createGain();
    (osc1 as web.AudioNode).connect(gain1 as web.AudioNode);
    (gain1 as web.AudioNode).connect(ctx.destination);
    osc1.frequency.value = 880.0;
    gain1.gain.value = 0.3;
    osc1.start();
    osc1.stop(ctx.currentTime + 0.15);

    // Second tone
    final osc2 = ctx.createOscillator();
    final gain2 = ctx.createGain();
    (osc2 as web.AudioNode).connect(gain2 as web.AudioNode);
    (gain2 as web.AudioNode).connect(ctx.destination);
    osc2.frequency.value = 1100.0;
    gain2.gain.value = 0.25;
    osc2.start(ctx.currentTime + 0.18);
    osc2.stop(ctx.currentTime + 0.35);
  } catch (_) {
    // silently ignore if autoplay is blocked
  }
}

/// Plays a single soft waiter notification ping.
void playWaiterAlert() {
  try {
    final ctx = web.AudioContext();
    final osc = ctx.createOscillator();
    final gain = ctx.createGain();
    (osc as web.AudioNode).connect(gain as web.AudioNode);
    (gain as web.AudioNode).connect(ctx.destination);
    osc.frequency.value = 660.0;
    gain.gain.value = 0.2;
    osc.start();
    osc.stop(ctx.currentTime + 0.25);
  } catch (_) {
    // silently ignore if autoplay is blocked
  }
}
