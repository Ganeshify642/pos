import 'dart:io';
import 'package:flutter/material.dart';

class ItemImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget placeholder;

  const ItemImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final path = imageUrl?.trim();
    if (path == null || path.isEmpty) {
      return placeholder;
    }

    Widget content;
    if (path.startsWith('assets/')) {
      content = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => placeholder,
      );
    } else {
      final file = File(path);
      if (file.existsSync()) {
        content = Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => placeholder,
        );
      } else {
        content = placeholder;
      }
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: content,
      );
    }

    return content;
  }
}
