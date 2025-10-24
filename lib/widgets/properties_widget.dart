import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/utility/panel_widget.dart';

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
    return PanelWidget(name: "Properties", child: Container());
  }
}
