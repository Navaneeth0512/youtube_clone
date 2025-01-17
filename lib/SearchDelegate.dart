// import 'package:flutter/material.dart';

// abstract class SearchDelegateCustom extends SearchDelegate {
//   final List<String> videoTitles;

//   SearchDelegateCustom(this.videoTitles);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final results = videoTitles.where((video) => video.contains(query)).toList();
//     return ListView.builder(
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         return ListTile(title: Text(results[index]));
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestions = videoTitles.where((video) => video.contains(query)).toList();
//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         return ListTile(title: Text(suggestions[index]));
//       },
//     );
//   }
// }