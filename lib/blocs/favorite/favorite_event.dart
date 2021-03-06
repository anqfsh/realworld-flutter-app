part of blocs.favorite;

abstract class FavoriteEvent {}

@immutable
class UpdateFavoriteEvent extends FavoriteEvent {
  final String slug;
  final bool favorited;

  UpdateFavoriteEvent({
    @required this.slug,
    @required this.favorited,
  }); // : super([slug]);
  @override
  String toString() =>
      'ToggleFavoriteEvent[slug: $slug, favorited: $favorited]';
}
