import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/title/titleEvent.dart';

import '../posts/cubit/title/titleBloc.dart';
import '../posts/cubit/title/titleState.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    if (title != "SubSpace") {
      return BlocBuilder<TitleBloc, TitleState>(
          builder: (context, state) => Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(title),
                    SizedBox(
                      height: 20,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            fixedSize: const Size(60, 20),
                            padding: const EdgeInsets.all(0)),
                        onPressed: () {
                          if (state.status == TitleStatus.init) {
                            context.read<TitleBloc>().add(JoinEvent());
                          } else {
                            context.read<TitleBloc>().add(LeaveEvent());
                          }
                        },
                        onHover: (value) {
                          if (value) {
                            context.read<TitleBloc>().add(HoverEnter());
                          } else {
                            context.read<TitleBloc>().add(HoverLeave());
                          }
                        },
                        child: Text(
                          state.buttonName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    )
                  ]));
    }
    return Text(title);
  }
}
