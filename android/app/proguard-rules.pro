# Add keep rules to fix R8 minification errors for missing classes

# Keep annotations from errorprone
-keep class com.google.errorprone.annotations.** { *; }

# Keep javax.annotation classes
-keep class javax.annotation.** { *; }

# Keep all classes referenced by Tink library
-keep class com.google.crypto.tink.** { *; }
-keep class com.google.crypto.tink.proto.** { *; }

# Keep all classes with @Keep annotation
-keep @androidx.annotation.Keep class * { *; }
