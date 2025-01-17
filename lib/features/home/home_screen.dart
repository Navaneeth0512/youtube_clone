import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_clone/downloadscreen.dart';
import 'package:youtube_clone/features/profile/profile_screen.dart';
import 'package:youtube_clone/widgets/shimmerloader.dart';
import 'package:youtube_clone/features/video/videocard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _videoData = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isPaginating = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchVideos() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _videoData.addAll([
          {
            "thumbnail": "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080",
            "title": "Relaxing Sunset Views",
            "channel": "Nature Lover",
            "views": "2.1M views",
            "uploaded": "3 days ago",
            "videoUrl": "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
          },
          {
            "thumbnail": "https://images.unsplash.com/photo-1491553895911-0055eca6402d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080",
            "title": "Cityscapes Around the World",
            "channel": "Urban Explorer",
            "views": "4.8M views",
            "uploaded": "1 week ago",
            "videoUrl": "http://techslides.com/demos/sample-videos/small.mp4",
          },
          {
            "thumbnail": "https://images.unsplash.com/photo-1498050108023-c5249f4df085?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080",
            "title": "Abstract Art Timelapse",
            "channel": "Creative Minds",
            "views": "1.2M views",
            "uploaded": "2 days ago",
            "videoUrl": "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
          },
        ]);
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreVideos() async {
    if (_isPaginating) return;

    setState(() {
      _isPaginating = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _videoData.addAll([
          {
            "thumbnail": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080",
            "title": "Underwater World",
            "channel": "Ocean Explorer",
            "views": "3.4M views",
            "uploaded": "1 day ago",
            "videoUrl": "https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
          },
          {
            "thumbnail": "https://images.unsplash.com/photo-1519608487953-e999c86e7455?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080",
            "title": "Mountain Climbing Adventure",
            "channel": "Climbers United",
            "views": "1.8M views",
            "uploaded": "2 days ago",
            "videoUrl": "https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
          },
        ]);
        _isPaginating = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0 &&
        !_isPaginating) {
      _loadMoreVideos();
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Hero(
              tag: video['thumbnail'],
              child: VideoCard(video: video),
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: video['thumbnail'],
              child: CachedNetworkImage(
                imageUrl: video['thumbnail'],
                placeholder: (context, url) => const ShimmerLoader(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                video['title'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "${video['channel']} • ${video['views']} • ${video['uploaded']}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _isLoading
          ? const ShimmerLoader()
          : RefreshIndicator(
              onRefresh: _fetchVideos,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _videoData.length + (_isPaginating ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _videoData.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _buildVideoCard(_videoData[index]);
                },
              ),
            ),
      const ProfileScreen(),
       DownloadScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Clone'),
        backgroundColor: Colors.red,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
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
