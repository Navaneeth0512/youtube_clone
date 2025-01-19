import 'package:flutter_bloc/flutter_bloc.dart';
import 'homescreenbloc_event.dart';
import 'homescreenbloc_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchVideosEvent>(_onFetchVideos);
    on<LoadMoreVideosEvent>(_onLoadMoreVideos);
  }

  Future<void> _onFetchVideos(FetchVideosEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate network call
      List<Map<String, dynamic>> videoData = [
        {
          "thumbnail": "https://images.unsplash.com/photo-1519608487953-e999c86e7455?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080",
          "title": "Relaxing Sunset Views",
          "channel": "Nature Lover",
          "views": "2.1M views",
          "uploaded": "3 days ago",
          "videoUrl": "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        },
        {
          "thumbnail": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080",
          "title": "Cityscapes Around the World",
          "channel": "Urban Explorer",
          "views": "4.8M views",
          "uploaded": "1 week ago",
          "videoUrl": "http://techslides.com/demos/sample-videos/small.mp4",
        },
         {
          "thumbnail": "https://images.unsplash.com/photo-1544197150-b99a580bb7a8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080",
          "title": "Underwater World",
          "channel": "Ocean Explorer",
          "views": "3.4M views",
          "uploaded": "1 day ago",
          "videoUrl": "https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        },
        {
          "thumbnail": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080",
          "title": "Explore the Mountains",
          "channel": "Nature Explorer",
          "views": "800K views",
          "uploaded": "5 days ago",
          "videoUrl": "http://techslides.com/demos/sample-videos/small.mp4",
        },
      ];
      emit(HomeLoadedState(videoData));
    } catch (error) {
      emit(HomeErrorState(error.toString()));
    }
  }

  Future<void> _onLoadMoreVideos(LoadMoreVideosEvent event, Emitter<HomeState> emit) async {
    if (state is HomeLoadedState) {
      final currentState = state as HomeLoadedState;
      emit(HomePaginatingState());
      await Future.delayed(const Duration(seconds: 2)); // Simulate loading more data

      List<Map<String, dynamic>> additionalVideos = [
        {
          "thumbnail": "https://images.unsplash.com/photo-1467269204594-9661b134dd2b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080",
          "title": "Underwater World",
          "channel": "Ocean Explorer",
          "views": "3.4M views",
          "uploaded": "1 day ago",
          "videoUrl": "https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        },
        { "thumbnail": "https://images.unsplash.com/photo-1498050108023-c5249f4df085?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080", "title": "Abstract Art Timelapse", "channel": "Creative Minds", "views": "1.2M views", "uploaded": "2 days ago", "videoUrl": "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4" },
      ];

      emit(HomeLoadedState([...currentState.videoData, ...additionalVideos]));
    }
  }
}
