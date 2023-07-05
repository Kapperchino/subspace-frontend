import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/appUser.dart';
import 'package:frontend/models/voteRequest.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/stores/store.dart';

import '../config.dart';

class VoteWidgetFlat extends StatefulWidget {
  const VoteWidgetFlat(
      {super.key,
      required this.likes,
      required this.dislikes,
      required this.postId});

  final int likes;
  final int dislikes;
  final int postId;

  @override
  State<StatefulWidget> createState() {
    return _VoteFlatState(likes: likes, dislikes: dislikes, postId: postId);
  }
}

class _VoteFlatState extends State<VoteWidgetFlat> {
  int likes;
  int dislikes;
  final int postId;
  bool liked;
  bool disliked;

  _VoteFlatState(
      {required this.likes,
      required this.dislikes,
      required this.postId,
      this.liked = false,
      this.disliked = false});

  void upVote() async {
    await upVoteBackend(true);
    setState(() {
      //dislike to like
      if (disliked) {
        dislikes--;
        disliked = false;
        liked = true;
        likes++;
        return;
      }
      //unlike
      if (liked) {
        likes--;
        liked = false;
        return;
      }
      likes++;
      liked = true;
    });
  }

  void downVote() async {
    await upVoteBackend(false);
    setState(() {
      if (liked) {
        likes--;
        liked = false;
        disliked = true;
        dislikes++;
        return;
      }
      if (disliked) {
        disliked = false;
        dislikes--;
        return;
      }
      disliked = true;
      dislikes++;
    });
  }

  MaterialColor getColorUpVote() {
    if (liked) {
      return Colors.blue;
    }
    return Colors.grey;
  }

  MaterialColor getColorDownVote() {
    if (disliked) {
      return Colors.blue;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_upward_rounded),
          splashRadius: 20,
          color: getColorUpVote(),
          onPressed: () {
            upVote();
          },
        ),
        Text((likes - dislikes).toString()),
        IconButton(
          icon: const Icon(Icons.arrow_downward_rounded),
          color: getColorDownVote(),
          splashRadius: 20,
          onPressed: () {
            downVote();
          },
        ),
      ],
    ));
  }

  Future<int> upVoteBackend(bool isUpvote) async {
    final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.post(
      Uri.parse('${Config.baseUrl}/votes'),
      body: jsonEncode(VoteRequest(
              isUpvote: isUpvote,
              userId: user.id,
              postOrCommentId: postId,
              voteType: VoteType.post)
          .toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return res.statusCode;
  }
}
