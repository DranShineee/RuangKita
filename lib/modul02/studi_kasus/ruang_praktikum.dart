import 'package:flutter/material.dart';

import '../../../models/room_session.dart';

class RuangPraktikumScreen extends StatefulWidget {
  const RuangPraktikumScreen({super.key});

  @override
  State<RuangPraktikumScreen> createState() => _RuangPraktikumScreenState();
}

class _RuangPraktikumScreenState extends State<RuangPraktikumScreen> {

  RoomStatus? _selectedStatus;

  List<RoomSession> get _visibleSessions {
    final RoomStatus? filter = _selectedStatus;
    if (filter == null) return kDummyRoomSessions;
    return kDummyRoomSessions
        .where((RoomSession s) => s.status == filter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<RoomSession> sessions = _visibleSessions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('M02-2097 — RuangKita'),
      ),
      // Compact: 1 kolom vertikal.
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) {
          return _RoomCard(session: sessions[index]);
        },
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.session});

  final RoomSession session;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Stack(
      children: <Widget>[
        Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header: ikon kategori + nama ruang.
                Row(
                  children: <Widget>[
                    Icon(
                      _categoryIcon(session.category),
                      size: 18,
                      color: scheme.primary,
                    ),
                    const SizedBox(width: 6),
                    // Expanded wajib agar nama ruang panjang
                    // tidak menyebabkan RenderFlex overflow.
                    Expanded(
                      child: Text(
                        session.roomName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Nama kegiatan — maxLines 2 + ellipsis untuk teks panjang.
                Text(
                  session.activityName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),

                // Deskripsi — maxLines 2 + ellipsis.
                Text(
                  session.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),

                // Footer: waktu + kapasitas. Flexible mencegah
                // overflow saat text scale membesar.
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        session.timeRange,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${session.capacity} orang',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Badge status sebagai overlay di kanan atas.
        Positioned(
          top: 10,
          right: 10,
          child: _StatusBadge(status: session.status),
        ),
      ],
    );
  }
}

/// Badge status berisi titik berwarna + label.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final RoomStatus status;

  @override
  Widget build(BuildContext context) {
    final _BadgeColors colors = _badgeColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colors.foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              color: colors.foreground,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pasangan warna foreground/background badge.
class _BadgeColors {
  const _BadgeColors({required this.foreground, required this.background});

  final Color foreground;
  final Color background;
}

_BadgeColors _badgeColors(RoomStatus status) {
  switch (status) {
    case RoomStatus.berlangsung:
      return const _BadgeColors(
        foreground: Color(0xFF1B5E20),
        background: Color(0xFFC8E6C9),
      );
    case RoomStatus.akanDatang:
      return const _BadgeColors(
        foreground: Color(0xFF0D47A1),
        background: Color(0xFFBBDEFB),
      );
    case RoomStatus.selesai:
      return const _BadgeColors(
        foreground: Color(0xFF37474F),
        background: Color(0xFFCFD8DC),
      );
    case RoomStatus.tersedia:
      return const _BadgeColors(
        foreground: Color(0xFFE65100),
        background: Color(0xFFFFE0B2),
      );
  }
}

/// Ikon per kategori ruang.
IconData _categoryIcon(RoomCategory category) {
  switch (category) {
    case RoomCategory.ruangRapat:
      return Icons.meeting_room_outlined;
    case RoomCategory.ruangDiskusi:
      return Icons.forum_outlined;
    case RoomCategory.coworking:
      return Icons.groups_outlined;
  }
}