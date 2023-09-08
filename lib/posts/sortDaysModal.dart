import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:go_router/go_router.dart';

import '../cubit/commenting/commentingBloc.dart';
import '../cubit/commenting/commentingEvent.dart';
import '../cubit/commenting/commentingState.dart';
import '../models/comment.dart';

enum SortDaysEnum { day, week, month, halfYear, year }

class SortDaysModal extends StatelessWidget {
  SortDaysModal({super.key, this.comment, this.post});

  final Comment? comment;
  final Post? post;
  SortDaysEnum? _groceryItem = SortDaysEnum.month;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<SortDaysEnum>(
              value: SortDaysEnum.day,
              groupValue: _groceryItem,
              onChanged: (SortDaysEnum? value) {},
              title: const Text('Today'),
            ),
            RadioListTile<SortDaysEnum>(
              value: SortDaysEnum.week,
              groupValue: _groceryItem,
              onChanged: (SortDaysEnum? value) {},
              title: const Text('This Week'),
            ),
            RadioListTile<SortDaysEnum>(
              value: SortDaysEnum.month,
              groupValue: _groceryItem,
              onChanged: (SortDaysEnum? value) {},
              title: const Text('This Month'),
            ),
            RadioListTile<SortDaysEnum>(
              value: SortDaysEnum.year,
              groupValue: _groceryItem,
              onChanged: (SortDaysEnum? value) {},
              title: const Text('This Year'),
            ),
          ],
        ),
      ),
    );
  }
}
