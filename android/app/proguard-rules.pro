# ============================================================================
# ProGuard / R8 Rules for Gopal Vadapav POS
# ============================================================================

# ----------------------------------------------------------------------------
# 1. General & Attributes
# ----------------------------------------------------------------------------
-keepattributes *Annotation*,EnclosingMethod,InnerClasses,Signature,SourceFile,LineNumberTable
-dontobfuscate
-keepclassmembers class * {
    @androidx.annotation.Keep <fields>;
    @androidx.annotation.Keep <methods>;
}

# ----------------------------------------------------------------------------
# 2. Flutter Engine & Plugin Core
# ----------------------------------------------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep native (JNI) methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# ----------------------------------------------------------------------------
# 3. Kotlin & Coroutines
# ----------------------------------------------------------------------------
-dontwarn kotlin.**
-dontwarn kotlinx.**
-keep class kotlin.Metadata { *; }
-keepclassmembers class kotlin.Metadata { *; }
-keep class kotlinx.coroutines.** { *; }

# ----------------------------------------------------------------------------
# 4. SQLite & Drift Database (sqlite3_flutter_libs)
# ----------------------------------------------------------------------------
-keep class org.sqlite.** { *; }
-keep class io.requery.android.database.sqlite.** { *; }
-keep class com.tekartik.sqflite.** { *; }
-keep class sqlite3.** { *; }
-keep class com.simonbinder.sqlite3_flutter_libs.** { *; }
-keepclassmembers class * extends io.requery.android.database.sqlite.SQLiteOpenHelper {
    public <init>(...);
}

# ----------------------------------------------------------------------------
# 5. Bluetooth & Thermal Printer (print_bluetooth_thermal, flutter_blue_plus)
# ----------------------------------------------------------------------------
-keep class com.matteogassend.print_bluetooth_thermal.** { *; }
-keep class com.boskokg.flutter_blue_plus.** { *; }
-keep class com.tablemi.flutter_thermal_printer.** { *; }
-keep class android.bluetooth.** { *; }
-keepclassmembers class android.bluetooth.** { *; }

# ----------------------------------------------------------------------------
# 6. PDF Generation & Printing (printing, pdf)
# ----------------------------------------------------------------------------
-keep class net.nfet.printing.** { *; }
-keep class android.print.** { *; }
-keep class android.printservice.** { *; }

# ----------------------------------------------------------------------------
# 7. File Management & Sharing (share_plus, file_picker, open_file, path_provider)
# ----------------------------------------------------------------------------
-keep class dev.fluttercommunity.plus.share.** { *; }
-keep class com.mr.flutter.plugin.filepicker.** { *; }
-keep class com.crazecoder.openfile.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }

# ----------------------------------------------------------------------------
# 8. Permissions & Image Picker
# ----------------------------------------------------------------------------
-keep class com.baseflow.permissionhandler.** { *; }
-keep class io.flutter.plugins.imagepicker.** { *; }

# ----------------------------------------------------------------------------
# 9. SharedPreferences, Fonts & UI
# ----------------------------------------------------------------------------
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class com.google.fonts.** { *; }

# ----------------------------------------------------------------------------
# 10. Suppress 3rd-Party Warnings
# ----------------------------------------------------------------------------
-dontwarn io.flutter.**
-dontwarn com.google.**
-dontwarn javax.**
-dontwarn org.apache.**
-dontwarn com.matteogassend.print_bluetooth_thermal.**
-dontwarn com.boskokg.flutter_blue_plus.**
-dontwarn dev.fluttercommunity.plus.share.**
-dontwarn com.mr.flutter.plugin.filepicker.**
-dontwarn com.crazecoder.openfile.**
-dontwarn sun.misc.**
