import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';

final clockProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
});

// Re-export for convenience in clock-related screens
final clockSettingsProvider = clockFormatProvider;
