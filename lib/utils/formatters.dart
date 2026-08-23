import 'package:intl/intl.dart';
import 'constants.dart';

class AppFormatters {
  static final NumberFormat _currencyFmt = NumberFormat.currency(
    locale: 'en_IN',
    symbol: AppConstants.currency,
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrencyFmt = NumberFormat.currency(
    locale: 'en_IN',
    symbol: AppConstants.currency,
    decimalDigits: 0,
  );

  static final DateFormat _dateTimeFmt = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _dateFmt = DateFormat('dd MMM yyyy');
  static final DateFormat _timeFmt = DateFormat('hh:mm a');
  static final DateFormat _dbDateFmt = DateFormat('yyyy-MM-dd');

  /// Format as ₹1,234.56
  static String currency(double amount) => _currencyFmt.format(amount);

  /// Format as ₹1,234 (no decimals)
  static String currencyCompact(double amount) =>
      _compactCurrencyFmt.format(amount);

  /// Format as "18 Aug 2026, 06:30 PM"
  static String dateTime(DateTime dt) => _dateTimeFmt.format(dt);

  /// Format as "18 Aug 2026"
  static String date(DateTime dt) => _dateFmt.format(dt);

  /// Format as "06:30 PM"
  static String time(DateTime dt) => _timeFmt.format(dt);

  /// Format for DB storage: "2026-08-18"
  static String dbDate(DateTime dt) => _dbDateFmt.format(dt);

  /// Parse DB date string
  static DateTime parseDbDate(String s) => _dbDateFmt.parse(s);

  /// Format as "18.5%"
  static String percent(double pct) => '${pct.toStringAsFixed(1)}%';

  /// Generate order number: ORD-001
  static String orderNumber(int seq) =>
      '${AppConstants.orderNumberPrefix}-${seq.toString().padLeft(3, '0')}';

  /// Relative time: "2 hours ago", "Just now"
  static String relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return date(dt);
  }

  /// Today's DB key
  static String get todayKey => dbDate(DateTime.now());
}
