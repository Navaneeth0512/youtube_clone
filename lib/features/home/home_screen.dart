import 'package:flutter/material.dart';
import 'package:youtube_clone/downloadscreen.dart';
import 'package:youtube_clone/features/profile/profile_screen.dart';
import 'package:youtube_clone/features/video/videocard.dart';
import 'package:youtube_clone/widgets/shimmerloader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _videoData = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _videoData = [
          {
            "thumbnail": "https://i.imgur.com/6jCXUOL.jpg",
            "title": "Relaxing Sunset Views",
            "channel": "Nature Lover",
            "views": "2.1M views",
            "uploaded": "3 days ago",
            "videoUrl": "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
          },
          {
            "thumbnail": "https://i.imgur.com/IL88xxS.jpg",
            "title": "Cityscapes Around the World",
            "channel": "Urban Explorer",
            "views": "4.8M views",
            "uploaded": "1 week ago",
            "videoUrl": "http://techslides.com/demos/sample-videos/small.mp4",
          },
          {
            "thumbnail": "https://i.imgur.com/q8vX8lZ.jpg",
            "title": "Abstract Art Timelapse",
            "channel": "Creative Minds",
            "views": "1.2M views",
            "uploaded": "2 days ago",
            "videoUrl": "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
          },
        ];
        _isLoading = false;
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _isLoading
          ? const ShimmerLoader()
          : ListView.builder(
              itemCount: _videoData.length,
              itemBuilder: (context, index) {
                return VideoCard(video: _videoData[index]);
              },
            ),
      const ProfileScreen(),
      DownloadScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('YouTube Clone')),
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
