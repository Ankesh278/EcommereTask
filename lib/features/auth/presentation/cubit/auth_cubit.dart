import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../core/utils/result.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit({required this.loginUseCase}) : super(const AuthInitial());

  String? validateEmail(String? email) => InputValidators.validateEmail(email);

  String? validatePassword(String? password) =>
      InputValidators.validatePassword(password);

  Future<void> login({required String email, required String password}) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      emit(AuthFailureState(emailError));
      return;
    }

    final passwordError = validatePassword(password);
    if (passwordError != null) {
      emit(AuthFailureState(passwordError));
      return;
    }

    emit(const AuthLoading());

    final result = await loginUseCase(email: email, password: password);

    switch (result) {
      case Success(:final data):
        emit(AuthSuccess(data));
      case Error(:final failure):
        emit(AuthFailureState(failure.message));
    }
  }

  void reset() {
    emit(const AuthInitial());
  }
}
