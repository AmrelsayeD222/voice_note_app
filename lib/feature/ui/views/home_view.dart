import 'package:flutter/material.dart';
import 'package:voice_note_app/feature/ui/widgets/add_note_fab.dart';
import 'package:voice_note_app/feature/ui/widgets/add_voice_fab.dart';

import 'package:voice_note_app/feature/ui/widgets/home_app_bar.dart';
import 'package:voice_note_app/feature/ui/widgets/home_body.dart';
import 'package:voice_note_app/feature/ui/widgets/home_listener.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeListeners(
      child: Scaffold(
        appBar: HomeAppBar(),
        body: HomeBody(),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AddVoiceFAB(),
            SizedBox(height: 16),
            AddNoteFAB(),
          ],
        ),
      ),
    );
  }
}
