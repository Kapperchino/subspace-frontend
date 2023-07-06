
import 'package:flutter/material.dart';
import 'package:frontend/subspace/spacePage.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpacePage(spaceName: "root", parentId: 0);
  }
}
