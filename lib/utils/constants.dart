class AppConstants {
  // App Title
  static const String appName = 'Gopal Vadapav';
  static const String currency = '₹';

  // Order Sources
  static const String sourceCounter = 'Counter';
  static const String sourceTakeaway = 'Takeaway';
  static const String sourceDelivery = 'Delivery';
  static const String sourceDineIn = 'Dine-In';
  static const String sourceStaff = 'Staff';
  static const String sourceOffline = 'Counter';

  static const List<String> orderSources = [
    sourceCounter,
    sourceDineIn,
    sourceTakeaway,
    sourceDelivery,
    sourceStaff,
  ];

  // Order Statuses
  static const String statusPending = 'Pending';
  static const String statusPreparing = 'Preparing';
  static const String statusReady = 'Ready';
  static const String statusCompleted = 'Completed';
  static const String statusCancelled = 'Cancelled';

  static const List<String> orderStatuses = [
    statusPending,
    statusPreparing,
    statusReady,
    statusCompleted,
    statusCancelled,
  ];

  // Payment Methods
  static const String paymentCash = 'Cash';
  static const String paymentUPI = 'UPI';
  static const String paymentCard = 'Card';
  static const String paymentOnline = 'Online';
  static const String paymentStaff = 'Staff';

  static const List<String> paymentMethods = [
    paymentCash,
    paymentUPI,
    paymentCard,
    paymentOnline,
  ];

  // Payment Status
  static const String paymentPaid = 'Paid';
  static const String paymentPending = 'Pending';

  // Tax Mode
  static const String taxModeSplit = 'SGST+CGST';
  static const String taxModeIGST = 'IGST';

  // Default values
  static const double defaultCommissionPct = 0.0;
  static const double defaultSgstPct = 2.5;
  static const double defaultCgstPct = 2.5;
  static const double defaultIgstPct = 5.0;
  static const int defaultLowStockThreshold = 5;

  // Invoice & Reports
  static const String invoiceDir = 'invoices';
  static const String reportDir = 'reports';
  static const String orderNumberPrefix = 'GVP';

  // Date Ranges
  static const String rangeToday = 'Today';
  static const String rangeYesterday = 'Yesterday';
  static const String rangeLast7 = 'Last 7 Days';
  static const String rangeLast30 = 'Last 30 Days';
  static const String rangeCustom = 'Custom';

  static const List<String> dateRanges = [
    rangeToday,
    rangeYesterday,
    rangeLast7,
    rangeLast30,
    rangeCustom,
  ];

  // Low stock thresholds
  static const int lowStockQty = 5;
}
