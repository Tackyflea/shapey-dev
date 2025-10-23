import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_notifier.dart';
import 'package:shapey/widgets/timeline/LayerNameWidget.dart';
import 'package:shapey/utility/PanelWidget.dart';
import 'package:shapey/utility/Utility.dart';

const horisontalGridSettings = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 3.5,
  crossAxisSpacing: 2,
  mainAxisSpacing: 2,
);

class TimelineWidget extends ConsumerStatefulWidget {
  final double timelineHeight;
  const TimelineWidget({super.key, required this.timelineHeight});

  @override
  ConsumerState<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends ConsumerState<TimelineWidget> {
  late final ScrollController tlLayerViewScrollbar;
  late final ScrollController tlTimelineViewScrollbar;

  @override
  void initState() {
    super.initState();
    // for layer scrolling
    tlLayerViewScrollbar = ScrollController();
    // for timelineScrolling
    tlTimelineViewScrollbar = ScrollController();

    tlLayerViewScrollbar.addListener(layerScrollbarListener);
    tlTimelineViewScrollbar.addListener(timelineScrollingListener);
  }

  // link the 2 scroll bars
  void layerScrollbarListener() {
    // if (tlLayerViewScrollbar.offset != tlTimelineViewScrollbar.offset) {
    //   setState(() {
    //     tlLayerViewScrollbar.jumpTo(tlTimelineViewScrollbar.offset);
    //   });
    // }
  }

  void timelineScrollingListener() {
    if (tlTimelineViewScrollbar.offset != tlLayerViewScrollbar.offset) {
      setState(() {
        tlTimelineViewScrollbar.jumpTo(tlLayerViewScrollbar.offset);
      });
    }
  }

  @override
  void dispose() {
    tlLayerViewScrollbar.dispose();
    tlTimelineViewScrollbar.dispose();
    tlLayerViewScrollbar.removeListener(layerScrollbarListener);
    tlTimelineViewScrollbar.removeListener(timelineScrollingListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    Size windowSize = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;
    double windowWidth = windowSize.width - padding.left - padding.right - 4;

    final double titleBarHeight =
        25; //todo, we dont need this, timelineHeight should already account for this , but doesnt yet
    double layerViewWidth = 220;
    double layerViewHeaderHeight = 25;
    double layerViewFooterHeight = 40;
    final BorderSide tlLayerViewHeaderBorder = BorderSide(
      color: colorScheme.primaryContainer,
      width: 1.0,
    );
    final tlLayerViewHeader = Container(
      width: layerViewWidth,
      height: layerViewHeaderHeight,
      decoration: BoxDecoration(
        color: colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0)),
        border: Border(
          bottom: tlLayerViewHeaderBorder,
          top: tlLayerViewHeaderBorder,
        ),
      ),
    );
    final tlLayerViewFooter = Container(
      width: layerViewWidth,
      height: layerViewFooterHeight,
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: colorScheme.onPrimaryContainer,
        border: Border.all(
          color: tlLayerViewHeaderBorder.color,
          width: tlLayerViewHeaderBorder.width,
        ),
      ),
    );

    // Controls all the layers
    final tlLayerViewLayersColumn = Column(
      children: [
        LayerNameWidget(name: "sdfsd", locked: true),
        LayerNameWidget(name: "sdfsdfsdfsd"),
        LayerNameWidget(name: "sds"),
        LayerNameWidget(name: "sdfsdfsdfsd", locked: true),
        LayerNameWidget(name: "d", visible: false),
        LayerNameWidget(name: "a"),
        LayerNameWidget(name: "a"),
        LayerNameWidget(name: "a"),
        LayerNameWidget(name: "a"),
        LayerNameWidget(name: "a"),
        LayerNameWidget(name: "a"),
        LayerNameWidget(name: "a"),
        LayerNameWidget(name: "a"),
        LayerNameWidget(name: "a"),
        LayerNameWidget(name: "a"),
        LayerNameWidget(name: "a"),
      ],
    );

    // fancy scrolling wrapper around layers
    final scrollableLayers = ScrollConfiguration(
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
        child: SingleChildScrollView(
          controller: tlLayerViewScrollbar,
          child: tlLayerViewLayersColumn,
        ),
      ),
    );

    // LEFT SIDE LAYER VIEW
    final tlLayerView = Positioned(
      left: 0,
      width: layerViewWidth,
      height: widget.timelineHeight - titleBarHeight,
      child: Material(
        elevation: 1,
        color: colorScheme.surfaceBright,
        child: Stack(
          children: [
            Positioned(
              top: layerViewHeaderHeight,
              bottom: layerViewFooterHeight,
              right: 0,
              left: 0,
              child: scrollableLayers,
            ),
            Material(elevation: 3, child: tlLayerViewHeader),
            Positioned(bottom: 0, child: tlLayerViewFooter),
          ],
        ),
      ),
    );
    final tlTimelineView = Positioned(
      right: 0,
      width: windowWidth - layerViewWidth,
      height: widget.timelineHeight - titleBarHeight,
      child: Container(color: colorScheme.secondaryContainer),
    );
    return PanelWidget(
      name: "Timeline",
      child: Stack(children: [tlTimelineView, tlLayerView]),
    );
  }
}
