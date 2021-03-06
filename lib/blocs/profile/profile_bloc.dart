part of blocs.profile;

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  StreamSubscription _userRepositorySubscription;

  ProfileBloc({
    @required this.userRepository,
  }) {
    assert(userRepository != null);

    _userRepositorySubscription =
        userRepository.on<UserRepositoryEvent>().listen(_reloadHandler);
  }

  void _reloadHandler(UserRepositoryEvent event) {
    if (state is ProfileLoaded) {
      if (event is UserUpdatedEvent) {
        add(
          LoadProfileEvent(
            username: (state as ProfileLoaded).profile.username,
          ),
        );
      }
    }
  }

  @override
  ProfileState get initialState => ProfileUninitialized();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfileEvent) {
      yield* _loadProfile(event);
    } else if (event is ToggleFollowUserEvent) {
      yield* _toggleFollowUser(event);
    }
  }

  Stream<ProfileState> _loadProfile(LoadProfileEvent event) async* {
    try {
      yield ProfileLoading();
      final profile = await userRepository.getProfileByUsername(event.username);

      yield ProfileLoaded(profile: profile);
    } catch (error) {
      yield ProfileError(
        error: _parseError(error),
      );
    }
  }

  Stream<ProfileState> _toggleFollowUser(ToggleFollowUserEvent event) async* {
    if (state is ProfileLoaded) {
      var profile = (state as ProfileLoaded).profile;
      try {
        yield ProfileLoading();

        if (profile.following) {
          profile = await userRepository.unFollowUser(event.username);
        } else {
          profile = await userRepository.followUser(event.username);
        }

        yield ProfileLoaded(profile: profile);
      } catch (error) {
        yield ProfileError(
          error: _parseError(error),
        );
      }
    }
  }

  String _parseError(Object error) {
    if (error is StringResponse) {
      final body = jsonDecode(error.body) as Map<String, dynamic>;

      if (body['error'] != null && body['error']['message'] != null) {
        return body['error']['message'] as String;
      }
    }

    return error.toString();
  }

  @override
  Future<void> close() {
    _userRepositorySubscription.cancel();
    return super.close();
  }
}
