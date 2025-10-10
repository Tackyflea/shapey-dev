import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_notifier.dart';
import 'package:shapey/enums/e_active_tool.dart';

const horisontalGridSettings = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 1.0,
  crossAxisSpacing: 2,
  mainAxisSpacing: 2,
);

class ToolsWidget extends ConsumerWidget {
  const ToolsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: horisontalGridSettings,
      itemCount: ActiveTool.values.length,
      itemBuilder: (context, index) {
        final tool = ActiveTool.values[index];
        return InkWell(
          // update app model's active tool
          onTap: () => ref.read(appNotifier.notifier).updateTool(tool),
          child: Ink(
            color: Colors.red,
            child: Text(
              tool.shortName,
              style: const TextStyle(fontSize: 12, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
