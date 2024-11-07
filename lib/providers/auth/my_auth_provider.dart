import 'package:firebase_auth/firebase_auth.dart';
import 'package:petdays/exceptions/custom_exception.dart';
import 'package:petdays/providers/user/user_state.dart';
import 'package:petdays/repositories/auth_repository.dart';
import 'package:state_notifier/state_notifier.dart';

import 'auth_state.dart';

class MyAuthProvider extends StateNotifier<AuthState> with LocatorMixin {
  MyAuthProvider() : super(AuthState.init());

  // LocatorMixin에 정의되어 있는 함수
  @override
  void update(Locator watch) {
    // Firebase Auth의 현재 유저 상태를 감시
    final user = watch<User?>();

    // 현재 유저가 존재하고 이메일이 인증되지 않은 경우
    if (user != null && !user.emailVerified) {
      // 이메일 로그인 유저인 경우에만 리턴
      if (user.providerData
          .any((element) => element.providerId == 'password')) {
        return;
      }
    }

    // 현재 유저가 없고 이미 로그아웃 상태인 경우 리턴
    if (user == null && state.authStatus == AuthStatus.unauthenticated) {
      return;
    }

    // 유저 존재 여부에 따라 인증 상태 업데이트
    // 유저가 있으면 로그인 상태로, 없으면 로그아웃 상태로 변경
    if (user != null) {
      state = state.copyWith(authStatus: AuthStatus.authenticated);
    } else {
      state = state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
  }

  /// 회원 탈퇴
  Future<void> deleteAccount({
    String? password,
  }) async {
    try {
      String uid = read<User>().uid;

      await read<AuthRepository>().deleteAccount(
        uid: uid,
        password: password,
      );
    } on CustomException catch (_) {
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      await read<AuthRepository>().signOut();
    } on CustomException catch (_) {
      rethrow;
    }
  }

  /// 이메일 회원가입
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await read<AuthRepository>().signUpWithEmail(
        email: email,
        password: password,
      );
    } on CustomException catch (_) {
      // MyAuthProvider.signUp을 호출한 곳에다가 다시 rethrow
      rethrow;
    }
  }

  /// 이메일 로그인
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await read<AuthRepository>().signInWithEmail(
        email: email,
        password: password,
      );
    } on CustomException catch (_) {
      // MyAuthProvider.signIn을 호출한 곳에다가 다시 rethrow
      rethrow;
    }
  }

  /// 구글 로그인
  Future<void> signInWithGoogle() async {
    try {
      await read<AuthRepository>().signInWithGoogle();
    } on CustomException catch (_) {
      rethrow;
    }
  }

  /// 애플 로그인
  Future<void> signInWithApple() async {
    try {
      await read<AuthRepository>().signInWithApple();
    } on CustomException catch (_) {
      rethrow;
    }
  }
}
