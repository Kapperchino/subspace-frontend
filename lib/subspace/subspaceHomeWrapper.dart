import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/spaceHome/spaceHomeBloc.dart';
import 'package:frontend/cubit/spaceHome/spaceHomeEvent.dart';
import 'package:frontend/subspace/subspaceHome.dart';
import 'package:http/http.dart' as http;

class SubSpaceHomeWrapper extends StatelessWidget {
  const SubSpaceHomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SpaceHomeBloc(httpClient: http.Client())..add(SpacesFetched()),
      child: SubSpaceHome(),
    );
  }
}
