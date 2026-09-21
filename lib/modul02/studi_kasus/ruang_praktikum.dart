import 'package:flutter/material.dart';

import '../../../models/room_session.dart';

class RuangPraktikumScreen extends StatefulWidget {
  const RuangPraktikumScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  final ThemeMode themeMode;

  final VoidCallback onToggleTheme;

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

  void _onFilterChanged(RoomStatus? status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<RoomSession> sessions = _visibleSessions;
    final bool isDark = widget.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('M02-2097 — RuangKita'),
        actions: <Widget>[
          IconButton(
            tooltip: isDark ? 'Aktifkan Light Mode' : 'Aktifkan Dark Mode',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _FilterBar(
            selected: _selectedStatus,
            onChanged: _onFilterChanged,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double maxWidth = constraints.maxWidth;

                if (maxWidth < 600) {
                  return _CompactLayout(sessions: sessions);
                } else if (maxWidth < 840) {
                  return _MediumLayout(sessions: sessions);
                } else {
                  return _ExpandedLayout(sessions: sessions);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.selected,
    required this.onChanged,
  });

  final RoomStatus? selected;
  final ValueChanged<RoomStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          ChoiceChip(
            label: const Text('Semua'),
            selected: selected == null,
            onSelected: (_) => onChanged(null),
          ),
          ...RoomStatus.values.map(
            (RoomStatus status) => ChoiceChip(
              label: Text(status.label),
              selected: selected == status,
              onSelected: (_) => onChanged(status),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactLayout extends StatelessWidget {
  const _CompactLayout({required this.sessions});

  final List<RoomSession> sessions;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const _EmptyState();
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: sessions.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        return _RoomCard(session: sessions[index]);
      },
    );
  }
}

class _MediumLayout extends StatelessWidget {
  const _MediumLayout({required this.sessions});

  final List<RoomSession> sessions;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const _EmptyState();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: _RoomGrid(
        sessions: sessions,
        crossAxisCount: 2,
      ),
    );
  }
}

class _ExpandedLayout extends StatelessWidget {
  const _ExpandedLayout({required this.sessions});

  final List<RoomSession> sessions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: sessions.isEmpty
                ? const _EmptyState()
                : _RoomGrid(
                    sessions: sessions,
                    crossAxisCount: 2,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: _SummaryPanel(sessions: sessions),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.search_off,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Tidak ada kegiatan untuk filter ini.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomGrid extends StatelessWidget {
  const _RoomGrid({
    required this.sessions,
    required this.crossAxisCount,
  });

  final List<RoomSession> sessions;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    final double scale =
        MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.6);
    const double baseHeight = 224.0;
    final double cellHeight = baseHeight * scale;

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: cellHeight,
      ),
      itemCount: sessions.length,
      itemBuilder: (BuildContext context, int index) {
        return _RoomCard(session: sessions[index], expand: true);
      },
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.sessions});

  final List<RoomSession> sessions;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final int total = sessions.length;
    final Set<String> uniqueRooms =
        sessions.map((RoomSession s) => s.roomName).toSet();

    final Map<RoomStatus, int> perStatus = <RoomStatus, int>{
      for (final RoomStatus s in RoomStatus.values) s: 0,
    };
    for (final RoomSession s in sessions) {
      perStatus[s.status] = (perStatus[s.status] ?? 0) + 1;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Ringkasan Hari Ini',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'RuangKita • M02-2097',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Divider(height: 24),
              _SummaryRow(label: 'Total kegiatan', value: '$total'),
              _SummaryRow(
                label: 'Ruang unik',
                value: '${uniqueRooms.length}',
              ),
              const Divider(height: 24),
              Text(
                'Sebaran Status',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...RoomStatus.values.map(
                (RoomStatus status) => _SummaryRow(
                  label: status.label,
                  value: '${perStatus[status] ?? 0}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.session,
    this.expand = false,
  });

  final RoomSession session;
  final bool expand;

  void _openDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return _RoomDetailSheet(session: session);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Stack(
      fit: expand ? StackFit.expand : StackFit.loose,
      children: <Widget>[
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _openDetail(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        _categoryIcon(session.category),
                        size: 18,
                        color: scheme.primary,
                      ),
                      const SizedBox(width: 6),
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
                  Text(
                    session.activityName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    session.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
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
        ),
        Positioned(
          top: 10,
          right: 10,
          child: _StatusBadge(status: session.status),
        ),
      ],
    );
  }
}

class _RoomDetailSheet extends StatefulWidget {
  const _RoomDetailSheet({required this.session});

  final RoomSession session;

  @override
  State<_RoomDetailSheet> createState() => _RoomDetailSheetState();
}

class _RoomDetailSheetState extends State<_RoomDetailSheet> {
  bool _reminderOn = false;

  @override
  Widget build(BuildContext context) {
    final RoomSession s = widget.session;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      s.roomName,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(status: s.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                s.activityName,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: _categoryIcon(s.category),
                label: 'Kategori',
                value: s.category.label,
              ),
              _DetailRow(
                icon: Icons.schedule,
                label: 'Waktu',
                value: s.timeRange,
              ),
              _DetailRow(
                icon: Icons.place_outlined,
                label: 'Lokasi',
                value: s.floor,
              ),
              _DetailRow(
                icon: Icons.people_outline,
                label: 'Kapasitas',
                value: '${s.capacity} orang',
              ),
              const Divider(height: 32),
              Text(
                'Deskripsi',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                s.description,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const Divider(height: 32),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _reminderOn,
                onChanged: (bool value) {
                  setState(() {
                    _reminderOn = value;
                  });
                },
                title: const Text('Ingatkan saya sebelum sesi dimulai'),
                subtitle: Text(
                  _reminderOn
                      ? 'Pengingat aktif untuk ${s.timeRange}.'
                      : 'Notifikasi lokal 15 menit sebelum ${s.startTime}.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

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