import 'package:flutter/material.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/models/space.dart';
import 'package:frontend/models/tagMeta.dart';
import 'package:go_router/go_router.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({
    super.key,
    required this.tag,
  });

  final TagMeta tag;

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            context.push("/search/results/${tag.name}?isTag=true");
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  flex: 8,
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      "#${tag.name}",
                      maxLines: 1,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Flexible(
                            child: Text(
                          "${tag.count}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
