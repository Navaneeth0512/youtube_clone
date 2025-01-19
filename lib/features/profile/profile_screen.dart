import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_clone/features/profile/bloc/profile_bloc.dart';
import 'package:youtube_clone/features/theme/theme_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfile()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Directly navigate to the login screen on logout
                Navigator.pushReplacementNamed(context, '/login');
              },
              tooltip: "Logout",
            ),
          ],
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Profile Info
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage('https://robohash.org/hello'), // Placeholder avatar
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.username,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      // Dark Mode Toggle
                      SwitchListTile(
                        title: const Text("Dark Mode"),
                        value: isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      ),
                      const Divider(),
                      // Settings Section
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text("Settings"),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Settings page is not yet implemented.")),
                          );
                        },
                      ),
                      const Divider(),
                      // Help Section
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text("Help & Feedback"),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Help & Feedback is not yet implemented.")),
                          );
                        },
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text("Something went wrong!"));
            }
          },
        ),
      ),
    );
  }
}
