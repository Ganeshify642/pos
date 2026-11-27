import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gopal_vadapav_pos/data/database/app_database.dart';
import 'package:gopal_vadapav_pos/data/repositories/inventory_repository.dart';
import 'package:gopal_vadapav_pos/data/repositories/order_repository.dart';
import 'package:gopal_vadapav_pos/providers/order_provider.dart';
import 'package:gopal_vadapav_pos/utils/constants.dart';

void main() {
  late AppDatabase database;
  late OrderProvider orderProvider;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    orderProvider = OrderProvider(
      orderRepo: OrderRepository(database),
      inventoryRepo: InventoryRepository(database),
    );
  });

  tearDown(() => database.close());

  Future<int> insertOrder({
    required String number,
    required String source,
    required double total,
    bool isParcel = false,
    String paymentMethod = AppConstants.paymentCash,
    String status = AppConstants.statusCompleted,
  }) {
    return database.into(database.ordersTable).insert(
          OrdersTableCompanion.insert(
            orderNumber: number,
            orderSource: source,
            finalTotal: Value(total),
            grossAmount: Value(total),
            netEarnings: Value(total),
            paymentMethod: Value(paymentMethod),
            orderStatus: Value(status),
            isParcel: Value(isParcel),
            createdAt: Value(DateTime.now()),
          ),
        );
  }

  test('persists parcel flag and separates staff cost from sales', () async {
    final parcelOrderId = await insertOrder(
      number: '001',
      source: AppConstants.sourceCounter,
      total: 120,
      isParcel: true,
    );
    await insertOrder(
      number: '002',
      source: AppConstants.sourceStaff,
      total: 40,
      paymentMethod: AppConstants.paymentStaff,
    );
    await insertOrder(
      number: '003',
      source: AppConstants.sourceStaff,
      total: 99,
      paymentMethod: AppConstants.paymentStaff,
      status: AppConstants.statusCancelled,
    );

    final parcelOrder = await OrderRepository(database).getOrderById(
      parcelOrderId,
    );
    final revenue = await orderProvider.getTodayRevenueSummary();

    expect(parcelOrder?.isParcel, isTrue);
    expect(revenue['total'], 120);
    expect(revenue['staff'], 40);
    expect(revenue['orderCount'], 2);
    expect(revenue['salesOrderCount'], 1);
  });
}
