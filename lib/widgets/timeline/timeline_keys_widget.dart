import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/widgets/timeline/layer_name_heading_widget.dart';
import 'package:shapey/widgets/timeline/layer_name_widget.dart';
import 'package:shapey/widgets/timeline/timeline_key_details_widget.dart';

//  header bg
class KeyVisualHeader extends StatelessWidget {
  final int frameNumber;
  final double fps;
  final double height;
  final double width;
  final ColorScheme colorScheme;
  const KeyVisualHeader({
    super.key,
    required this.width,
    required this.height,
    required this.frameNumber,
    required this.fps,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final horisontalMargin = width * 0.3;

    final TextTheme textTheme = Theme.of(context).textTheme;
    final boxBorder = Border.all(
      color: colorScheme.secondaryContainer,
      width: 1.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    );
    final bool isWholeSecond = frameNumber.toDouble() % fps == 0;
    //custom color for second
    if (isWholeSecond) {
      var textData = (frameNumber.toDouble() / fps).toInt().toString();
      return Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                textData,
                textAlign: TextAlign.center,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: textTheme.bodySmall?.fontSize,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: horisontalMargin,
                top: 3,
                right: horisontalMargin,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                border: boxBorder,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(
          horisontalMargin,
          height * 0.72,
          horisontalMargin,
          0,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorScheme.tertiaryFixedDim,
          border: boxBorder,
        ),
      );
    }
  }
}

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
        child: SingleChildScrollView(
          controller: tlLayerViewScrollbar,
          child: layerKeysList,
        ),
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
    // DateTime now = DateTime.now();
    // print('TimelineKeys rebuild ${now.second}');
    var fileData = ref.read(fileNotifier.notifier);
    final double tlDuration = fileData.timelineDuration; //second
    final double tlFPS = fileData.fps; // frames per seconsd
    final int layerCount = 14; // TEST layer count , TODO: Link it
    final double layerHeight = 25; // height of a layer cell

    final totalFrames = (tlDuration * tlFPS).toInt();
    final layerKeysList = SizedBox(
      height: layerCount * layerHeight,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: layerCount, // for performance
        itemExtent: layerHeight,
        itemBuilder: (context, index) => TimelineKeyDetails(
          colorScheme: widget.colorScheme,
          isHeading: widget.isHeading,
          fps: tlFPS,
          keyWidth: gridObjectWidth,
          keyHeight: layerHeight,
          frames: totalFrames,
          useExpanded: false,
        ),
      ),
    );
    final layerNamesList = SizedBox(
      height: layerCount * layerHeight,
      child: ListView.builder(
        itemExtent: layerHeight, // for performance
        itemCount: layerCount,
        itemBuilder: (context, index) => LayerName(name: "a$index"),
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
          keyWidth: gridObjectWidth,
          keyHeight: layerHeight,
          frames: totalFrames,
          useExpanded: true, // ← Use Expanded in Row
        ),
      ],
    );
    // FOOTER
    double layerViewFooterHeight = 40;
    double keyframesHeight =
        widget.height -
        widget.headerHeight -
        layerViewFooterHeight /
            2; // seems hacky to /2 , layerViewFooter height might be off
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
          left: widget.layerViewWidth,
          width: widget.keysWidth,
          height: keyframesHeight,
          child: timelineLayers,
        ),
        Positioned(
          width: widget.layerViewWidth,
          height: keyframesHeight,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: tlNameViewScrollbar,
              child: layerNamesList,
            ),
          ),
        ),
        Material(elevation: 3, child: timelineHeader),
        Positioned(bottom: 0, child: timelineFooter),
      ],
    );
  }
}
