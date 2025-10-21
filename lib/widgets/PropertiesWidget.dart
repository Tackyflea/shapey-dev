import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_notifier.dart';
import 'package:shapey/enums/e_active_tool.dart';
import 'package:shapey/utility/PanelWidget.dart';

const horisontalGridSettings = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 1.0,
  crossAxisSpacing: 2,
  mainAxisSpacing: 2,
);

class PropertiesWidget extends ConsumerWidget {
  const PropertiesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return PanelWidget(name: "Properties", child: Container());
  }
}
