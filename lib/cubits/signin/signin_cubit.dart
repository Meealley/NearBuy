import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:next_door/repository/auth_repository.dart';
import 'package:next_door/utils/custom_error.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository _authRepository;

  SigninCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SigninState.initial());

  Future<void> signUp({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
  }) async {
    emit(state.copyWith(signInStatus: SignInStatus.loading));

    try {
      final user = await _authRepository.signUp(
        email: email,
        password: password,
        firstname: firstname,
        lastname: lastname,
      );
      log("Firebase sign-up success: $user");
      emit(state.copyWith(signInStatus: SignInStatus.success));
    } on EmailAlreadyInUseException {
      emit(state.copyWith(
          signInStatus: SignInStatus.failure,
          error: CustomError(message: 'Email already in use')));
    } on InvalidEmailException {
      emit(state.copyWith(
          signInStatus: SignInStatus.failure,
          error: CustomError(message: 'Invalid email')));
    } on WeakPasswordException {
      emit(state.copyWith(
          signInStatus: SignInStatus.failure,
          error: CustomError(message: 'Weak password')));
    } on NetworkException {
      emit(state.copyWith(
          signInStatus: SignInStatus.failure,
          error: CustomError(message: 'Network error')));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
          signInStatus: SignInStatus.failure,
          error: CustomError(message: 'Sign-up failed')));
    }
  }
}
