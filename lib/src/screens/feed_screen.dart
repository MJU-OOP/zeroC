import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeroC/src/services/feed_service.dart';
import 'package:zeroC/src/models/feed_model.dart';

class FeedScreen extends StatelessWidget {
  final FeedService _feedService = FeedService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feeds')),
      body: StreamBuilder<List<FeedModel>>(
        stream: _feedService.getFeeds(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final feeds = snapshot.data!;
          return ListView.builder(
            itemCount: feeds.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(feeds[index].feedContent),
                subtitle: Text(feeds[index].feedCreatedAt.toDate().toString()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _feedService.createFeed(FeedModel(
            feedId: '',
            feedContent: 'New Feed Content',
            feedCreatedAt: Timestamp.now(),
            feedUserId: 'example_user_id',
            feedChallengeId: 'example_challenge_id',
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}