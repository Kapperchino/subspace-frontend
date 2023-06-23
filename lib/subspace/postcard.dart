import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {super.key,
      required this.topic,
      required this.content,
      required this.likes,
      required this.dislikes});

  final String topic;
  final String content;
  final int likes;
  final int dislikes;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) => Text(topic);

  Widget buildSubtitle(BuildContext context) => Text(content);
}
