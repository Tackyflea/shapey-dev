import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:keymap/keymap.dart';
import 'package:shapey/app_state/app_commands.dart';
import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/main_stage.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';
import 'package:shapey/widgets/timeline/layer_name_heading_widget.dart';
import 'package:shapey/widgets/timeline/layer_name_widget.dart';
import 'package:shapey/widgets/timeline/timeline_key_details_widget.dart';
import 'package:shapey/widgets/timeline/tl_left_side_parts/tl_fps_display.dart';

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
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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
    final AppCommandInvoker appCommandHistory = ref.watch(
      appNotifier.select((s) => s.appCommandHistory),
    );

    FileModel fileData = ref.watch(fileNotifier);
    final FileNotifier fileNotif = ref.read(fileNotifier.notifier);

    final double tlDuration = fileData.timelineDuration; //second
    final int tlFPS = fileData.fps; // frames per seconsd
    final List<FileLayer> layers = fileData.layers;
    final double layerHeight = 25; // height of a layer cell
    final Image fpsImage = const Image(
      image: ResizeImage(
        AssetImage('assets/images/icn_fps.png'),
        width: 20,
        height: 20,
      ),
    );
    final totalFrames = (tlDuration * tlFPS).toInt();
    final layerKeysList = ListView.builder(
      scrollDirection: Axis.vertical,
      prototypeItem: SizedBox(height: layerHeight),
      itemCount: layers.length, // for performance
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
      itemCount: layers.length,

      prototypeItem: SizedBox(height: layerHeight),
      scrollDirection: Axis.vertical,
      controller: tlNameViewScrollbar,
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: true,
      itemBuilder: (context, layerIndex) => LayerName(
        key: ValueKey("Row-LayerName-$layerIndex"),
        name: layers[layerIndex].LayerName,
        locked: layers[layerIndex].locked,
        hidden: layers[layerIndex].hidden,
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
              fps: fileData.fps,
              size: Size(widget.layerViewWidth, layerViewFooterHeight),
              colorScheme: widget.colorScheme,
              fpsEditController: fpsConfirmTextEditController,
            ),
            IconButton(
              onPressed: () {
                print("pressed the add button");
                appCommandHistory.executeCommand(AddLayerCommand(fileNotif));
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
    return KeyboardWidget(
      // Undo / Redo
      bindings: [
        KeyAction(LogicalKeyboardKey.keyZ, 'Undo', () {
          print('stage undo');
          appCommandHistory.undo();
        }, isControlPressed: true),
      ],
      child: leftAndRightSideOfTimeline,
    );
  }
}
