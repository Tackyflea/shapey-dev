import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/utility/panel_widget.dart';
import 'package:shapey/widgets/timeline/timeline_keys_widget.dart';

const horisontalGridSettings = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 3.5,
  crossAxisSpacing: 2,
  mainAxisSpacing: 2,
);

class TimelineWidget extends ConsumerWidget {
  final double timelineHeight;
  const TimelineWidget({super.key, required this.timelineHeight});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size windowSize = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;
    double windowWidth = windowSize.width - padding.left - padding.right - 4;

    final double titleBarHeight =
        25; //todo, we dont need this, timelineHeight should already account for this , but doesnt yet
    double layerViewWidth = 220;
    double layerViewHeaderHeight = 25;
    return PanelWidget(
      name: "Timeline",
      child: TimelineKeys(
        layerViewWidth: layerViewWidth,
        keysWidth: windowWidth - layerViewWidth,
        height: timelineHeight - titleBarHeight,
        headerHeight: layerViewHeaderHeight,
      ),
    );
  }
}
