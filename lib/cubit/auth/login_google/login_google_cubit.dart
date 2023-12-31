import 'package:bloc/bloc.dart';
import 'package:flutter_huixin_app/data/models/auth/requests/login_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_huixin_app/data/datasources/auth_datasource.dart';
import 'package:flutter_huixin_app/data/datasources/firebase_datasource.dart';

import '../../../data/models/auth/auth_response_model.dart';

part 'login_google_cubit.freezed.dart';
part 'login_google_state.dart';

class LoginGoogleCubit extends Cubit<LoginGoogleState> {
  AuthDataSource authDataSource;
  FirebaseDataSource firebaseDataSource;
  LoginGoogleCubit(
    this.authDataSource,
    this.firebaseDataSource,
  ) : super(const LoginGoogleState.initial());

  Future<void> loginWithGoogle() async {
    emit(const LoginGoogleState.loading());
    final result = await firebaseDataSource.loginWithGoogle();
    result.fold(
      (l) => emit(LoginGoogleState.error(l)),
      (uid) async {
        final request = LoginRequestModel(
          username: uid,
          password: '123456',
          id_google: uid,
        );
        final authResponse = await authDataSource.login(request);
        authResponse.fold(
          (l) => emit(LoginGoogleState.error(l)),
          (r) => emit(LoginGoogleState.loaded(r)),
        );
      },
    );
  }
}
