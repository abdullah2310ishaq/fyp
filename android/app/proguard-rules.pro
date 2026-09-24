# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Gson / reflective models used by plugins
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Hive / adapters (generated TypeAdapters use reflection)
-keep class * extends com.google.protobuf.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Play Core / deferred components (Flutter may reference)
-dontwarn com.google.android.play.core.**

# Local auth / biometrics
-keep class androidx.biometric.** { *; }

# Secure storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Image picker / share
-keep class io.flutter.plugins.imagepicker.** { *; }
-keep class dev.fluttercommunity.plus.share.** { *; }

# Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Crashlytics / NDK symbols
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keep class com.google.firebase.crashlytics.** { *; }
-dontwarn com.google.firebase.crashlytics.**

# Kotlin
-dontwarn kotlin.**
-keep class kotlin.Metadata { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
