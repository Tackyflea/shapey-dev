import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_model.dart';

class TimelineScrubber extends ConsumerWidget {
  final double keyWidth;
  const TimelineScrubber({super.key, required this.keyWidth});
  final Image headerImage = const Image(
    image: ResizeImage(
      AssetImage('assets/images/scrubberheading.png'),
      width: 12,
      height: 15,
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int activeFrame = ref.watch(appNotifier.select((s) => s.activeFrame));
    final color = Theme.of(context).colorScheme.surfaceTint;
    final double scrubberWidth = 2.5;
    var scrubber_base = Positioned(
      top: -8,

      left: activeFrame * keyWidth - 2,
      child: IgnorePointer(
        ignoring: true,
        child: Column(
          children: [
            headerImage,
            Container(width: scrubberWidth, height: 500, color: color),
          ],
        ),
        // child: Container(width: 100, height: 110, color: Colors.red),
      ),
    );

    return scrubber_base;
  }
}
