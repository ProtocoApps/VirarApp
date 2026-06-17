# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Supabase / Realtime
-keep class io.github.jan.supabase.** { *; }
-dontwarn io.github.jan.supabase.**

# Google Maps
-keep class com.google.android.gms.maps.** { *; }
-keep class com.google.maps.android.** { *; }

# Geolocator
-keep class com.baseflow.geolocator.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keepclassmembers class kotlin.Metadata { *; }
-dontwarn kotlin.**

# OkHttp (usado pelo Supabase/Dio)
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Hive
-keep class com.hivedb.** { *; }
-keep @com.google.gson.annotations.SerializedName class * { *; }

# Manter atributos de anotação necessários para reflexão
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
