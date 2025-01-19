import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<Logout>(_onLogout);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // Simulating user profile data
      const username = "Johnny";
      const email = "johnny@example.com";

      emit(ProfileLoaded(username: username, email: email));
    } catch (e) {
      emit(ProfileError("Failed to load profile"));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<ProfileState> emit) async {
    try {
      // Simulate logout
      emit(ProfileLoggedOut());
    } catch (e) {
      emit(ProfileError("Logout failed"));
    }
  }
}
