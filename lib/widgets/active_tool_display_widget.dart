import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_model.dart';

class ActiveToolDisplay extends ConsumerWidget {
  final double titleBarSize;
  const ActiveToolDisplay({super.key, required this.titleBarSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTool = ref.watch(appNotifier.select((s) => s.activeTool));

    final textTheme = Theme.of(context).textTheme;

    return Positioned(
      right: 20.0,
      top: titleBarSize + 5.0,
      child: IgnorePointer(
        ignoring: true,
        child: Text(
          textAlign: TextAlign.right,
          activeTool.shortName,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.outline,
            fontSize: textTheme.titleLarge?.fontSize,
          ),
        ),
      ),
    );
  }
}
