// lib/core/widgets/base_page.dart

import 'package:flutter/material.dart';
import '../../core/storage/secure_storage.dart';

class BasePage extends StatefulWidget {
  final String title;
  final Widget child;
  final bool showBackButton;
  final List<Widget>? actions;

  const BasePage({
    super.key,
    required this.title,
    required this.child,
    this.showBackButton = false,
    this.actions,
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final SecureStorage _storage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _updateActivity();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _updateActivity,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          leading: widget.showBackButton
              ? BackButton(
                  onPressed: () {
                    _updateActivity();
                    Navigator.pop(context);
                  },
                )
              : null,
          actions: widget.actions,
        ),
        body: widget.child,
      ),
    );
  }

  void _updateActivity() {
    _storage.updateLastActivity();
  }
}
