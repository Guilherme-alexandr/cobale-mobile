// lib/core/widgets/activity_tracker.dart

import 'package:flutter/material.dart';
import '../storage/secure_storage.dart';

class ActivityTracker extends StatelessWidget {
  final Widget child;

  final SecureStorage _storage = SecureStorage();

  ActivityTracker({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _updateActivity(),
      onPanDown: (_) => _updateActivity(),
      child: Listener(onPointerDown: (_) => _updateActivity(), child: child),
    );
  }

  void _updateActivity() {
    _storage.updateLastActivity();
  }
}
