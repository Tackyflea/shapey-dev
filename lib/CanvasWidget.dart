import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_state/app_notifier.dart';

class CanvasWidget extends ConsumerStatefulWidget {
  const CanvasWidget({super.key});

  @override
  ConsumerState<CanvasWidget> createState() => _CanvasState();
}

class _CanvasState extends ConsumerState<CanvasWidget> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
      ref.read(appNotifier.notifier).updateAge(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    _counter = ref.read(appNotifier.notifier).age;
    // ref.read(scoreChangeNotifProvider.notifier).set(points);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Counter: $_counter', style: TextStyle(fontSize: 24)),
        ElevatedButton(onPressed: _incrementCounter, child: Text('Increment')),
      ],
    );
  }
}
