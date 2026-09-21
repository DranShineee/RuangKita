enum RoomStatus {
  berlangsung('Berlangsung'),
  akanDatang('Akan Datang'),
  selesai('Selesai'),
  tersedia('Tersedia');

  const RoomStatus(this.label);

  /// Label tampilan untuk UI.
  final String label;
}
    
enum RoomCategory {
  ruangRapat('Ruang Rapat'),
  ruangDiskusi('Ruang Diskusi'),
  coworking('Coworking');

  const RoomCategory(this.label);

  final String label;
}

class RoomSession {
  const RoomSession({
    required this.id,
    required this.roomName,
    required this.activityName,
    required this.description,
    required this.status,
    required this.category,
    required this.startTime,
    required this.endTime,
    required this.floor,
    required this.capacity,
  });

  /// ID unik record, mis. `RS-001`.
  final String id;

  /// Nama ruang/fasilitas.
  final String roomName;

  /// Nama kegiatan yang berlangsung di ruang tersebut.
  final String activityName;

  /// Deskripsi singkat kegiatan.
  final String description;

  /// Status penggunaan ruang pada hari ini.
  final RoomStatus status;

  /// Kategori ruang.
  final RoomCategory category;

  /// Waktu mulai dalam format HH:mm.
  final String startTime;

  /// Waktu selesai dalam format HH:mm.
  final String endTime;

  /// Lokasi lantai ruang.
  final String floor;

  /// Kapasitas maksimum ruang (orang).
  final int capacity;

  /// Helper gabungan rentang waktu, mis. "09:00 - 10:30".
  String get timeRange => '$startTime - $endTime';
}
const List<RoomSession> kDummyRoomSessions = <RoomSession>[
  RoomSession(
    id: 'RS-001',
    roomName: 'Ruang Rapat Merapi',
    activityName: 'Sprint Planning Q3 Mobile Team',
    description:
        'Perencanaan sprint kuartal ketiga untuk tim mobile, membahas prioritas fitur, target rilis, dan alokasi sumber daya tim pengembang.',
    status: RoomStatus.berlangsung,
    category: RoomCategory.ruangRapat,
    startTime: '09:00',
    endTime: '10:30',
    floor: 'Lantai 2',
    capacity: 12,
  ),
  RoomSession(
    id: 'RS-002',
    roomName: 'Ruang Rapat Rinjani',
    activityName: 'Rapat Koordinasi Evaluasi Kinerja Triwulan Ketiga',
    description:
        'Rapat koordinasi lintas divisi untuk mengevaluasi capaian kinerja triwulan ketiga serta menyusun strategi perbaikan pada kuartal berikutnya.',
    status: RoomStatus.akanDatang,
    category: RoomCategory.ruangRapat,
    startTime: '13:00',
    endTime: '15:00',
    floor: 'Lantai 3',
    capacity: 16,
  ),
  RoomSession(
    id: 'RS-003',
    roomName: 'Ruang Diskusi Semeru',
    activityName: 'Diskusi Kelompok Proyek Akhir Mahasiswa',
    description:
        'Sesi diskusi mahasiswa untuk finalisasi laporan dan persiapan sidang proyek akhir.',
    status: RoomStatus.berlangsung,
    category: RoomCategory.ruangDiskusi,
    startTime: '10:00',
    endTime: '11:30',
    floor: 'Lantai 1',
    capacity: 8,
  ),
  RoomSession(
    id: 'RS-004',
    roomName: 'Coworking Space Bromo',
    activityName: 'Sesi Kerja Mandiri Freelancer Komunitas Digital',
    description:
        'Ruang kerja bersama untuk freelancer dan komunitas digital lokal, dilengkapi koneksi internet cepat dan area duduk fleksibel.',
    status: RoomStatus.tersedia,
    category: RoomCategory.coworking,
    startTime: '08:00',
    endTime: '17:00',
    floor: 'Lantai 1',
    capacity: 24,
  ),
  RoomSession(
    id: 'RS-005',
    roomName: 'Ruang Diskusi Kelud',
    activityName: 'Review Desain UI/UX Aplikasi RuangKita',
    description:
        'Review desain antarmuka aplikasi RuangKita bersama tim produk dan calon pengguna.',
    status: RoomStatus.selesai,
    category: RoomCategory.ruangDiskusi,
    startTime: '07:30',
    endTime: '09:00',
    floor: 'Lantai 2',
    capacity: 10,
  ),
  RoomSession(
    id: 'RS-006',
    roomName: 'Ruang Rapat Merapi',
    activityName: 'Onboarding Anggota Baru Divisi Produk',
    description:
        'Pengenalan budaya kerja, tools internal, dan alur kolaborasi bagi anggota baru.',
    status: RoomStatus.selesai,
    category: RoomCategory.ruangRapat,
    startTime: '08:00',
    endTime: '09:30',
    floor: 'Lantai 2',
    capacity: 12,
  ),
  RoomSession(
    id: 'RS-007',
    roomName: 'Coworking Space Bromo',
    activityName: 'Workshop Kolaborasi Startup Lokal Banyuwangi',
    description:
        'Workshop kolaborasi antar startup lokal untuk berbagi praktik terbaik dan peluang kemitraan.',
    status: RoomStatus.akanDatang,
    category: RoomCategory.coworking,
    startTime: '15:30',
    endTime: '17:30',
    floor: 'Lantai 1',
    capacity: 24,
  ),
  RoomSession(
    id: 'RS-008',
    roomName: 'Ruang Diskusi Semeru',
    activityName: 'Sharing Session Teknologi Cloud dan DevOps',
    description:
        'Berbagi pengalaman migrasi layanan ke cloud dan penerapan pipeline DevOps di tim kecil.',
    status: RoomStatus.tersedia,
    category: RoomCategory.ruangDiskusi,
    startTime: '16:00',
    endTime: '18:00',
    floor: 'Lantai 1',
    capacity: 8,
  ),
];