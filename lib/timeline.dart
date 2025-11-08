import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/utility/panel_widget.dart';
import 'package:shapey/widgets/timeline/tineline_layout.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    // This causes the entire rebuild / Refresh
    // This also causes the listview elements to fully rebuild
    return LayoutBuilder(
      builder: (context, constraints) {
        final double windowWidth = constraints.maxWidth - 4;

        // Confirmed: Refreshes on window size change: Yes
        const double titleBarHeight = 25;
        const double layerViewWidth = 220;
        const double layerViewHeaderHeight = 25;
        return PanelWidget(
          name: "Timeline",
          child: TimelineLayout(
            layerViewWidth: layerViewWidth,
            keysWidth: windowWidth - layerViewWidth,
            height: timelineHeight - titleBarHeight,
            headerHeight: layerViewHeaderHeight,
            colorScheme: colorScheme,
          ),
        );
      },
    );
  }
}
