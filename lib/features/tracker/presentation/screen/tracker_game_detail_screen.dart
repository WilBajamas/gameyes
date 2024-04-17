import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/features/tracker/data/models/saved_game.dart';
import 'package:gaming_library_assessment_flutter/widgets/status_tag.dart';

class TrackerGameDetailScreen extends StatelessWidget {
  final SavedGame game;

  const TrackerGameDetailScreen({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: AutoSizeText(
            game.name!,
            maxFontSize: 22,
            maxLines: 2,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () {},
                child: const StatusTag(
                  status: Status.inProgress,
                ),
              ),
            ),
          ],
          centerTitle: false,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                text: 'Details',
              ),
              Tab(
                text: 'Tasks',
              ),
              Tab(
                text: 'Timeline',
              ),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              Center(
                child: Text('something'),
              ),
              Center(
                child: Text('something'),
              ),
              Center(
                child: Text('something'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
