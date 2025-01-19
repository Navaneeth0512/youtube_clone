abstract class HomeEvent {}

class FetchVideosEvent extends HomeEvent {}

class LoadMoreVideosEvent extends HomeEvent {}

class SearchVideosEvent extends HomeEvent {
  final String query;

  SearchVideosEvent(this.query);
}

class ChangeCategoryEvent extends HomeEvent {
  final String category;

  ChangeCategoryEvent(this.category);
}
