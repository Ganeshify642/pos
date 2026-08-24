import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/database/app_database.dart';
import 'data/repositories/inventory_repository.dart';
import 'data/repositories/menu_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'providers/inventory_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/order_provider.dart';
import 'providers/printer_provider.dart';
import 'providers/report_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DeliveryBillApp());
}

class DeliveryBillApp extends StatelessWidget {
  const DeliveryBillApp({super.key});

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();

    return MultiProvider(
      providers: [
        // Repositories
        Provider<AppDatabase>(create: (_) => db, dispose: (_, d) => d.close()),
        ProxyProvider<AppDatabase, OrderRepository>(
          update: (_, d, __) => OrderRepository(d),
        ),
        ProxyProvider<AppDatabase, InventoryRepository>(
          update: (_, d, __) => InventoryRepository(d),
        ),
        ProxyProvider<AppDatabase, MenuRepository>(
          update: (_, d, __) => MenuRepository(d),
        ),
        ProxyProvider<AppDatabase, SettingsRepository>(
          update: (_, d, __) => SettingsRepository(d),
        ),

        // Providers (ViewModels)
        ChangeNotifierProxyProvider<SettingsRepository, SettingsProvider>(
          create: (ctx) => SettingsProvider(ctx.read<SettingsRepository>()),
          update: (_, repo, prev) => prev ?? SettingsProvider(repo),
        ),
        ChangeNotifierProxyProvider<MenuRepository, MenuProvider>(
          create: (ctx) => MenuProvider(ctx.read<MenuRepository>()),
          update: (_, repo, prev) => prev ?? MenuProvider(repo),
        ),
        ChangeNotifierProxyProvider2<OrderRepository, InventoryRepository,
            OrderProvider>(
          create: (ctx) => OrderProvider(
            orderRepo: ctx.read<OrderRepository>(),
            inventoryRepo: ctx.read<InventoryRepository>(),
          ),
          update: (_, oRepo, iRepo, prev) =>
              prev ??
              OrderProvider(orderRepo: oRepo, inventoryRepo: iRepo),
        ),
        ChangeNotifierProxyProvider2<InventoryRepository, MenuRepository,
            InventoryProvider>(
          create: (ctx) => InventoryProvider(
            inventoryRepo: ctx.read<InventoryRepository>(),
            menuRepo: ctx.read<MenuRepository>(),
          ),
          update: (_, iRepo, mRepo, prev) =>
              prev ??
              InventoryProvider(inventoryRepo: iRepo, menuRepo: mRepo),
        ),
        ChangeNotifierProxyProvider<OrderRepository, ReportProvider>(
          create: (ctx) =>
              ReportProvider(orderRepo: ctx.read<OrderRepository>()),
          update: (_, repo, prev) => prev ?? ReportProvider(orderRepo: repo),
        ),
        ChangeNotifierProvider<PrinterProvider>(
          create: (_) => PrinterProvider(),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'DeliveryBill',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
