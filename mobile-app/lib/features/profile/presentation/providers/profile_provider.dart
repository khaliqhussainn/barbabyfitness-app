import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {
  const ProfileState({
    this.username = 'User',
    this.email = 'username@hosting.com',
    this.age = '25',
    this.imagePath,
  });

  final String username;
  final String email;
  final String age;
  final String? imagePath;

  ProfileState copyWith({
    String? username,
    String? email,
    String? age,
    String? imagePath,
    bool clearImage = false,
  }) {
    return ProfileState(
      username: username ?? this.username,
      email: email ?? this.email,
      age: age ?? this.age,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(const ProfileState());

  void update({
    required String username,
    required String email,
    required String age,
  }) {
    state = state.copyWith(username: username, email: email, age: age);
  }

  void setImage(String path) {
    state = state.copyWith(imagePath: path);
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});
