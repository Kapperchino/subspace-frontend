import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/cubit/sorting/sortState.dart';
import 'package:frontend/cubit/space/spaceState.dart';
import 'package:go_router/go_router.dart';
import '../cubit/sorting/sortEvent.dart';

class SortDaysModal extends StatelessWidget {
  const SortDaysModal({super.key});

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
              RadioListTile<SortDays>(
                value: SortDays.week,
                groupValue: state.sortDays,
                onChanged: (SortDays? value) {
                  context
                      .read<SortBloc>()
                      .add(DaysSortChanged(sortDays: value!));
                  context.pop();
                },
                title: const Text('This Week'),
              ),
              RadioListTile<SortDays>(
                value: SortDays.month,
                groupValue: state.sortDays,
                onChanged: (SortDays? value) {
                  context
                      .read<SortBloc>()
                      .add(DaysSortChanged(sortDays: value!));
                  context.pop();
                },
                title: const Text('This Month'),
              ),
              RadioListTile<SortDays>(
                value: SortDays.year,
                groupValue: state.sortDays,
                onChanged: (SortDays? value) {
                  context
                      .read<SortBloc>()
                      .add(DaysSortChanged(sortDays: value!));
                  context.pop();
                },
                title: const Text('This Year'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
