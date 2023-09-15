import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/title/titleBloc.dart';
import 'package:frontend/cubit/title/titleEvent.dart';
import 'package:frontend/cubit/title/titleState.dart';
import 'package:frontend/models/space.dart';

class SpaceAbout extends StatelessWidget {
  SpaceAbout({this.meta});
  Space? meta;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: CircleAvatar(
            maxRadius: 40,
            backgroundImage: AssetImage('assets/default_space_small.png'),
            backgroundColor: Colors.blue,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                meta?.name ?? "joe",
                style: Theme.of(context).textTheme.headlineLarge,
                textScaleFactor: 1.3,
              )),
        ),
        Card(
            elevation: 8,
            borderOnForeground: false,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  style: Theme.of(context).textTheme.bodyLarge,
                  meta?.description ?? "joe",
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.1,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Flexible(
                      child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Flexible(
                    child: Text("${meta?.subCount ?? 0}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const Spacer(
                    flex: 10,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 50)),
                  BlocBuilder<TitleBloc, TitleState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: FilledButton(
                            style: FilledButton.styleFrom(
                                minimumSize: const Size(60, 45),
                                visualDensity: VisualDensity.compact),
                            onPressed: () {
                              {
                                if (state.status == TitleStatus.init) {
                                  context.read<TitleBloc>().add(JoinEvent());
                                } else {
                                  context.read<TitleBloc>().add(LeaveEvent());
                                }
                              }
                            },
                            child: Text(state.buttonName)),
                      );
                    },
                  )
                ],
              ),
            ])),
      ],
    ));
  }
}
