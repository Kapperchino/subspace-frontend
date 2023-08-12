import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/cubit/sorting/sortState.dart';

import '../cubit/sorting/sortEvent.dart';
import '../cubit/space/spaceState.dart';

class SortPostsDaysWidget extends StatelessWidget {
  const SortPostsDaysWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SortBloc, SortState>(builder: (context, state) {
      return DropdownButtonHideUnderline(
        child: DropdownButton2<SortDays>(
          isExpanded: true,
          hint: Text(
            'Days',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: const [
            DropdownMenuItem<SortDays>(
              value: SortDays.week,
              child: Row(
                children: [
                  Text(
                    "1 Week",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            DropdownMenuItem<SortDays>(
              value: SortDays.month,
              child: Row(
                children: [
                  Text(
                    "1 Month",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            DropdownMenuItem<SortDays>(
              value: SortDays.halfYear,
              child: Row(
                children: [
                  Text(
                    "6 Months",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            DropdownMenuItem<SortDays>(
              value: SortDays.year,
              child: Row(
                children: [
                  Text(
                    "1 Year",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          ],
          value: state.sortDays,
          onChanged: (SortDays? value) {
            context.read<SortBloc>().add(DaysSortChanged(sortDays: value!));
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
