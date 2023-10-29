part of 'user_bloc.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.error(String err) = _Error;
  const factory UserState.success(List<UserModel> data) = _Success;
}
