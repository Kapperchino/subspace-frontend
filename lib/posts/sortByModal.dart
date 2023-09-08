import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/cubit/sorting/sortEvent.dart';
import 'package:frontend/cubit/sorting/sortState.dart';
import 'package:frontend/cubit/space/spaceState.dart';
import 'package:go_router/go_router.dart';

class SortByModal extends StatelessWidget {
  const SortByModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SortBloc, SortState>(builder: (context, state) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<SortStatus>(
                value: SortStatus.latest,
                groupValue: state.status,
                onChanged: (SortStatus? value) {
                  context.read<SortBloc>().add(SortChanged(sortState: value!));
                  context.pop();
                },
                title: const Text('Latest'),
              ),
              RadioListTile<SortStatus>(
                value: SortStatus.popular,
                groupValue: state.status,
                onChanged: (SortStatus? value) {
                  context.read<SortBloc>().add(SortChanged(sortState: value!));
                  context.pop();
                },
                title: const Text('Popular'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
