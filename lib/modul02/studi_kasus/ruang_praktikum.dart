// lib/modul02/studi_kasus/ruang_praktikum.dart

import 'package:flutter/material.dart';

import '../../../models/room_session.dart';

/// Screen studi kasus "RuangKita - Dashboard Ketersediaan Ruang".
///
/// Sesi 3 fokus:
/// - Memakai `LayoutBuilder` untuk memutuskan layout berdasarkan
///   `constraints.maxWidth` (bukan MediaQuery).
/// - Compact  (< 600 dp)  : 1 kolom vertikal.
/// - Medium   (600-839 dp): grid 2 kolom.
/// - Expanded (>= 840 dp) : 2 kolom + panel ringkasan.
///
/// Filter (ChoiceChip) dan tema gelap akan ditambahkan pada sesi berikutnya.
class RuangPraktikumScreen extends StatefulWidget {
  const RuangPraktikumScreen({super.key});

  @override
  State<RuangPraktikumScreen> createState() => _RuangPraktikumScreenState();
}

class _RuangPraktikumScreenState extends State<RuangPraktikumScreen> {
  /// Filter status. `null` berarti tampilkan semua.
  ///
  /// Pada Sesi 3 nilai ini belum diubah oleh UI apa pun; ChoiceChip
  /// filter ditambahkan pada Sesi 4.
  RoomStatus? _selectedStatus;

  /// Daftar sesi yang ditampilkan setelah difilter.
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
      // LayoutBuilder membaca lebar parent (Scaffold body), bukan lebar
      // layar global. Karena body mengisi seluruh lebar layar pada
      // halaman ini, hasilnya sama dengan lebar viewport — tapi tetap
      // benar secara prinsip "constraints go down".
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double maxWidth = constraints.maxWidth;

          if (maxWidth < 600) {
            return const _CompactLayout();
          } else if (maxWidth < 840) {
            return const _MediumLayout();
          } else {
            return const _ExpandedLayout();
          }
        },
      ),
    );
  }
}

// =====================================================================
// Compact layout — 1 kolom vertikal untuk width < 600 dp.
// =====================================================================

class _CompactLayout extends StatelessWidget {
  const _CompactLayout();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: kDummyRoomSessions.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        return _RoomCard(session: kDummyRoomSessions[index]);
      },
    );
  }
}

// =====================================================================
// Medium layout — grid 2 kolom untuk width 600-839 dp.
// =====================================================================

class _MediumLayout extends StatelessWidget {
  const _MediumLayout();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _RoomGrid(
        sessions: kDummyRoomSessions,
        crossAxisCount: 2,
      ),
    );
  }
}

// =====================================================================
// Expanded layout — 2 kolom + panel ringkasan untuk width >= 840 dp.
// =====================================================================

class _ExpandedLayout extends StatelessWidget {
  const _ExpandedLayout();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Area konten: grid 2 kolom.
          Expanded(
            flex: 3,
            child: _RoomGrid(
              sessions: kDummyRoomSessions,
              crossAxisCount: 2,
            ),
          ),
          const SizedBox(width: 16),
          // Panel ringkasan: memanfaatkan ruang ekstra pada layar lebar.
          const Expanded(
            flex: 2,
            child: _SummaryPanel(sessions: kDummyRoomSessions),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Grid helper — dipakai oleh medium dan expanded.
// =====================================================================

class _RoomGrid extends StatelessWidget {
  const _RoomGrid({
    required this.sessions,
    required this.crossAxisCount,
  });

  final List<RoomSession> sessions;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // Tinggi cell dibuat seragam agar baris grid rapi. Nilai ini
        // diuji pada Sesi 5 (teks panjang + text scale besar); kalau
        // overflow, mainAxisExtent akan dinaikkan.
        mainAxisExtent: 224,
      ),
      itemCount: sessions.length,
      itemBuilder: (BuildContext context, int index) {
        // expand: true → Stack memakai StackFit.expand supaya card
        // mengisi seluruh cell grid.
        return _RoomCard(session: sessions[index], expand: true);
      },
    );
  }
}

// =====================================================================
// Panel ringkasan — hanya muncul di expanded.
// =====================================================================

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.sessions});

  final List<RoomSession> sessions;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Statistik dasar.
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
          // Expanded memberi batas lebar untuk label supaya
          // label panjang tidak mendorong angka keluar layar.
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

// =====================================================================
// Card — sama seperti Sesi 2, hanya ditambah parameter `expand`.
// =====================================================================

/// Card satu sesi ruang.
///
/// Struktur ringkas:
/// Stack
/// ├─ Card → Padding → Column
/// │  ├─ Row (ikon kategori + Expanded nama ruang)
/// │  ├─ Text nama kegiatan (maxLines 2)
/// │  ├─ Text deskripsi (maxLines 2)
/// │  └─ Row (waktu + kapasitas, memakai Flexible)
/// └─ Positioned (badge status di kanan atas)
class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.session,
    this.expand = false,
  });

  final RoomSession session;

  /// Kalau true, Stack memakai `StackFit.expand` sehingga card mengisi
  /// seluruh slot tempatnya (dipakai di GridView).
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Stack(
      fit: expand ? StackFit.expand : StackFit.loose,
      children: <Widget>[
        Card(
          clipBehavior: Clip.antiAlias,
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
        Positioned(
          top: 10,
          right: 10,
          child: _StatusBadge(status: session.status),
        ),
      ],
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