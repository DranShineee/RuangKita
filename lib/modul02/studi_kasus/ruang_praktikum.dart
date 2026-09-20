import 'package:flutter/material.dart';

import '../../../models/room_session.dart';

class RuangPraktikumScreen extends StatelessWidget {
  const RuangPraktikumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M02-2097 — RuangKita'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'model & dummy data',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text('Total data: ${kDummyRoomSessions.length} record'),
          const Divider(),
          ...kDummyRoomSessions.map(
            (RoomSession s) => ListTile(
              dense: true,
              title: Text(
                s.activityName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${s.roomName} • ${s.category.label} • '
                '${s.status.label} • ${s.timeRange}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}