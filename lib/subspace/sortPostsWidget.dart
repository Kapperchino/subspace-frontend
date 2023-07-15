import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/space/spaceEvent.dart';

import '../posts/cubit/space/spaceBlock.dart';
import '../posts/cubit/space/spaceState.dart';

class SortPostsWidget extends StatelessWidget {
  const SortPostsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
      return DropdownButtonHideUnderline(
        child: DropdownButton2<SortState>(
          isExpanded: true,
          hint: Text(
            'SortBy',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: const [
            DropdownMenuItem<SortState>(
              value: SortState.popular,
              child: Row(
                children: [
                  Text(
                    "Popularity",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Icon(Icons.people)
                ],
              ),
            ),
            DropdownMenuItem<SortState>(
              value: SortState.latest,
              child: Row(
                children: [
                  Text(
                    "Newest",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Icon(Icons.trending_up)
                ],
              ),
            )
          ],
          value: state.sortState,
          onChanged: (SortState? value) {
            context.read<SpaceBloc>().add(SpaceSortChanged(sortState: value!));
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            width: 140,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
        ),
      );
    });
  }
}
