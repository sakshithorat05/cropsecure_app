import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState.initial;

  Future<void> login(String phone, String otp) async {
    state = AuthState.loading;
    await Future.delayed(const Duration(seconds: 2));
    
    if (otp == '123456') { 
      state = AuthState.authenticated;
    } else {
      state = AuthState.error;
    }
  }

  void logout() {
    state = AuthState.unauthenticated;
  }

  void checkAuthStatus() {
    state = AuthState.unauthenticated;
  }
}
