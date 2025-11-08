import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_commands.dart';
import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/widgets/timeline/tl_headline_parts/timeline_name_heading.dart';
import 'package:shapey/widgets/timeline/timeline_keys.dart';
import 'package:shapey/widgets/timeline/timeline_names.dart';
import 'package:shapey/widgets/timeline/tl_left_side_parts/tl_fps_display.dart';

import 'tl_headline_parts/timeline_layer_heading.dart';

class TimelineLayout extends ConsumerStatefulWidget {
  final bool? isHeading;
  final double keysWidth;
  final double height;
  final double headerHeight;
  final double layerViewWidth;
  final ColorScheme colorScheme;

  const TimelineLayout({
    super.key,
    this.isHeading,
    required this.keysWidth,
    required this.height,
    required this.headerHeight,
    required this.layerViewWidth,
    required this.colorScheme,
  });

  @override
  ConsumerState<TimelineLayout> createState() => _TimelineKeysState();
}

class _TimelineKeysState extends ConsumerState<TimelineLayout> {
  late final ScrollController tlLayerViewScrollbar;
  late final ScrollController tlNameViewScrollbar;

  late final ScrollController timelineVerticalScrollController;

  late final TextEditingController fpsConfirmTextEditController;

  @override
  void initState() {
    super.initState();
    // for layer scrolling
    tlLayerViewScrollbar = ScrollController();
    tlNameViewScrollbar = ScrollController();
    timelineVerticalScrollController = ScrollController();
    fpsConfirmTextEditController = TextEditingController();

    tlLayerViewScrollbar.addListener(scrollLayersBasedOffKeys);
    tlNameViewScrollbar.addListener(scrollLayersBasedOffNames);
  }

  @override
  void dispose() {
    super.dispose();
    tlLayerViewScrollbar.removeListener(scrollLayersBasedOffKeys);
    tlNameViewScrollbar.addListener(scrollLayersBasedOffNames);
    tlLayerViewScrollbar.dispose();
    tlNameViewScrollbar.dispose();
    fpsConfirmTextEditController.dispose();
    timelineVerticalScrollController.dispose();
  }

  // links the layer VERTICAL scrollbar with the keyframes VERTICAL scrollbar
  void scrollLayersBasedOffKeys() {
    if (tlLayerViewScrollbar.offset != tlNameViewScrollbar.offset) {
      tlNameViewScrollbar.jumpTo(tlLayerViewScrollbar.offset);
    }
  }

  void scrollLayersBasedOffNames() {
    if (tlNameViewScrollbar.offset != tlLayerViewScrollbar.offset) {
      tlLayerViewScrollbar.jumpTo(tlNameViewScrollbar.offset);
    }
  }

  final double gridObjectWidth = 8;

  @override
  Widget build(BuildContext context) {
    // print("TimelineKeysWidget");
    final AppCommandInvoker appCommandHistory = ref.watch(
      appNotifier.select((s) => s.appCommandHistory),
    );
    // this component DOESNT auto refresh, children do, if needed
    final double tlDuration = ref.watch(
      fileNotifier.select((s) => s.timelineDuration),
    );
    final int fps = ref.watch(fileNotifier.select((s) => s.fps));

    final double layerHeight = 25; // height of a layer cell
    final totalFrames = (tlDuration * fps).toInt();
    final layerNamesList = TimelineNamesList(
      tlNameViewScrollbar: tlNameViewScrollbar,
      layerHeight: layerHeight,
    );
    final timelineLayers = TimelineKeysList(
      tlLayerViewScrollbar: tlLayerViewScrollbar,
      layerHeight: layerHeight,
    );
    final timelineHeader = Row(
      children: [
        TimelineNameHeading(
          width: widget.layerViewWidth,
          height: widget.headerHeight,
          scrollController: timelineVerticalScrollController,
        ),
        TimelineLayerHeading(
          colorScheme: widget.colorScheme,
          fps: fps,
          frames: totalFrames,
        ),
      ],
    );
    // FOOTER
    double layerViewFooterHeight = 40;
    double keyframesHeight =
        widget.height - widget.headerHeight - layerViewFooterHeight;
    final timelineFooter = Container(
      width: widget.layerViewWidth,
      height: layerViewFooterHeight,
      decoration: BoxDecoration(color: widget.colorScheme.onPrimaryContainer),
      child: Padding(
        padding: EdgeInsetsGeometry.only(right: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 22,
          children: [
            IconButton(
              onPressed: () {
                print("pressed the remove button");
                //TODO: Add the concept of ACTIVE layers
                // ref.read(fileNotifier.notifier).removeLayer();
              },
              icon: Icon(
                size: 18,
                Icons.delete,
                color: widget.colorScheme.onPrimary,
              ),
            ),
            TLFpsDisplay(
              size: Size(widget.layerViewWidth, layerViewFooterHeight),
              colorScheme: widget.colorScheme,
              fpsEditController: fpsConfirmTextEditController,
            ),
            IconButton(
              onPressed: () {
                // print("pressed the add button");
                final FileNotifier fileModel = ref.read(fileNotifier.notifier);
                appCommandHistory.executeCommand(AddLayerCommand(fileModel));
              },
              icon: Icon(
                size: 18,
                Icons.add_to_photos_sharp,
                color: widget.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );

    var leftAndRightSideOfTimeline = Stack(
      children: [
        Positioned(
          top: widget.headerHeight,
          left: widget.layerViewWidth,
          width: widget.keysWidth,
          height: keyframesHeight,
          child: timelineLayers,
        ),
        Positioned(
          top: widget.headerHeight,
          width: widget.layerViewWidth,
          height: keyframesHeight,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: layerNamesList,
          ),
        ),
        Material(elevation: 3, child: timelineHeader),
        Positioned(bottom: 0, child: timelineFooter),
      ],
    );
    return leftAndRightSideOfTimeline;
  }
}
