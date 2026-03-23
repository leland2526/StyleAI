import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/user/user_profile.dart';
import '../../../data/repositories/user_repository.dart';

// States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserProfile user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(UserInitial());

  Future<void> loadUser() async {
    emit(UserLoading());
    try {
      final user = await _repository.getCurrentUser();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUser(UserProfile user) async {
    try {
      await _repository.updateUser(user);
      await loadUser();
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateBodyData({
    int? heightCm,
    int? weightKg,
    String? bodyShape,
  }) async {
    try {
      final user = await _repository.getCurrentUser();
      await _repository.updateBodyData(
        user.id,
        heightCm: heightCm,
        weightKg: weightKg,
        bodyShape: bodyShape,
      );
      await loadUser();
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateStyleTestResult(String result) async {
    try {
      final user = await _repository.getCurrentUser();
      await _repository.updateStyleTestResult(user.id, result);
      await loadUser();
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updatePreferences({
    List<String>? stylePreferences,
    List<String>? colorPreferences,
    List<String>? avoidColors,
  }) async {
    try {
      final user = await _repository.getCurrentUser();
      await _repository.updatePreferences(
        user.id,
        stylePreferences: stylePreferences,
        colorPreferences: colorPreferences,
        avoidColors: avoidColors,
      );
      await loadUser();
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
