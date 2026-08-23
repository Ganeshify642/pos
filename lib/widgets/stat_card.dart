import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final Gradient? gradient;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? theme.cardTheme.color : null,
          borderRadius: BorderRadius.circular(14),
          border: gradient == null
              ? Border.all(
                  color: color.withOpacity(0.2),
                  width: 1,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: gradient != null
                        ? Colors.white.withOpacity(0.6)
                        : theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: gradient != null
                    ? Colors.white
                    : theme.colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: gradient != null
                    ? Colors.white.withOpacity(0.8)
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 11,
                  color: gradient != null
                      ? Colors.white.withOpacity(0.7)
                      : AppColors.accent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
