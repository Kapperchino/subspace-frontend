import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:transparent_image/transparent_image.dart';

import '../cubit/imageView/imageViewBloc.dart';
import '../cubit/imageView/imageViewState.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<ImageViewBloc, ImageViewState>(
            builder: (context, state) {
          return FutureBuilder(
            future: disableContext(),
            builder: (context, snapshot) {
              return _ContextMenuRegion(
                  child: Center(
                    child: InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(20.0),
                      panAxis: PanAxis.aligned,
                      minScale: 0.1,
                      maxScale: 20,
                      child: getPicture(state.pictureMeta?.url),
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
                  });
            },
          );
        }));
  }

  _saveNetworkImage(String? url) async {
    if (kIsWeb) {
      await WebImageDownloader.downloadImageFromWeb(url!);
    } else {
      var response = await http.get(Uri.parse(url!));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.bodyBytes),
          quality: 80,
          name: UniqueKey().toString());
    }
  }

  Future<void> disableContext() async {
    if (kIsWeb) {
      await BrowserContextMenu.disableContextMenu();
    }
  }

  Widget getPicture(String? url) {
    if (url == null) {
      return Image.memory(kTransparentImage);
    }
    var urlPrefix = "";
    if (kIsWeb) {
      urlPrefix = "https://subspace-cors.fly.dev/";
    }
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
