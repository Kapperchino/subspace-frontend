import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/posts/cubit/profile/profileEvent.dart';
import 'package:frontend/posts/cubit/profile/profileState.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../../config.dart';
import '../../../models/appUser.dart';
import '../../../models/post.dart';
import '../../../stores/store.dart';

class ProfileBlock extends Bloc<ProfileEvent, ProfileState> {
  ProfileBlock(super.initialState);


  Future<List<Post>> getPost(int id) async {
    final token = await Store.secure.read(key: 'jwt');
    final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/posts/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      final List<dynamic> postList = jsonDecode(utf8.decode(res.bodyBytes));
      final posts = postList.map((e) => Post.fromJson(e));
      return posts.toList();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}