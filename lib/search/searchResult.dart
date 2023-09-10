import 'package:flutter/material.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/models/space.dart';
import 'package:go_router/go_router.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({
    super.key,
    required this.space,
  });

  final Space space;

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            context.push("/s/${space.parentId}/${space.name}");
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: const CircleAvatar(
                  maxRadius: 20,
                  backgroundImage: AssetImage('assets/default_space_small.png'),
                  backgroundColor: Colors.blue,
                ),
              ),
              Expanded(
                  flex: 8,
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      space.name,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                    ),
                    subtitle: Text(
                      space.description,
                      maxLines: 4,
                      overflow: TextOverflow.fade,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Flexible(
                            child: Text(
                          "${space.subCount}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }

  Future<Widget> getImage(PictureMeta? picture) async {
    if (picture == null) {
      return const SizedBox();
    }
    return Image.network(
      picture.url,
      width: 100,
      height: 100,
      fit: BoxFit.fill,
    );
  }
}
