import 'package:flutter/material.dart';

class InheritedBottomBarControl extends InheritedWidget {
  final void Function(bool) toggleBottomBar;

  const InheritedBottomBarControl({
    required this.toggleBottomBar,
    required super.child,
    super.key,
  });

  static InheritedBottomBarControl? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedBottomBarControl>();
  }

  @override
  bool updateShouldNotify(InheritedBottomBarControl oldWidget) {
    return toggleBottomBar != oldWidget.toggleBottomBar;
  }
}