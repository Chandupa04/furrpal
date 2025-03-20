import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furrpal/features/auth/models/user_entity.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_state.dart';
import 'package:furrpal/features/auth/repositories/auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  UserEntity? currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  //check user already authenticated
  void checkUserAuthentication() async {
    final UserEntity? user = await authRepo.getCurrentUser();
    if (user != null) {
      currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  //get the current user
  UserEntity? get curruntUser => currentUser;

  //login with email and password
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginwithEmailPassword(email, password);

      if (user != null) {
        currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  //register with email and password
  Future<void> register(
      String fName,
      String lName,
      String email,
      String address,
      String phone,
      String password,
      String confirmPassword) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerwithEmailPassword(
          fName, lName, email, address, phone, password, confirmPassword);

      if (user != null) {
        currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  //logout
  Future<void> logout() async {
    await authRepo.logout();
    emit(UnAuthenticated());
  }
}
