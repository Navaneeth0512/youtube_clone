import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clone/features/downloadvideo/downloadscreen.dart';
import 'package:youtube_clone/features/home/bloc/homescreenbloc_bloc.dart';
import 'package:youtube_clone/features/home/bloc/homescreenbloc_event.dart';
import 'package:youtube_clone/features/home/bloc/homescreenbloc_state.dart';
import 'package:youtube_clone/features/video/videocard/videocard.dart';
import 'package:youtube_clone/widgets/shimmerloader.dart';
import 'package:youtube_clone/features/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false; // Toggle search mode
  String _searchQuery = ""; // Store the search query

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ["All", "Music", "News", "Movies", "Gaming"];

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search videos...",
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black),
              )
            : Row(
                children: [
                  Image.asset(
                    'assets/logo.png', // Replace with the correct path to your logo image
                    height: 38,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'YouTube',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
        backgroundColor: Colors.white,
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchQuery = "";
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories Section
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context
                        .read<HomeBloc>()
                        .add(ChangeCategoryEvent(categories[index]));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      label: Text(categories[index]),
                    ),
                  ),
                );
              },
            ),
          ),
          // Videos Section
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadingState) {
                  return const ShimmerLoader();
                } else if (state is HomeLoadedState) {
                  final filteredVideos = _searchQuery.isEmpty
                      ? state.videoData
                      : state.videoData
                          .where((video) =>
                              video['title']
                                  .toString()
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              video['channel']
                                  .toString()
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()))
                          .toList();

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeBloc>().add(FetchVideosEvent());
                    },
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollEndNotification &&
                            scrollNotification.metrics.pixels ==
                                scrollNotification.metrics.maxScrollExtent) {
                          context.read<HomeBloc>().add(LoadMoreVideosEvent());
                          return true;
                        }
                        return false;
                      },
                      child: ListView.builder(
                        itemCount: filteredVideos.length,
                        itemBuilder: (context, index) {
                          final video = filteredVideos[index];

                          return RepaintBoundary(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoCard(video: video),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Hero(
                                      tag: '${video['thumbnail']}_$index',
                                      child: Image.network(
                                        video['thumbnail'],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  video['title'],
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  "${video['channel']} • ${video['views']} • ${video['uploaded']}",
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton(
                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'share',
                                                child: Text('Share'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'save',
                                                child: Text('Save'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'report',
                                                child: Text('Report'),
                                              ),
                                            ],
                                            onSelected: (value) {
                                              // Handle menu actions
                                              switch (value) {
                                                case 'share':
                                                  // Share logic here
                                                  break;
                                                case 'save':
                                                  // Save logic here
                                                  break;
                                                case 'report':
                                                  // Report logic here
                                                  break;
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is HomeErrorState) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DownloadScreen()),
              );
              break;
            default:
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Downloads',
          ),
        ],
      ),
    );
  }
}
