import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/file_model.dart';

// the FPS icon
class TLFpsDisplay extends ConsumerWidget {
  final Size size;
  final ColorScheme colorScheme;
  final int fps;
  final TextEditingController fpsEditController;

  const TLFpsDisplay({
    super.key,
    required this.size,
    required this.colorScheme,
    required this.fps,
    required this.fpsEditController,
  });

  final Image fpsImage = const Image(
    image: ResizeImage(
      AssetImage('assets/images/icn_fps.png'),
      width: 20,
      height: 20,
    ),
  );

  Future<void> _displayTextInputDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Framerate'),
          content: TextField(
            controller: fpsEditController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(hintText: "$fps fps"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('UPDATE'),
              onPressed: () {
                // Update the FPS if the user enters a proper int
                var fpsAsInt = int.tryParse(fpsEditController.text);
                if (fpsAsInt != null && fpsAsInt > 0) {
                  //
                  ref.read(fileNotifier.notifier).setFPS(fpsAsInt);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var btn = Container(
      width: size.width * 0.4,
      height: size.height * 0.65,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              fpsImage,
              Text(
                "$fps fps",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: Theme.of(context).textTheme.labelMedium?.fontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return InkWell(
      onTap: () => _displayTextInputDialog(context, ref),
      child: btn,
    );
  }
}
