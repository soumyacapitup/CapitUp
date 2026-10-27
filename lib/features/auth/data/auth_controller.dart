import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import 'auth_repository.dart';

enum AuthStatus { unknown, signedOut, signedIn }

class AuthState {
  const AuthState(this.status, [this.user]);
  final AuthStatus status;
  final AppUser? user;

  bool get needsProfile => status == AuthStatus.signedIn && (user?.fullName ?? '').trim().isEmpty;
}

class AuthController extends Notifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    ref.read(sessionEventsProvider).onExpired = () => state = const AuthState(AuthStatus.signedOut);
    _restore();
    return const AuthState(AuthStatus.unknown);
  }

  Future<void> _restore() async {
    try {
      final user = await _repo.currentUser();
      state = user == null ? const AuthState(AuthStatus.signedOut) : AuthState(AuthStatus.signedIn, user);
    } on ApiException {
      // Stored tokens are kept, so the next launch with connectivity restores the session.
      // TODO(Week 9): offline-friendly launch screen instead of falling back to login.
      state = const AuthState(AuthStatus.signedOut);
    }
  }

  Future<OtpChallenge> requestOtp(String identifier) => _repo.requestOtp(identifier);

  Future<void> verifyOtp(String identifier, String code, {required bool consent}) async {
    final user = await _repo.verifyOtp(identifier, code, consent: consent);
    state = AuthState(AuthStatus.signedIn, user);
  }

  Future<void> updateProfile(Map<String, dynamic> changes) async {
    final user = await _repo.updateProfile(changes);
    state = AuthState(AuthStatus.signedIn, user);
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(AuthStatus.signedOut);
  }

  Future<void> deleteAccount() async {
    await _repo.deleteAccount();
    state = const AuthState(AuthStatus.signedOut);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);
