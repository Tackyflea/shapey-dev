import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_notifier.dart';
import 'package:shapey/utility/Utility.dart';

const horisontalGridSettings = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 3.5,
  crossAxisSpacing: 2,
  mainAxisSpacing: 2,
);

class TopWidget extends ConsumerWidget {
  const TopWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    var personData = ref.watch(appNotifier);

    return Container(
      decoration: BoxDecoration(color: colorScheme.surface),
      child: GridView(
        gridDelegate: horisontalGridSettings,
        children: [
          Text(
            personData.activeTool.shortName,
            style: textTheme.headlineMedium,
          ),
          Tile(index: personData.age),
        ],
      ),
    );
  }
}
