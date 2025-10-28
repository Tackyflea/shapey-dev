import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/widgets/timeline/layer_name_heading_widget.dart';
import 'package:shapey/widgets/timeline/layer_name_widget.dart';
import 'package:shapey/widgets/timeline/timeline_key_details_widget.dart';

class KeyframesVerticalList extends StatelessWidget {
  final ScrollController tlLayerViewScrollbar;
  final Widget layerKeysList;
  const KeyframesVerticalList({
    super.key,
    required this.tlLayerViewScrollbar,
    required this.layerKeysList,
  });

  @override
  Widget build(BuildContext context) {
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
        thumbColor: Theme.of(context).colorScheme.onSecondary,
        fadeDuration: Duration(milliseconds: 200),
        trackRadius: Radius.circular(33),
        trackColor: Theme.of(context).colorScheme.onPrimaryFixed,
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        minThumbLength: 12,
        shape: StadiumBorder(),
        child: layerKeysList,
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

  @override
  void initState() {
    super.initState();
    // for layer scrolling
    tlLayerViewScrollbar = ScrollController();
    tlNameViewScrollbar = ScrollController();
    timelineVerticalScrollController = ScrollController();
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
    var fileData = ref.read(fileNotifier.notifier);
    final double tlDuration = fileData.timelineDuration; //second
    final double tlFPS = fileData.fps; // frames per seconsd
    final int layerCount = 14; // TEST layer count , TODO: Link it
    final double layerHeight = 25; // height of a layer cell

    final totalFrames = (tlDuration * tlFPS).toInt();
    final layerKeysList = ListView.builder(
      scrollDirection: Axis.vertical,
      prototypeItem: SizedBox(
        width: widget.layerViewWidth,
        height: layerHeight,
      ),
      itemCount: layerCount, // for performance
      controller: tlLayerViewScrollbar,
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: true,
      itemBuilder: (context, layerIndex) => RepaintBoundary(
        child: TimelineKeyDetails(
          colorScheme: widget.colorScheme,
          isHeading: widget.isHeading,
          fps: tlFPS,
          frames: totalFrames,
          useExpanded: false,
          layer: layerIndex,
        ),
      ),
    );
    final layerNamesList = ListView.builder(
      itemExtent: layerHeight, // for performance
      itemCount: layerCount,

      scrollDirection: Axis.vertical,
      controller: tlNameViewScrollbar,
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: true,
      itemBuilder: (context, layerIndex) => LayerName(
        key: ValueKey("Row-LayerName-$layerIndex"),
        name: "a$layerIndex",
      ),
    );
    final timelineLayers = KeyframesVerticalList(
      layerKeysList: layerKeysList,
      tlLayerViewScrollbar: tlLayerViewScrollbar,
    );
    final timelineHeader = Row(
      children: [
        TimelineLayerDetails(
          width: widget.layerViewWidth,
          height: widget.headerHeight,
          scrollController: timelineVerticalScrollController,
        ),
        TimelineKeyDetails(
          colorScheme: widget.colorScheme,
          isHeading: true,
          fps: tlFPS,
          frames: totalFrames,
          layer: -1, // heading has no layer index
          useExpanded: true, // ← Use Expanded in Row
        ),
      ],
    );
    // FOOTER
    double layerViewFooterHeight = 40;
    double keyframesHeight =
        widget.height - widget.headerHeight - layerViewFooterHeight;
    final BorderSide tlLayerViewHeaderBorder = BorderSide(
      color: widget.colorScheme.primaryContainer,
      width: 1.0,
    );
    final timelineFooter = Container(
      width: widget.layerViewWidth,
      height: layerViewFooterHeight,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: widget.colorScheme.onPrimaryContainer,
        border: Border.all(
          color: tlLayerViewHeaderBorder.color,
          width: tlLayerViewHeaderBorder.width,
        ),
      ),
    );
    return Stack(
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
  }
}
