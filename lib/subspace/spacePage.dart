import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/posting/postingBloc.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/subspace/subspace.dart';
import 'package:http/http.dart' as http;

import '../cubit/space/spaceBlock.dart';
import '../cubit/space/spaceEvent.dart';
import '../cubit/title/titleBloc.dart';

class SpacePage extends StatelessWidget {
  const SpacePage({super.key, required this.parentId, required this.spaceName});
  final int parentId;
  final String spaceName;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SpaceBloc(httpClient: http.Client())
            ..add(SpaceFetched(parentId: parentId, spaceName: spaceName)),
        ),
        BlocProvider(create: (_) => PostingBloc(httpClient: http.Client())),
        BlocProvider(
          create: (_) => TitleBloc(httpClient: http.Client()),
        ),
      ],
      child: Subspace(
        parentId: parentId,
        name: spaceName,
      ),
    );
  }
}
