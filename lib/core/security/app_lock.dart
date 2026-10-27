import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme/app_colors.dart';
import '../brand.dart';
import '../strings.dart';

/// Initialised in main() so preferences are available synchronously.
final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

class AppLockState {
  const AppLockState({required this.enabled, required this.locked});
  final bool enabled;
  final bool locked;
}

/// Optional biometric / device-credential lock. Re-locks after the app has been in the
/// background for [_relockAfter].
class AppLockController extends Notifier<AppLockState> {
  static const _key = 'app_lock_enabled';
  static const _relockAfter = Duration(seconds: 30);
  final _auth = LocalAuthentication();
  DateTime? _backgroundedAt;

  SharedPreferences get _prefs => ref.read(sharedPrefsProvider);

  @override
  AppLockState build() {
    final enabled = !kIsWeb && (_prefs.getBool(_key) ?? false);
    return AppLockState(enabled: enabled, locked: enabled);
  }

  Future<bool> setEnabled(bool enabled) async {
    if (enabled) {
      if (!await _auth.isDeviceSupported()) return false;
      if (!await _authenticate(strings.confirmAppLock)) return true;
    }
    await _prefs.setBool(_key, enabled);
    state = AppLockState(enabled: enabled, locked: false);
    return true;
  }

  Future<bool> _authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, persistAcrossBackgrounding: true);
    } catch (_) {
      return false;
    }
  }

  Future<void> unlock() async {
    if (await _authenticate(strings.unlockApp(Brand.name))) state = AppLockState(enabled: state.enabled, locked: false);
  }

  void onLifecycle(AppLifecycleState s) {
    if (!state.enabled) return;
    if (s == AppLifecycleState.paused) _backgroundedAt = DateTime.now();
    if (s == AppLifecycleState.resumed && _backgroundedAt != null) {
      if (DateTime.now().difference(_backgroundedAt!) > _relockAfter) {
        state = const AppLockState(enabled: true, locked: true);
      }
      _backgroundedAt = null;
    }
  }
}

final appLockProvider = NotifierProvider<AppLockController, AppLockState>(AppLockController.new);

/// Wraps the app; covers it with a lock screen while locked.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(appLockProvider).locked) ref.read(appLockProvider.notifier).unlock();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(appLockProvider.notifier).onLifecycle(state);
    if (state == AppLifecycleState.resumed && ref.read(appLockProvider).locked) {
      ref.read(appLockProvider.notifier).unlock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locked = ref.watch(appLockProvider).locked;
    return Stack(
      children: [
        widget.child,
        if (locked)
          Positioned.fill(
            child: Material(
              color: AppColors.primaryFill,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_rounded, color: Colors.white, size: 56),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      '${Brand.name} is locked',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.tonal(
                      onPressed: () => ref.read(appLockProvider.notifier).unlock(),
                      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Text(strings.unlock)),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
