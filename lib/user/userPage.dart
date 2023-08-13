import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/userPage/userPageBloc.dart';
import 'package:frontend/cubit/userPage/userPageEvent.dart';
import 'package:frontend/user/userWidget.dart';
import 'package:http/http.dart' as http;

import '../cubit/sorting/sortBloc.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserPageBloc(httpClient: http.Client())
            ..add(UserPageInit(userId: userId)),
        ),
        BlocProvider(create: (_) => SortBloc(httpClient: http.Client()))
      ],
      child: UserWidget(
        userId: userId,
      ),
    );
  }
}
