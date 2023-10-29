// ignore_for_file: library_private_types_in_public_api

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/domain/user_model.dart';
import 'package:test/infrastructure/apis/user_service.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const _Initial()) {
    on(<_GetUsers>(event, emit) => getUsers(event, emit));
    add(const _GetUsers());
  }

  final UserApis _userApis = UserApis();

  Future<void> getUsers(_GetUsers event, Emitter<UserState> state) async {
    emit(const UserState.loading());
    final res = await _userApis.getUsers();
    res.fold((err) => emit(UserState.error(err)),
        (data) => emit(UserState.success(data)));
  }
}
