import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import '../data/db_types.dart';
import '../data/repositories/order_repository.dart';
import '../data/repositories/inventory_repository.dart';
import '../models/app_models.dart';
import '../services/calculation_service.dart';
import '../services/invoice_service.dart';
import '../utils/constants.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _orderRepo;
  final InventoryRepository _inventoryRepo;

  // ── Order List State ─────────────────────────────────────────────
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  // ── Filters ──────────────────────────────────────────────────────
  String? _filterSource;
  String? _filterStatus;
  DateTime? _filterDate;
  DateTime? _filterDateStart;
  DateTime? _filterDateEnd;

  // ── Create Order Wizard State ─────────────────────────────────────
  String _selectedSource = AppConstants.sourceCounter;
  String? _tableNumber;
  String? _customerPhone;
  String? _deliveryAddress;
  double _deliveryFee = 0;
  List<CartItem> _cartItems = [];
  double _discountAmount = 0;
  String _paymentMethod = AppConstants.paymentCash;

  OrderProvider({
    required OrderRepository orderRepo,
    required InventoryRepository inventoryRepo,
  })  : _orderRepo = orderRepo,
        _inventoryRepo = inventoryRepo;

  // ── Getters ──────────────────────────────────────────────────────
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String get selectedSource => _selectedSource;
  String? get tableNumber => _tableNumber;
  String? get customerPhone => _customerPhone;
  String? get deliveryAddress => _deliveryAddress;
  double get deliveryFee => _deliveryFee;
  List<CartItem> get cartItems => _cartItems;
  double get discountAmount => _discountAmount;
  String get paymentMethod => _paymentMethod;

  double get cartSubtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.lineTotal);

  int get cartItemCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // ── Filtered orders ──────────────────────────────────────────────
  List<Order> get filteredOrders {
    return _orders.where((Order o) {
      if (_filterSource != null && o.orderSource != _filterSource) {
        return false;
      }
      if (_filterStatus != null && o.orderStatus != _filterStatus) {
        return false;
      }
      if (_filterDate != null) {
        final d = o.createdAt;
        final f = _filterDate!;
        if (d.year != f.year || d.month != f.month || d.day != f.day) {
          return false;
        }
      }
      if (_filterDateStart != null && o.createdAt.isBefore(_filterDateStart!)) {
        return false;
      }
      if (_filterDateEnd != null &&
          o.createdAt.isAfter(_filterDateEnd!.add(const Duration(days: 1)))) {
        return false;
      }
      return true;
    }).toList();
  }

  // ── Load Orders ──────────────────────────────────────────────────
  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      _orders = await _orderRepo.getAllOrders();
      _error = null;
    } catch (e) {
      _error = 'Failed to load orders: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Order>> getTodaysOrders() async {
    return await _orderRepo.getTodaysOrders();
  }

  Future<OrderSummary?> getOrderSummary(int orderId) async {
    return await _orderRepo.getOrderSummary(orderId);
  }

  // ── Filters ──────────────────────────────────────────────────────
  void setFilterSource(String? source) {
    _filterSource = source;
    notifyListeners();
  }

  void setFilterStatus(String? status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setFilterDate(DateTime? date) {
    _filterDate = date;
    _filterDateStart = null;
    _filterDateEnd = null;
    notifyListeners();
  }

  void setFilterDateRange(DateTime? start, DateTime? end) {
    _filterDateStart = start;
    _filterDateEnd = end;
    _filterDate = null;
    notifyListeners();
  }

  void clearFilters() {
    _filterSource = null;
    _filterStatus = null;
    _filterDate = null;
    _filterDateStart = null;
    _filterDateEnd = null;
    notifyListeners();
  }

  // ── Create Order Wizard ──────────────────────────────────────────
  void setOrderSource(String source) {
    _selectedSource = source;
    if (source != AppConstants.sourceDineIn) {
      _tableNumber = null;
    }
    if (source != AppConstants.sourceDelivery) {
      _deliveryFee = 0;
    }
    if (source == AppConstants.sourceStaff) {
      _paymentMethod = AppConstants.paymentStaff;
    } else if (_paymentMethod == AppConstants.paymentStaff) {
      _paymentMethod = AppConstants.paymentCash;
    }
    notifyListeners();
  }

  void setTableNumber(String? table) {
    _tableNumber = table;
    notifyListeners();
  }

  void setCustomerPhone(String? phone) {
    _customerPhone = phone;
    notifyListeners();
  }

  void setDeliveryAddress(String? address) {
    _deliveryAddress = address;
    notifyListeners();
  }

  void setDeliveryFee(double fee) {
    _deliveryFee = fee;
    notifyListeners();
  }

  void setDiscount(double amount) {
    _discountAmount = amount;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  // ── Cart Management ──────────────────────────────────────────────
  void addItemToCart(CartItem item) {
    final existing = _cartItems.indexWhere((c) => c.itemId == item.itemId);
    if (existing >= 0) {
      _cartItems[existing] = _cartItems[existing]
          .copyWith(quantity: _cartItems[existing].quantity + 1);
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void removeItemFromCart(int itemId) {
    final existing = _cartItems.indexWhere((c) => c.itemId == itemId);
    if (existing >= 0) {
      if (_cartItems[existing].quantity > 1) {
        _cartItems[existing] = _cartItems[existing]
            .copyWith(quantity: _cartItems[existing].quantity - 1);
      } else {
        _cartItems.removeAt(existing);
      }
    }
    notifyListeners();
  }

  void setItemQuantity(int itemId, int quantity, {required CartItem itemTemplate}) {
    if (quantity <= 0) {
      _cartItems.removeWhere((c) => c.itemId == itemId);
    } else {
      final existing = _cartItems.indexWhere((c) => c.itemId == itemId);
      if (existing >= 0) {
        _cartItems[existing] = _cartItems[existing].copyWith(quantity: quantity);
      } else {
        _cartItems.add(itemTemplate.copyWith(quantity: quantity));
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void setItemInstructions(int itemId, String instructions) {
    final idx = _cartItems.indexWhere((c) => c.itemId == itemId);
    if (idx >= 0) {
      _cartItems[idx] =
          _cartItems[idx].copyWith(specialInstructions: instructions);
      notifyListeners();
    }
  }

  int getCartQty(int itemId) {
    try {
      return _cartItems.firstWhere((c) => c.itemId == itemId).quantity;
    } catch (_) {
      return 0;
    }
  }

  // ── Reset Wizard ─────────────────────────────────────────────────
  void resetWizard() {
    _selectedSource = AppConstants.sourceCounter;
    _tableNumber = null;
    _customerPhone = null;
    _deliveryAddress = null;
    _deliveryFee = 0;
    _cartItems = [];
    _discountAmount = 0;
    _paymentMethod = AppConstants.paymentCash;
    notifyListeners();
  }

  // ── Submit Order ─────────────────────────────────────────────────
  Future<OrderSummary?> submitOrder({
    required TaxSetting taxSettings,
    required BusinessSetting businessSettings,
  }) async {
    if (_cartItems.isEmpty) return null;

    _isLoading = true;
    notifyListeners();

    try {
      final orderNumber = await _orderRepo.generateUniqueOrderNumber();

      final cartLineItems = _cartItems
          .map((c) => (qty: c.quantity, price: c.price))
          .toList();

      final calc = CalculationService.calculateOfflineOrderTotal(
        items: cartLineItems,
        taxSettings: taxSettings,
        discountAmount: _discountAmount,
        deliveryFee: _deliveryFee,
      );

      final subtotal = calc.subtotal;
      final taxAmount = calc.taxAmount;
      final sgst = calc.sgst;
      final cgst = calc.cgst;
      final finalTotal = calc.finalTotal;

      final orderCompanion = OrdersTableCompanion.insert(
        orderNumber: orderNumber,
        orderSource: _selectedSource,
        deliveryAppName: Value(_tableNumber != null ? 'Table $_tableNumber' : null),
        customerPhone: Value(_customerPhone),
        deliveryAddress: Value(_deliveryAddress),
        subtotal: Value(subtotal),
        taxAmount: Value(taxAmount),
        sgstAmount: Value(sgst),
        cgstAmount: Value(cgst),
        discountAmount: Value(_discountAmount),
        deliveryFee: Value(_deliveryFee),
        platformFee: const Value(0.0),
        grossAmount: Value(finalTotal),
        netEarnings: Value(finalTotal),
        finalTotal: Value(finalTotal),
        paymentMethod: Value(_paymentMethod),
        paymentStatus: const Value(AppConstants.paymentPaid),
        orderStatus: const Value(AppConstants.statusCompleted),
        notes: const Value(''),
      );

      final itemCompanions = _cartItems.map((c) {
        return OrderItemsTableCompanion.insert(
          orderId: 0, // will be overwritten in repo
          itemId: c.itemId,
          itemName: c.itemName,
          quantity: c.quantity,
          priceAtOrder: c.price,
          specialInstructions: Value(c.specialInstructions),
        );
      }).toList();

      final orderId = await _orderRepo.createOrder(
        order: orderCompanion,
        items: itemCompanions,
      );

      // Deduct inventory
      for (final item in _cartItems) {
        await _inventoryRepo.deductSoldQty(item.itemId, item.quantity);
      }

      // Get the created order
      final order = await _orderRepo.getOrderById(orderId);
      final orderItems = await _orderRepo.getOrderItems(orderId);

      if (order == null) throw Exception('Failed to retrieve created order');

      // Generate invoice PDF
      final invoicePath = await InvoiceService.generateInvoice(
        order: order,
        items: orderItems,
        businessSettings: businessSettings,
        taxSettings: taxSettings,
      );

      await _orderRepo.updateInvoicePath(orderId, invoicePath);

      // Refresh order list
      _orders = await _orderRepo.getAllOrders();
      _error = null;

      resetWizard();

      return OrderSummary(
        order: order.copyWith(invoicePath: Value(invoicePath)),
        items: orderItems,
      );
    } catch (e) {
      _error = 'Failed to create order: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Update Status ────────────────────────────────────────────────
  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      await _orderRepo.updateOrderStatus(orderId, status);
      final idx = _orders.indexWhere((Order o) => o.id == orderId);
      if (idx >= 0) {
        _orders = List.from(_orders);
        notifyListeners();
      }
      await loadOrders();
    } catch (e) {
      _error = 'Failed to update status: $e';
      notifyListeners();
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _orderRepo.cancelOrder(orderId);
      await loadOrders();
      _error = null;
      return true;
    } catch (e) {
      _error = 'Failed to cancel order: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Revenue Stats (today) ─────────────────────────────────────────
  Future<Map<String, double>> getTodayRevenueSummary() async {
    final orders = await _orderRepo.getTodaysOrders();
    double total = 0, dineIn = 0, takeaway = 0, delivery = 0, staff = 0;
    int completedCount = 0;
    for (final o in orders) {
      if (o.orderStatus == AppConstants.statusCancelled) continue;
      completedCount++;

      final isStaff = o.orderSource == AppConstants.sourceStaff ||
          o.paymentMethod == AppConstants.paymentStaff;

      if (!isStaff) {
        total += o.finalTotal;
        if (o.orderSource == AppConstants.sourceDineIn) {
          dineIn += o.finalTotal;
        } else if (o.orderSource == AppConstants.sourceTakeaway) {
          takeaway += o.finalTotal;
        } else if (o.orderSource == AppConstants.sourceDelivery) {
          delivery += o.finalTotal;
        }
      }
    }
    return {
      'total': total,
      'net': total,
      'dineIn': dineIn,
      'takeaway': takeaway,
      'delivery': delivery,
      'staff': staff,
      'orderCount': completedCount.toDouble(),
    };
  }
}
