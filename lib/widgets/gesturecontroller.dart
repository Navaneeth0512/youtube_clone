import 'package:flutter/material.dart';

class GestureVideoControls extends StatelessWidget {
  final Function(double) onBrightnessChange;
  final Function(double) onVolumeChange;
  final Function(double) onSeek;

  const GestureVideoControls({
    required this.onBrightnessChange,
    required this.onVolumeChange,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        onSeek(details.primaryDelta!);
      },
      onVerticalDragUpdate: (details) {
        if (details.localPosition.dx < MediaQuery.of(context).size.width / 2) {
          onBrightnessChange(details.primaryDelta!);
        } else {
          onVolumeChange(details.primaryDelta!);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: const Center(
          child: Icon(Icons.touch_app, color: Colors.white54),
        ),
      ),
    );
  }
}
