import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SourceBadge extends StatelessWidget {
  final String source;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const SourceBadge({
    super.key,
    required this.source,
    this.fontSize = 11,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final (color, label) = _getStyle();
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) _getStyle() {
    return switch (source) {
      AppConstants.sourceDineIn => (const Color(0xFF4F46E5), 'Dine-In'), // Deep Indigo
      AppConstants.sourceTakeaway => (const Color(0xFFD97706), 'Takeaway'), // Amber
      AppConstants.sourceDelivery => (const Color(0xFF059669), 'Delivery'), // Emerald
      _ => (const Color(0xFF2563EB), source),
    };
  }
}
