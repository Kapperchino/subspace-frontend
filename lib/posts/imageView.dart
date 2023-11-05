import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/imageView/imageViewEvent.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:transparent_image/transparent_image.dart';
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
        body: BlocBuilder<ImageViewBloc, ImageViewState>(
          builder: (context, state) {
            if (state.transform == Matrix4.identity()) {
              return getDraggable(state, context);
            }
            return GestureDetector(
                onDoubleTapDown: (d) => _doubleTapDetails = d,
                onDoubleTap: _handleDoubleTap,
                child: _ContextMenuRegion(
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
                    contextMenuBuilder: (context, offset) {
                      // The custom context menu will look like the default context menu
                      // on the current platform with a single 'Print' button.
                      return AdaptiveTextSelectionToolbar.buttonItems(
                        anchors: TextSelectionToolbarAnchors(
                          primaryAnchor: offset,
                        ),
                        buttonItems: <ContextMenuButtonItem>[
                          ContextMenuButtonItem(
                            onPressed: () {
                              ContextMenuController.removeAny();
                              _saveNetworkImage(state.pictureMeta?.url);
                            },
                            label: 'Save',
                          ),
                        ],
                      );
                    }));
          },
        ));
  }

  Widget getDraggable(ImageViewState state, BuildContext context) {
    return Draggable(
        dragAnchorStrategy: childDragAnchorStrategy,
        feedbackOffset: Offset.zero,
        feedback: getDraggedPic(state.pictureMeta?.url, context),
        childWhenDragging: const SizedBox(),
        onDragEnd: (details) {
          context.pop();
        },
        child: GestureDetector(
            onDoubleTapDown: (d) => _doubleTapDetails = d,
            onDoubleTap: _handleDoubleTap,
            child: _ContextMenuRegion(
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
                contextMenuBuilder: (context, offset) {
                  // The custom context menu will look like the default context menu
                  // on the current platform with a single 'Print' button.
                  return AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: TextSelectionToolbarAnchors(
                      primaryAnchor: offset,
                    ),
                    buttonItems: <ContextMenuButtonItem>[
                      ContextMenuButtonItem(
                        onPressed: () {
                          ContextMenuController.removeAny();
                          _saveNetworkImage(state.pictureMeta?.url);
                        },
                        label: 'Save',
                      ),
                    ],
                  );
                })));
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

  _saveNetworkImage(String? url) async {
    var response = await http.get(Uri.parse(url!));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.bodyBytes),
        quality: 80,
        name: UniqueKey().toString());
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
}

typedef ContextMenuBuilder = Widget Function(
    BuildContext context, Offset offset);

/// Shows and hides the context menu based on user gestures.
///
/// By default, shows the menu on right clicks and long presses.
class _ContextMenuRegion extends StatefulWidget {
  /// Creates an instance of [_ContextMenuRegion].
  const _ContextMenuRegion({
    required this.child,
    required this.contextMenuBuilder,
  });

  /// Builds the context menu.
  final ContextMenuBuilder contextMenuBuilder;

  /// The child widget that will be listened to for gestures.
  final Widget child;

  @override
  State<_ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<_ContextMenuRegion> {
  Offset? _longPressOffset;

  final ContextMenuController _contextMenuController = ContextMenuController();

  static bool get _longPressEnabled {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      case TargetPlatform.macOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
  }

  void _onSecondaryTapUp(TapUpDetails details) {
    _show(details.globalPosition);
  }

  void _onTap() {
    if (!_contextMenuController.isShown) {
      return;
    }
    _hide();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _longPressOffset = details.globalPosition;
  }

  void _onLongPress() {
    assert(_longPressOffset != null);
    _show(_longPressOffset!);
    _longPressOffset = null;
  }

  void _show(Offset position) {
    _contextMenuController.show(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return widget.contextMenuBuilder(context, position);
      },
    );
  }

  void _hide() {
    _contextMenuController.remove();
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapUp: _onSecondaryTapUp,
      onTap: _onTap,
      onLongPress: _longPressEnabled ? _onLongPress : null,
      onLongPressStart: _longPressEnabled ? _onLongPressStart : null,
      child: widget.child,
    );
  }
}
