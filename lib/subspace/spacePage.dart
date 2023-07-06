import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/subspace/subspace.dart';
import 'package:http/http.dart' as http;

import '../posts/cubit/space/spaceBlock.dart';
import '../posts/cubit/space/spaceEvent.dart';


class SpacePage extends StatelessWidget {
  const SpacePage({super.key, required this.parentId, required this.spaceName});
  final int parentId;
  final String spaceName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpaceBloc(httpClient: http.Client())
        ..add((SpaceFetched(parentId: parentId, spaceName: spaceName))),
      child: Subspace(
        parentId: parentId,
        name: spaceName,
      ),
    );
  }
}
