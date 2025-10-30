import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:keymap/keymap.dart';
import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/app_state/app_model.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double windowWidth = constraints.maxWidth - 4;

        const double titleBarHeight = 25;
        const double layerViewWidth = 220;
        const double layerViewHeaderHeight = 25;
        return PanelWidget(
          name: "Timeline",
          child: TimelineKeys(
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
