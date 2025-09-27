import 'package:flutter/material.dart';

class LoadingService {
  static LoadingService? _instance;
  OverlayEntry? _overlayEntry;

  LoadingService._();

  static LoadingService get instance {
    _instance ??= LoadingService._();
    return _instance!;
  }

  void show(BuildContext? context) {
    if (_overlayEntry != null) return;

    final ctx =
        context ??
        Navigator.of(GlobalContextKey.globalKey.currentContext!).context;

    _overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator()],
            ),
          ),
        ),
      ),
    );

    Overlay.of(ctx).insert(_overlayEntry!);
  }

  void close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class GlobalContextKey {
  static final GlobalKey<NavigatorState> globalKey =
      GlobalKey<NavigatorState>();
}

final loading = LoadingService.instance;
