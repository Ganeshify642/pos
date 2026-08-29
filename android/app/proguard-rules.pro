# Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# SQLite and Drift
-keep class org.sqlite.** { *; }
-keep class io.requery.android.database.sqlite.** { *; }
-keep class com.tekartik.sqflite.** { *; }
-keep class sqlite3.** { *; }

# Bluetooth and Thermal Printer
-keep class com.boskokg.flutter_blue_plus.** { *; }
-keep class com.tablemi.flutter_thermal_printer.** { *; }
-keep class com.matteogassend.print_bluetooth_thermal.** { *; }
-keep class android.bluetooth.** { *; }

# Printing & PDF
-keep class net.nfet.printing.** { *; }

# File picker, share, open file, path provider
-keep class com.mr.flutter.plugin.filepicker.** { *; }
-keep class dev.fluttercommunity.plus.share.** { *; }
-keep class com.crazecoder.openfile.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }

# Image Picker & Permissions
-keep class io.flutter.plugins.imagepicker.** { *; }
-keep class com.baseflow.permissionhandler.** { *; }

# Shared Preferences & Google Fonts
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Suppress warnings from 3rd-party libs
-dontwarn io.flutter.**
-dontwarn com.google.**
-dontwarn javax.**
-dontwarn org.apache.**
