import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../utils/app_colors.dart';

class StockStatusChip extends StatelessWidget {
  final InventoryStatus status;

  const StockStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = _getStyle();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${status.remainingQty}',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData, String) _getStyle() {
    if (status.madeQty == 0) {
      return (AppColors.textMuted, Icons.remove_circle_outline, 'Not Set');
    }
    if (status.isOutOfStock) {
      return (AppColors.outOfStock, Icons.cancel_outlined, 'Out of Stock');
    }
    if (status.isLowStock) {
      return (AppColors.lowStock, Icons.warning_amber_outlined, 'Low');
    }
    return (AppColors.inStock, Icons.check_circle_outline, 'Avail');
  }
}

/// Inline stock indicator for item selection screen
class ItemStockIndicator extends StatelessWidget {
  final int remainingQty;
  final int lowStockThreshold;

  const ItemStockIndicator({
    super.key,
    required this.remainingQty,
    required this.lowStockThreshold,
  });

  @override
  Widget build(BuildContext context) {
    if (remainingQty == 999) {
      return const SizedBox.shrink(); // Unlimited / not set
    }
    if (remainingQty == 0) {
      return const Text(
        'OUT OF STOCK',
        style: TextStyle(
          color: AppColors.outOfStock,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      );
    }
    final isLow = remainingQty <= lowStockThreshold;
    return Text(
      '$remainingQty left',
      style: TextStyle(
        color: isLow ? AppColors.lowStock : AppColors.inStock,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
