import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final BorderSide headerBorder = BorderSide(
      color: colorScheme.primaryContainer,
      width: 2.0,
    );

    return Material(
      elevation: 4,
      color: colorScheme.surfaceContainerLow,
      child: SizedBox(
        height: 250,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme.onSecondaryContainer,
                border: Border(
                  left: headerBorder,
                  right: headerBorder,
                  top: headerBorder,
                ),
              ),
              width: double.infinity,
              height: 25,
              alignment: Alignment.topLeft,
              padding: EdgeInsetsGeometry.fromLTRB(5, 1.5, 0, 0),
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
