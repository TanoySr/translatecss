import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_provider.dart';
import '../settings/app_settings_providers.dart';

/// Wraps the whole app and locks the session after the configured
/// inactivity period (Settings → Auto Lock, Phase 2).
///
/// Any pointer or key activity resets the timer. Locking only
/// happens while a user is signed in; the lock itself is handled by
/// [AuthNotifier.lock], which swaps the UI to the lock screen.
class ActivityTracker extends ConsumerStatefulWidget {
  const ActivityTracker({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends ConsumerState<ActivityTracker> {
  Timer? _timer;
  DateTime _lastActivity = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _check());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _activity() {
    _lastActivity = DateTime.now();
  }

  Future<void> _check() async {
    final auth = ref.read(authProvider);
    if (auth is! AuthSignedIn) return;
    final minutes = await ref.read(autoLockMinutesProvider.future);
    if (minutes <= 0) return;
    if (DateTime.now().difference(_lastActivity).inMinutes >= minutes) {
      ref.read(authProvider.notifier).lock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _activity(),
      onPointerMove: (_) => _activity(),
      onPointerSignal: (_) => _activity(),
      child: Focus(
        onKeyEvent: (_, _) {
          _activity();
          return KeyEventResult.ignored;
        },
        child: widget.child,
      ),
    );
  }
}
