import 'package:bitsdojo_window/bitsdojo_window.dart';
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

class PanelWidget extends ConsumerWidget {
  final String name;
  final Widget child;

  const PanelWidget({super.key, required this.name, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      elevation: 4,
      color: colorScheme.surfaceContainerLow,
      child: SizedBox(
        height: 250,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 25,
              color: colorScheme.onSecondaryContainer,
              alignment: Alignment.topLeft,
              padding: EdgeInsetsGeometry.fromLTRB(6, 3, 6, 2),
              child: Text(
                name,

                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: textTheme.bodyMedium?.fontSize,
                ),
                selectionColor: Colors.red,
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
