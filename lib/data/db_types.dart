// Central type aliases for Drift-generated data classes.
// Import this file instead of repeating aliases everywhere.
import 'database/app_database.dart';
export 'database/app_database.dart';

typedef Order = OrdersTableData;
typedef OrderItem = OrderItemsTableData;
typedef BusinessSetting = BusinessSettingsTableData;
typedef TaxSetting = TaxSettingsTableData;
typedef DeliveryAppSetting = DeliveryAppSettingsTableData;
typedef Category = CategoriesTableData;
typedef Item = ItemsTableData;
typedef DailyInventory = DailyInventoryTableData;
typedef BackupLog = BackupLogsTableData;
