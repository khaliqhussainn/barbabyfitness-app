import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevicePermissions {
  const DevicePermissions({
    this.healthEnabled = false,
    this.backgroundCoachingEnabled = false,
  });

  final bool healthEnabled;
  final bool backgroundCoachingEnabled;

  DevicePermissions copyWith({bool? healthEnabled, bool? backgroundCoachingEnabled}) {
    return DevicePermissions(
      healthEnabled: healthEnabled ?? this.healthEnabled,
      backgroundCoachingEnabled: backgroundCoachingEnabled ?? this.backgroundCoachingEnabled,
    );
  }
}

class DevicePermissionsNotifier extends StateNotifier<DevicePermissions> {
  DevicePermissionsNotifier() : super(const DevicePermissions());

  void toggleHealth() =>
      state = state.copyWith(healthEnabled: !state.healthEnabled);

  void toggleBackgroundCoaching() => state =
      state.copyWith(backgroundCoachingEnabled: !state.backgroundCoachingEnabled);
}

final devicePermissionsProvider =
    StateNotifierProvider<DevicePermissionsNotifier, DevicePermissions>(
  (ref) => DevicePermissionsNotifier(),
);
