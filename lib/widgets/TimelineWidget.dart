import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_notifier.dart';
import 'package:shapey/utility/PanelWidget.dart';
import 'package:shapey/utility/Utility.dart';

const horisontalGridSettings = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 3.5,
  crossAxisSpacing: 2,
  mainAxisSpacing: 2,
);

class TimelineWidget extends ConsumerWidget {
  const TimelineWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return PanelWidget(
      name: "Timeline",
      child: GridView(gridDelegate: horisontalGridSettings, children: [
        
        ],
      ),
    );
  }
}
