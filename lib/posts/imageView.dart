import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/imageView/imageViewEvent.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:vector_math/vector_math_64.dart' as vec;
import '../cubit/imageView/imageViewBloc.dart';
import '../cubit/imageView/imageViewState.dart';

class ImageView extends StatelessWidget {
  ImageView({
    super.key,
  });

  final _transformationController = TransformationController();

  TapDownDetails? _doubleTapDetails;

  @override
  Widget build(BuildContext context) {
    _transformationController.addListener(() => context
        .read<ImageViewBloc>()
        .add(ImageViewChanged(transform: _transformationController.value)));
    return Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          Flexible(
            child: BlocBuilder<ImageViewBloc, ImageViewState>(
              builder: (context, state) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Flexible(child: getView(state, context))],
                );
              },
            ),
          ),
          BlocListener<ImageViewBloc, ImageViewState>(
            listener: (context, state) {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (state.status == ImageViewStatus.saved) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Image saved')));
              }
            },
            child: SizedBox(),
          ),
        ]));
  }

  Widget getView(ImageViewState state, BuildContext context) {
    final distance =
        state.transform.getTranslation().distanceTo(vec.Vector3.all(0)).abs();
    if (distance < 2) {
      return getDraggable(state, context);
    }
    return GestureDetector(
      onDoubleTapDown: (d) => _doubleTapDetails = d,
      onDoubleTap: _handleDoubleTap,
      onLongPress: () {
        HapticFeedback.heavyImpact();
        _showActionSheet(context, state);
      },
      child: Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          panAxis: PanAxis.aligned,
          minScale: 0.1,
          maxScale: 20,
          constrained: true,
          child: getPicture(state.pictureMeta?.url),
          onInteractionUpdate: (details) {
            context.read<ImageViewBloc>().add(
                ImageViewChanged(transform: _transformationController.value));
          },
        ),
      ),
    );
  }

  Widget getDraggable(ImageViewState state, BuildContext context) {
    return Draggable(
        dragAnchorStrategy: childDragAnchorStrategy,
        feedbackOffset: Offset.zero,
        affinity: Axis.vertical,
        maxSimultaneousDrags: 1,
        feedback: getDraggedPic(state.pictureMeta?.url, context),
        childWhenDragging: const SizedBox(),
        onDragEnd: (details) {
          var multi = 1.0;
          if (details.offset.direction < 0) {
            multi = 3.4;
          }
          if (details.offset.distance * multi >= 190) {
            context.pop();
          }
        },
        child: GestureDetector(
          onDoubleTapDown: (d) => _doubleTapDetails = d,
          onDoubleTap: _handleDoubleTap,
          onLongPress: () {
            HapticFeedback.heavyImpact();
            _showActionSheet(context, state);
          },
          child: Center(
            child: InteractiveViewer(
              transformationController: _transformationController,
              panAxis: PanAxis.aligned,
              minScale: 0.1,
              maxScale: 20,
              constrained: true,
              child: getPicture(state.pictureMeta?.url),
              onInteractionUpdate: (details) {
                context.read<ImageViewBloc>().add(ImageViewChanged(
                    transform: _transformationController.value));
              },
            ),
          ),
        ));
  }

  void _showActionSheet(BuildContext context, ImageViewState state) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context1) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            isDefaultAction: true,
            onPressed: () async {
              context1.pop();
              await saveNetworkImage(state.pictureMeta?.url).then((value) {
                context.read<ImageViewBloc>().add(ImageSaved());
              });
            },
            child: const Text('Save Image'),
          ),
        ],
      ),
    );
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }

  Widget getPicture(String? url) {
    if (url == null) {
      return Image.memory(kTransparentImage);
    }
    var urlPrefix = "";
    return CachedNetworkImage(
      imageUrl: "$urlPrefix$url",
      fit: BoxFit.contain,
      width: 1600,
      height: 1600,
      placeholder: (context, url) => Image.memory(
        kTransparentImage,
      ),
    );
  }

  Widget getDraggedPic(String? url, BuildContext context) {
    if (url == null) {
      return Image.memory(kTransparentImage);
    }
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    var urlPrefix = "";
    return Center(
        child: CachedNetworkImage(
      imageUrl: "$urlPrefix$url",
      fit: BoxFit.contain,
      width: deviceWidth,
      height: deviceHeight,
      placeholder: (context, url) => Image.memory(
        kTransparentImage,
      ),
    ));
  }

  Future<void> saveNetworkImage(String? url) async {
    var response = await http.get(Uri.parse(url!));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.bodyBytes),
        quality: 80,
        name: UniqueKey().toString());
  }
}
