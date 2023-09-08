import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:go_router/go_router.dart';

import '../cubit/commenting/commentingBloc.dart';
import '../cubit/commenting/commentingEvent.dart';
import '../cubit/commenting/commentingState.dart';
import '../models/comment.dart';

enum SortByEnum { latest, popular }

class SortByModal extends StatelessWidget {
  SortByModal({super.key, this.comment, this.post});

  final Comment? comment;
  final Post? post;
  SortByEnum? _groceryItem = SortByEnum.latest;

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
            RadioListTile<SortByEnum>(
              value: SortByEnum.latest,
              groupValue: _groceryItem,
              onChanged: (SortByEnum? value) {},
              title: const Text('Latest'),
            ),
            RadioListTile<SortByEnum>(
              value: SortByEnum.popular,
              groupValue: _groceryItem,
              onChanged: (SortByEnum? value) {},
              title: const Text('Populart'),
            ),
          ],
        ),
      ),
    );
  }
}
