# AI_USAGE.md

Nama : Khairan Adiokta Arun Nugraha  
NIM  : 362558302097  
Kode : M02-2097

---

## Alat AI yang dipakai

Saya menggunakan Chat AI dari Chatgpt, Claude, Gemini, dan DeepSeek. 
Biasanya saya membandingkan banyak ai dengan 1 prompt yang sama dan ai mana yang paling lama limitnya.
Dominan saya menggunakan Chatgpt dan DeepSeek untuk memperbaiki code.
Namun karena Chatgpt mudah limit, Saya lebih sering mengexecuted memakai DeepSeek.

## Tujuan pemakaian

- Prompting konsep: bedanya `Expanded` dengan `Flexible`, kapan memakai
  `LayoutBuilder` vs `MediaQuery`, bagaimana cara kerja `setState`.
- Minta review kode yang usdah saya tulis: cek potensi overflow,
  cek konsistensi pemakaian `const`.
- Debugging: waktu muncul warning `unused_local_variable` dan
  RenderFlex overflow ketika text scale 1.5x, saya prompt untuk cari
  akar masalahnya.

## Ringkasan prompt

Contoh prompt yang saya gunakan:

- "ini error kenapa  
PS C:\Users\secre\OneDrive\Dokumen\POLIWANGI\Semester 3\Pemrograman Perangkat Bergerak\02-week-2-declarative-ui-responsive-layout> flutter analyze 
Analyzing 02-week-2-declarative-ui-responsive-layout...                 

  error - The name 'MyApp' isn't a class - test\widget_test.dart:16:35 - creation_with_non_type

1 issue found. (ran in 3.5s)"
- "ini kenapa  
PS C:\Flutter\02-week-2-declarative-ui-responsive-layout> flutter analyze                                                      
Analyzing 02-week-2-declarative-ui-responsive-layout...                 

warning - The value of the local variable 'sessions' isn't used - lib\modul02\studi_kasus\ruang_praktikum.dart:42:29 - unused_local_variable

1 issue found. (ran in 4.4s)
PS C:\Flutter\02-week-2-declarative-ui-responsive-layout>"
- "teks scale ini apa"
- "cara agar tulisan nya tidak menyamping, melainkan urut ke bawah"
- "kenapa foto nya tidak mau muncul di github"
- "bedanya Expanded sama Flexible di Row apa? Kasih contoh"
- "muncul warning unused_local_variable sessions di flutter analyze.
  Ini kenapa dan gimana fix-nya tanpa ngerusak yang lain?"
- "layoutBuilder lebih tepat dari MediaQuery buat kasus apa?"

## Bagian kode yang terpengaruh

- **Layout responsif** di `ruang_praktikum.dart`: struktur
  `LayoutBuilder` + tiga layout.  
- **Fix overflow** di `_RoomGrid`: solusi `MediaQuery.textScalerOf`
  + clamp `[1.0, 1.6]`.  
- **Pemakaian `maxLines` + `TextOverflow.ellipsis`**.  

## Yang saya ubah setelah menerima saran

- Saran awal memakai `MediaQuery.size.width` buat breakpoint. Saya ganti
  ke `LayoutBuilder` + `constraints.maxWidth` karena lebih tepat
  secara prinsip dan sesuai ketentuan modul.
- Saran awal buat overflow yaitu untuk mengurangi `maxLines`. saya biarkan
  karena modul bilang jangan hapus info penting. Akhirnya memakai
  `mainAxisExtent` dinamis yang tetap menampilkan semua teks.
- saya tambahkan `_EmptyState` waktu filter kosong — yang disarankan ai.
- Struktur `Stack + Positioned` untuk badge dan `_SummaryPanel` saya tambahkan berdasarkan saran ai.

## Catatan

Mostly kode yang ada di sini saya prompt dengan bantuan ai, 
tetapi saya juga berusaha untuk memahaminya meskipun masih belum paham.