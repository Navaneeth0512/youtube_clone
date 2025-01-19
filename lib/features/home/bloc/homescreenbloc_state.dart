abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<Map<String, dynamic>> videoData;
  HomeLoadedState(this.videoData);
}

class HomeErrorState extends HomeState {
  final String errorMessage;
  HomeErrorState(this.errorMessage);
}

class HomePaginatingState extends HomeState {}

class HomeSearchState extends HomeState {
  final String query;
  HomeSearchState(this.query);
}
