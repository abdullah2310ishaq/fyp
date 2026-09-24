import 'dart:async';

import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  const TypewriterText({
    super.key,
    required this.text,
    required this.style,
    required this.reduceMotion,
  });

  final String text;
  final TextStyle? style;
  final bool reduceMotion;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  Timer? timer;
  int visible = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.reduceMotion != widget.reduceMotion) {
      _start();
    }
  }

  void _start() {
    timer?.cancel();
    visible = widget.reduceMotion ? widget.text.length : 0;
    if (visible == widget.text.length) return;
    timer = Timer.periodic(const Duration(milliseconds: 12), (timer) {
      if (!mounted) return;
      setState(() => visible = (visible + 2).clamp(0, widget.text.length));
      if (visible >= widget.text.length) timer.cancel();
    });
  }

  void _complete() {
    timer?.cancel();
    setState(() => visible = widget.text.length);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.text,
    excludeSemantics: true,
    child: GestureDetector(
      onTap: _complete,
      child: Text(widget.text.substring(0, visible), style: widget.style),
    ),
  );
}
