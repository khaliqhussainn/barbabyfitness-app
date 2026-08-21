import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/data/auth_service.dart';

class ProfileState {
  const ProfileState({
    this.username = '',
    this.email = '',
    this.age = '',
    this.imagePath,
    this.avatarUrl,
    this.isLoading = false,
  });

  final String username;
  final String email;
  final String age;
  final String? imagePath;   // local file path (just picked, not yet uploaded)
  final String? avatarUrl;   // remote URL from server
  final bool isLoading;

  ProfileState copyWith({
    String? username,
    String? email,
    String? age,
    String? imagePath,
    bool clearImage = false,
    String? avatarUrl,
    bool? isLoading,
  }) {
    return ProfileState(
      username: username ?? this.username,
      email: email ?? this.email,
      age: age ?? this.age,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(const ProfileState(isLoading: true)) {
    _fetch();
  }

  Future<void> _fetch() async {
    final data = await AuthService.me();
    if (data != null) {
      state = ProfileState(
        username: data['name'] as String? ?? '',
        email: data['email'] as String? ?? '',
        age: data['age']?.toString() ?? '',
        avatarUrl: data['avatar_url'] as String?,
      );
    } else {
      state = const ProfileState();
    }
  }

  Future<void> refresh() => _fetch();

  void update({required String username, required String email, required String age}) {
    state = state.copyWith(username: username, email: email, age: age);
  }

  void setAvatarUrl(String url) => state = state.copyWith(avatarUrl: url);

  void setImage(String path) => state = state.copyWith(imagePath: path);
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);
