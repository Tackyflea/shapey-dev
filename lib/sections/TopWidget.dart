import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/Utility.dart';
import 'package:shapey/app_state/app_notifier.dart';

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
    var personData = ref.watch(appNotifier);
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: GridView(
        gridDelegate: horisontalGridSettings,
        children: [
          Text(personData.activeTool.shortName),
          Tile(index: personData.age),
        ],
      ),
    );
  }
}
