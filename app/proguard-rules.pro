# Keep JNI entry points in BinaryDictionary — native method names must match
# the C++ symbol names generated from the fully-qualified class name.
-keepclasseswithmembernames class org.pocketworkstation.pckeyboard.BinaryDictionary {
    native <methods>;
}

# Keep custom View subclasses instantiated by XML inflation (LayoutInflater uses
# the class name string from XML, so R8 cannot trace these call sites).
-keep class org.pocketworkstation.pckeyboard.LatinKeyboardView { <init>(...); }
-keep class org.pocketworkstation.pckeyboard.LatinKeyboardBaseView { <init>(...); }
-keep class org.pocketworkstation.pckeyboard.CandidateView { <init>(...); }

# Keep custom Preference subclasses referenced by class name in preference XML.
-keep class org.pocketworkstation.pckeyboard.SeekBarPreference { <init>(...); }
-keep class org.pocketworkstation.pckeyboard.VibratePreference { <init>(...); }

# Retain line numbers in stack traces for crash reports.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
