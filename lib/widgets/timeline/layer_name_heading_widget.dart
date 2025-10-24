import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//TODO: Figureout how to make the variables final and still be changed/ accessed externally
class LayerNameHeading extends ConsumerWidget {
  final double width;
  final double height;
  final ScrollController scrollController;
  const LayerNameHeading({
    super.key,
    required this.width,
    required this.height,
    required this.scrollController,
  });

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final BorderSide tlLayerViewHeaderBorder = BorderSide(
      color: colorScheme.primaryContainer,
      width: 1.0,
    );
    var fgColor = Theme.of(context).colorScheme.onSecondary;

    var leftSideData = Row(
      spacing: 7,
      children: [
        Icon(color: fgColor, size: 13, Icons.remove_red_eye_rounded),
        Icon(color: fgColor, size: 13, Icons.lock_rounded),
      ],
    );
    var rightSideData = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 7,
      children: [
        SizedBox(
          width: 83,
          height: height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  // bar background
                  width: 83,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimaryFixed,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              Align(
                // scrollbar inside
                alignment: Alignment.centerLeft,

                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: RawScrollbar(
                      thickness: 13,
                      radius: const Radius.circular(20),

                      thumbVisibility: true,
                      controller: scrollController,
                      interactive: true,
                      trackVisibility: false,
                      thumbColor: fgColor,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        // this is just test content for now
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 400,
                          ), // force overflow
                          child: Container(
                            height: 10,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Icon(color: fgColor, size: 18, Icons.delete),
      ],
    );
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0)),
        border: Border(
          bottom: tlLayerViewHeaderBorder,
          top: tlLayerViewHeaderBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
            child: leftSideData,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: rightSideData,
            ),
          ),
        ],
      ),
    );
  }
}
