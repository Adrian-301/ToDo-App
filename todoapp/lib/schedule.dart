// ═══════════════════════════════════════════════════════════════════════════════
//  schedule.dart
//  Menampung: ScheduleModel, ScheduleCard, ScheduleBottomSheet
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'task.dart'; // menggunakan konstanta warna & widget bersama

// ─────────────────────────────────────────────────────────────────────────────
//  MODEL
// ─────────────────────────────────────────────────────────────────────────────

/// Jadwal berulang: memiliki hari-hari tertentu dan rentang jam.
/// Tidak memiliki tanggal jatuh tempo dan tidak bisa dicentang selesai.
class ScheduleModel {
  /// ID dokumen Firestore (kosong sebelum disimpan ke DB).
  String id;

  /// ID user pemilik jadwal — diisi dari FirebaseAuth.currentUser!.uid.
  String userId;

  String title;
  String description;

  /// Hari yang dipilih: 1=Senin … 7=Minggu.
  List<int> repeatDays;

  /// Jam mulai dalam menit dari tengah malam (0–1439).
  int startMinutes;

  /// Jam selesai dalam menit dari tengah malam (0–1439).
  int endMinutes;

  ScheduleModel({
    this.id = '',
    this.userId = '',
    required this.title,
    this.description = '',
    required this.repeatDays,
    required this.startMinutes,
    required this.endMinutes,
  });

  // ── Firestore serialisation ────────────────────────────────────────────────

  /// Simpan ke Firestore:
  ///   await FirebaseFirestore.instance
  ///       .collection('users')
  ///       .doc(userId)
  ///       .collection('schedules')
  ///       .doc(id.isEmpty ? null : id)
  ///       .set(schedule.toMap());
  Map<String, dynamic> toMap() => {
        'userId': userId,
        'title': title,
        'description': description,
        'repeatDays': repeatDays,
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
      };

  /// Baca dari Firestore DocumentSnapshot:
  ///   ScheduleModel.fromMap(doc.id, doc.data()!)
  factory ScheduleModel.fromMap(String docId, Map<String, dynamic> map) =>
      ScheduleModel(
        id: docId,
        userId: (map['userId'] as String?) ?? '',
        title: map['title'] as String,
        description: (map['description'] as String?) ?? '',
        repeatDays: List<int>.from((map['repeatDays'] as List?) ?? []),
        startMinutes: (map['startMinutes'] as int?) ?? 0,
        endMinutes: (map['endMinutes'] as int?) ?? 60,
      );

  ScheduleModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    List<int>? repeatDays,
    int? startMinutes,
    int? endMinutes,
  }) =>
      ScheduleModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description ?? this.description,
        repeatDays: repeatDays ?? List.from(this.repeatDays),
        startMinutes: startMinutes ?? this.startMinutes,
        endMinutes: endMinutes ?? this.endMinutes,
      );

  // ── Format helpers ─────────────────────────────────────────────────────────

  static String minutesToLabel(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  static int timeOfDayToMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  static TimeOfDay minutesToTimeOfDay(int minutes) =>
      TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

  String get dayLabel {
    const names = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final sorted = List<int>.from(repeatDays)..sort();
    return sorted.map((d) => names[d - 1]).join(' · ');
  }

  String get timeLabel =>
      '${minutesToLabel(startMinutes)} – ${minutesToLabel(endMinutes)}';
}

// ─────────────────────────────────────────────────────────────────────────────
//  SCHEDULE CARD
// ─────────────────────────────────────────────────────────────────────────────

class ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDodgerBlue.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: kDodgerBlue.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),

        // ── Ikon berulang ────────────────────────
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: kLightBlue,
            shape: BoxShape.circle,
            border: Border.all(
                color: kDodgerBlue.withOpacity(0.4), width: 1.8),
          ),
          child: const Icon(Icons.repeat_rounded,
              color: kDodgerBlue, size: 20),
        ),

        // ── Judul + Deskripsi + Badge ────────────
        title: Text(
          schedule.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (schedule.description.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                schedule.description,
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (schedule.dayLabel.isNotEmpty)
                  InfoBadge(
                    icon: Icons.repeat_rounded,
                    label: schedule.dayLabel,
                    color: kDodgerBlue,
                    bgColor: kLightBlue,
                  ),
                if (schedule.timeLabel.isNotEmpty)
                  InfoBadge(
                    icon: Icons.access_time_rounded,
                    label: schedule.timeLabel,
                    color: kDodgerBlue,
                    bgColor: kLightBlue,
                  ),
              ],
            ),
          ],
        ),

        // ── Tombol aksi (edit selalu aktif) ──────
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionButton(
              icon: Icons.edit_outlined,
              color: kDodgerBlue,
              bgColor: kLightBlue,
              onTap: onEdit,
            ),
            const SizedBox(width: 6),
            ActionButton(
              icon: Icons.delete_outline,
              color: const Color(0xFFE53935),
              bgColor: const Color(0xFFFFEBEE),
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SCHEDULE BOTTOM SHEET (form tambah / edit jadwal)
// ─────────────────────────────────────────────────────────────────────────────

class ScheduleBottomSheet extends StatefulWidget {
  final ScheduleModel? existing;
  final void Function(ScheduleModel) onSave;

  const ScheduleBottomSheet({super.key, this.existing, required this.onSave});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  final Set<int> _days = {};
  TimeOfDay _start = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _end   = const TimeOfDay(hour: 9, minute: 0);

  static const _dayLabels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final s = widget.existing!;
      _titleCtrl.text = s.title;
      _descCtrl.text  = s.description;
      _days.addAll(s.repeatDays);
      _start = ScheduleModel.minutesToTimeOfDay(s.startMinutes);
      _end   = ScheduleModel.minutesToTimeOfDay(s.endMinutes);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickStart() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _start,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: kDodgerBlue)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _start = picked);
  }

  Future<void> _pickEnd() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _end,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: kDodgerBlue)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _end = picked);
  }

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _save() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tidak boleh kosong.')),
      );
      return;
    }
    if (_days.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Pilih minimal satu hari pengulangan.')),
      );
      return;
    }
    final schedule = ScheduleModel(
      id: widget.existing?.id ?? '',
      userId: widget.existing?.userId ?? '',
      title: title,
      description: _descCtrl.text.trim(),
      repeatDays: List<int>.from(_days),
      startMinutes: ScheduleModel.timeOfDayToMinutes(_start),
      endMinutes: ScheduleModel.timeOfDayToMinutes(_end),
    );
    Navigator.pop(context);
    widget.onSave(schedule);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [kDarkBlue, kDodgerBlue]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined,
                      color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    widget.existing != null
                        ? 'Edit Jadwal'
                        : 'Tambah Jadwal Baru',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Judul
            _label('Judul Jadwal'),
            const SizedBox(height: 6),
            _input(_titleCtrl, 'Nama jadwal...', Icons.title),

            const SizedBox(height: 14),

            // Deskripsi
            _label('Deskripsi'),
            const SizedBox(height: 6),
            _input(_descCtrl, 'Deskripsi singkat (opsional)...',
                Icons.notes, maxLines: 2),

            const SizedBox(height: 14),

            // Hari pengulangan
            _label('Hari Pengulangan'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (i) {
                final day = i + 1;
                final selected = _days.contains(day);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (selected) {
                      _days.remove(day);
                    } else {
                      _days.add(day);
                    }
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: selected ? kDodgerBlue : kLightBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? kDarkBlue
                            : kDodgerBlue.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _dayLabels[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : kDodgerBlue,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 14),

            // Rentang jam
            _label('Rentang Jam'),
            const SizedBox(height: 8),
            Row(
              children: [
                // Jam Mulai
                Expanded(
                  child: GestureDetector(
                    onTap: _pickStart,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 13),
                      decoration: BoxDecoration(
                        color: kLightBlue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mulai',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500)),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.play_arrow_rounded,
                                  color: kDodgerBlue, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                _fmt(_start),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Separator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      width: 20, height: 2,
                      color: kDodgerBlue.withOpacity(0.4)),
                ),
                // Jam Selesai
                Expanded(
                  child: GestureDetector(
                    onTap: _pickEnd,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 13),
                      decoration: BoxDecoration(
                        color: kLightBlue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selesai',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500)),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.stop_rounded,
                                  color: kDodgerBlue, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                _fmt(_end),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tombol Simpan
            GestureDetector(
              onTap: _save,
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [kDarkBlue, kDodgerBlue]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: kDodgerBlue.withOpacity(0.35),
                      blurRadius: 10, offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.existing != null
                        ? 'SIMPAN PERUBAHAN'
                        : 'TAMBAH JADWAL',
                    style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,
                      fontSize: 15, letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A2E),
        ),
      );

  Widget _input(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    int maxLines = 1,
  }) =>
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(icon, color: kDodgerBlue, size: 20),
          filled: true,
          fillColor: kLightBlue,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: kDodgerBlue, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
              vertical: 14, horizontal: 16),
        ),
      );
}
