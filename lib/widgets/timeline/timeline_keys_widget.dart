import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_commands.dart';
import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/widgets/timeline/layer_name_heading_widget.dart';
import 'package:shapey/widgets/timeline/layer_name_widget.dart';
import 'package:shapey/widgets/timeline/timeline_key_details_widget.dart';
import 'package:shapey/widgets/timeline/tl_left_side_parts/tl_fps_display.dart';

import 'tl_headline_parts/tl_headline.dart';

/// The keyframes on the right side of the timeline IE ||||||| x rows
class KeyframesVerticalList extends ConsumerWidget {
  final ScrollController tlLayerViewScrollbar;
  final double layerHeight;
  const KeyframesVerticalList({
    super.key,
    required this.layerHeight,
    required this.tlLayerViewScrollbar,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FileLayer> layers = ref.watch(
      fileNotifier.select((s) => s.layers),
    );
    final double duration = ref.watch(
      fileNotifier.select((s) => s.timelineDuration),
    );
    final int fps = ref.watch(fileNotifier.select((s) => s.fps));

    ColorScheme colorScheme = Theme.of(context).colorScheme;

    final int totalFrames = (duration * fps).toInt();

    final ListView layerKeysList = ListView.builder(
      scrollDirection: Axis.vertical,
      prototypeItem: SizedBox(height: layerHeight),
      itemCount: layers.length, // for performance
      controller: tlLayerViewScrollbar,
      cacheExtent: 1000,
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: true,
      itemBuilder: (context, layerIndex) {
        final cs = colorScheme;
        final frames = totalFrames;
        return TimelineKeyDetails(
          key: ValueKey(layers[layerIndex].guid()),
          colorScheme: cs,
          fps: fps,
          frames: frames,
          layerGUID: layers[layerIndex].guid(),
        );
      },
    );

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(
        context,
      ).copyWith(scrollbars: false, overscroll: false),
      child: RawScrollbar(
        controller: tlLayerViewScrollbar,
        trackVisibility: true,
        interactive: true,
        thickness: 10,
        thumbVisibility: true,
        thumbColor: colorScheme.onSecondary,
        fadeDuration: Duration(milliseconds: 200),
        trackRadius: Radius.circular(33),
        trackColor: colorScheme.onPrimaryFixed,
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        minThumbLength: 12,
        shape: StadiumBorder(),
        child: layerKeysList,
      ),
    );
  }
}

/// The Layer Names on the left side, IE Visible, locked, Layer name list
class LayerNamesVerticalList extends ConsumerWidget {
  final ScrollController tlNameViewScrollbar;
  final double layerHeight;
  const LayerNamesVerticalList({
    super.key,
    required this.tlNameViewScrollbar,
    required this.layerHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ONLY listen to layer changes
    final List<FileLayer> layers = ref.watch(
      fileNotifier.select((s) => s.layers),
    );
    return ListView.builder(
      itemCount: layers.length,

      prototypeItem: SizedBox(height: layerHeight),
      scrollDirection: Axis.vertical,
      cacheExtent: 500 * layerHeight,
      controller: tlNameViewScrollbar,
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: true,
      itemBuilder: (context, layerIndex) => LayerName(
        key: ValueKey("Row-LayerName-$layerIndex"),
        layer: layers[layerIndex],
      ),
    );
  }
}

class TimelineKeys extends ConsumerStatefulWidget {
  final bool? isHeading;
  final double keysWidth;
  final double height;
  final double headerHeight;
  final double layerViewWidth;
  final ColorScheme colorScheme;

  const TimelineKeys({
    super.key,
    this.isHeading,
    required this.keysWidth,
    required this.height,
    required this.headerHeight,
    required this.layerViewWidth,
    required this.colorScheme,
  });

  @override
  ConsumerState<TimelineKeys> createState() => _TimelineKeysState();
}

class _TimelineKeysState extends ConsumerState<TimelineKeys> {
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
    final layerNamesList = LayerNamesVerticalList(
      tlNameViewScrollbar: tlNameViewScrollbar,
      layerHeight: layerHeight,
    );
    final timelineLayers = KeyframesVerticalList(
      tlLayerViewScrollbar: tlLayerViewScrollbar,
      layerHeight: layerHeight,
    );
    final timelineHeader = Row(
      children: [
        TimelineLayerDetails(
          width: widget.layerViewWidth,
          height: widget.headerHeight,
          scrollController: timelineVerticalScrollController,
        ),
        TimelineHeadline(
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
