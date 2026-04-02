# Keep JNI entry points in BinaryDictionary — native method names must match
# the C++ symbol names generated from the fully-qualified class name.
-keepclasseswithmembernames class de.codevoid.corekeyboard.BinaryDictionary {
    native <methods>;
}

# Keep custom View subclasses instantiated by XML inflation (LayoutInflater uses
# the class name string from XML, so R8 cannot trace these call sites).
-keep class de.codevoid.corekeyboard.LatinKeyboardView { <init>(...); }
-keep class de.codevoid.corekeyboard.LatinKeyboardBaseView { <init>(...); }
-keep class de.codevoid.corekeyboard.CandidateView { <init>(...); }

# Keep custom Preference subclasses referenced by class name in preference XML.
-keep class de.codevoid.corekeyboard.SeekBarPreference { <init>(...); }
-keep class de.codevoid.corekeyboard.VibratePreference { <init>(...); }

# Retain line numbers in stack traces for crash reports.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
