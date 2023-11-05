import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/navBarWidget.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/videoMeta.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Thumbnail extends StatefulWidget {
  Thumbnail(
      {super.key,
      required this.controller,
      required this.videoMeta,
      required this.videoPlayerController});
  ChewieController controller;
  VideoMeta videoMeta;
  VideoPlayerController videoPlayerController;

  @override
  State<StatefulWidget> createState() {
    return ThumbnailState(
        controller: controller,
        videoMeta: videoMeta,
        videoPlayerController: videoPlayerController);
  }
}

enum ThumbnailStatus { initial, loading, done }

class ThumbnailState extends State<Thumbnail> {
  static const double CARD_MAX_HEIGHT = 600;
  static const double CARD_MAX_WIDTH = 600;

  ThumbnailState(
      {required this.controller,
      required this.videoMeta,
      required this.videoPlayerController});
  ChewieController controller;
  VideoPlayerController videoPlayerController;
  VideoMeta videoMeta;
  ThumbnailStatus status = ThumbnailStatus.initial;
  @override
  Widget build(BuildContext context) {
    if (status == ThumbnailStatus.done) {
      return VisibilityDetector(
          key: Key(videoMeta.id.toString()),
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction > 0.6) {
            } else {
              controller.pause();
            }
          },
          child: Chewie(
            controller: controller,
          ));
    }
    if (status == ThumbnailStatus.loading) {
      return Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder(
            future: getImage(
                PictureMeta(
                    width: videoMeta.width,
                    height: videoMeta.height,
                    url: videoMeta.thumbnail,
                    id: -1),
                context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              }
              final deviceWidth = MediaQuery.of(context).size.width - 40;
              final maxWidth = min(deviceWidth, CARD_MAX_WIDTH);
              final imageRatio = videoMeta.width / videoMeta.height;
              final adjustedHeight = maxWidth / imageRatio;
              final double height = min(CARD_MAX_HEIGHT, adjustedHeight);
              return SizedBox(
                height: height,
                width: maxWidth,
              );
            },
          ),
          CircularProgressIndicator.adaptive()
        ],
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        FutureBuilder(
          future: getImage(
              PictureMeta(
                  width: videoMeta.width,
                  height: videoMeta.height,
                  url: videoMeta.thumbnail,
                  id: -1),
              context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            }
            final deviceWidth = MediaQuery.of(context).size.width - 40;
            final maxWidth = min(deviceWidth, CARD_MAX_WIDTH);
            final imageRatio = videoMeta.width / videoMeta.height;
            final adjustedHeight = maxWidth / imageRatio;
            final double height = min(CARD_MAX_HEIGHT, adjustedHeight);
            return SizedBox(
              height: height,
              width: maxWidth,
            );
          },
        ),
        IconButton.filledTonal(
            iconSize: 35,
            onPressed: () async {
              status = ThumbnailStatus.loading;
              setState(() {});
              await videoPlayerController.initialize();
              await controller.play();
              status = ThumbnailStatus.done;
              setState(() {});
            },
            icon: const Icon(Icons.play_arrow)),
      ],
    );
  }

  Future<Widget> getImage(PictureMeta? pictures, BuildContext context) async {
    final deviceWidth = MediaQuery.of(context).size.width - 40;
    final maxWidth = min(deviceWidth, CARD_MAX_WIDTH);
    final defaultRatio = maxWidth / CARD_MAX_HEIGHT;
    final imageRatio = pictures!.width / pictures.height;
    var boxfit = BoxFit.fitWidth;
    final adjustedHeight = maxWidth / imageRatio;
    final double height = min(CARD_MAX_HEIGHT, adjustedHeight);
    if (imageRatio < defaultRatio) {
      boxfit = BoxFit.cover;
    }
    final cachedRatio =
        min(pictures.width / maxWidth, pictures.height / height);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: pictures.url,
              placeholder: (context, url) => Image.memory(
                kTransparentImage,
                width: maxWidth,
                height: height,
              ),
              width: maxWidth,
              height: height,
              filterQuality: FilterQuality.medium,
              memCacheHeight: (height * cachedRatio).round(),
              memCacheWidth: (maxWidth * cachedRatio).round(),
              fit: boxfit,
            )));
  }
}
