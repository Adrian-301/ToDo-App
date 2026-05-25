// ═══════════════════════════════════════════════════════════════════════════════
//  task.dart
//  Menampung: TaskModel, TaskCard, TaskBottomSheet, StatusBadge, ActionButton
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  KONSTANTA WARNA BERSAMA
// ─────────────────────────────────────────────────────────────────────────────

const Color kDodgerBlue = Color(0xFF1E90FF);
const Color kLightBlue  = Color(0xFFE8F4FF);
const Color kDarkBlue   = Color(0xFF1565C0);

// ─────────────────────────────────────────────────────────────────────────────
//  MODEL
// ─────────────────────────────────────────────────────────────────────────────

/// Task biasa: mempunyai tanggal + jam jatuh tempo, bisa dicentang ✓/✗.
class TaskModel {
  /// ID dokumen Firestore (kosong sebelum disimpan ke DB).
  String id;

  /// ID user pemilik task — diisi dari FirebaseAuth.currentUser!.uid.
  String userId;

  String title;
  String description;
  bool isDone;

  /// Tanggal + jam jatuh tempo (timezone lokal device).
  DateTime dueDate;

  TaskModel({
    this.id = '',
    this.userId = '',
    required this.title,
    this.description = '',
    this.isDone = false,
    required this.dueDate,
  });

  // ── Firestore serialisation ────────────────────────────────────────────────

  /// Simpan ke Firestore:
  ///   await FirebaseFirestore.instance
  ///       .collection('users')
  ///       .doc(userId)
  ///       .collection('tasks')
  ///       .doc(id.isEmpty ? null : id)
  ///       .set(task.toMap());
  Map<String, dynamic> toMap() => {
        'userId': userId,
        'title': title,
        'description': description,
        'isDone': isDone,
        'dueDate': dueDate.toIso8601String(),
      };

  /// Baca dari Firestore DocumentSnapshot:
  ///   TaskModel.fromMap(doc.id, doc.data()!)
  factory TaskModel.fromMap(String docId, Map<String, dynamic> map) =>
      TaskModel(
        id: docId,
        userId: (map['userId'] as String?) ?? '',
        title: map['title'] as String,
        description: (map['description'] as String?) ?? '',
        isDone: (map['isDone'] as bool?) ?? false,
        dueDate: DateTime.parse(map['dueDate'] as String),
      );

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    bool? isDone,
    DateTime? dueDate,
  }) =>
      TaskModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description ?? this.description,
        isDone: isDone ?? this.isDone,
        dueDate: dueDate ?? this.dueDate,
      );

  // ── Status helpers ─────────────────────────────────────────────────────────

  bool isOverdue() => !isDone && dueDate.isBefore(DateTime.now());

  /// Task "final" = selesai atau sudah lewat jatuh tempo → tombol edit hilang.
  bool isFinal() => isDone || isOverdue();

  // ── Format helpers ─────────────────────────────────────────────────────────

  static String formatDateTime(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year}  •  $h:$m';
  }

  static String formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  static String formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

// ─────────────────────────────────────────────────────────────────────────────
//  TASK CARD
// ─────────────────────────────────────────────────────────────────────────────

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final overdue = task.isOverdue();
    final done = task.isDone;
    final isFinal = task.isFinal();

    final borderColor = done
        ? const Color(0xFF43A047).withOpacity(0.4)
        : overdue
            ? const Color(0xFFE53935).withOpacity(0.5)
            : kDodgerBlue.withOpacity(0.15);

    final cardColor = done
        ? const Color(0xFFF1FFF3)
        : overdue
            ? const Color(0xFFFFF5F5)
            : Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
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

        // ── Lingkaran status ──────────────────────
        leading: GestureDetector(
          onTap: isFinal ? null : onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: done
                  ? const Color(0xFFE8F5E9)
                  : overdue
                      ? const Color(0xFFFFEBEE)
                      : kLightBlue,
              shape: BoxShape.circle,
              border: Border.all(
                color: done
                    ? const Color(0xFF43A047)
                    : overdue
                        ? const Color(0xFFE53935)
                        : kDodgerBlue.withOpacity(0.4),
                width: 1.8,
              ),
            ),
            child: done
                ? const Icon(Icons.check_rounded,
                    color: Color(0xFF43A047), size: 20)
                : overdue
                    ? const Icon(Icons.close_rounded,
                        color: Color(0xFFE53935), size: 20)
                    : null,
          ),
        ),

        // ── Judul + Deskripsi + Waktu ─────────────
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: done
                ? Colors.grey.shade400
                : overdue
                    ? const Color(0xFFB71C1C)
                    : const Color(0xFF1A1A2E),
            decoration: done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                task.description,
                style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 11,
                  color: overdue
                      ? const Color(0xFFE53935)
                      : Colors.grey.shade400,
                ),
                const SizedBox(width: 3),
                Text(
                  TaskModel.formatDateTime(task.dueDate),
                  style: TextStyle(
                    fontSize: 11,
                    color: overdue
                        ? const Color(0xFFE53935)
                        : Colors.grey.shade400,
                    fontWeight:
                        overdue ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            if (done)
              const StatusBadge(
                label: '✓ Selesai',
                textColor: Color(0xFF43A047),
                bgColor: Color(0xFFE8F5E9),
              )
            else if (overdue)
              const StatusBadge(
                label: '✗ Terlewat',
                textColor: Color(0xFFE53935),
                bgColor: Color(0xFFFFEBEE),
              ),
          ],
        ),

        // ── Tombol aksi ───────────────────────────
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isFinal) ...[
              ActionButton(
                icon: Icons.edit_outlined,
                color: kDodgerBlue,
                bgColor: kLightBlue,
                onTap: onEdit,
              ),
              const SizedBox(width: 6),
            ],
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
//  TASK BOTTOM SHEET (form tambah / edit task)
// ─────────────────────────────────────────────────────────────────────────────

class TaskBottomSheet extends StatefulWidget {
  final TaskModel? existing;
  final void Function(TaskModel) onSave;

  const TaskBottomSheet({super.key, this.existing, required this.onSave});

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  DateTime  _dueDate = DateTime.now();
  TimeOfDay _dueTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final t = widget.existing!;
      _titleCtrl.text = t.title;
      _descCtrl.text  = t.description;
      _dueDate = t.dueDate;
      _dueTime = TimeOfDay(hour: t.dueDate.hour, minute: t.dueDate.minute);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: kDodgerBlue)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: kDodgerBlue)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueTime = picked);
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tidak boleh kosong.')),
      );
      return;
    }
    final combined = DateTime(
      _dueDate.year, _dueDate.month, _dueDate.day,
      _dueTime.hour, _dueTime.minute,
    );
    final task = TaskModel(
      id: widget.existing?.id ?? '',
      userId: widget.existing?.userId ?? '',
      title: title,
      description: _descCtrl.text.trim(),
      isDone: widget.existing?.isDone ?? false,
      dueDate: combined,
    );
    Navigator.pop(context);
    widget.onSave(task);
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
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [kDarkBlue, kDodgerBlue]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_task, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    widget.existing != null ? 'Edit Task' : 'Tambah Task Baru',
                    style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Judul
            _FormLabel('Judul'),
            const SizedBox(height: 6),
            _buildInput(_titleCtrl, 'Masukkan judul task...', Icons.title),

            const SizedBox(height: 14),

            // Deskripsi
            _FormLabel('Deskripsi'),
            const SizedBox(height: 6),
            _buildInput(_descCtrl, 'Deskripsi singkat (opsional)...', Icons.notes,
                maxLines: 2),

            const SizedBox(height: 14),

            // Tanggal & Jam Jatuh Tempo
            _FormLabel('Tanggal & Jam Jatuh Tempo'),
            const SizedBox(height: 8),
            Row(
              children: [
                // Tanggal
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: _pickerBox(
                      child: Row(children: [
                        const Icon(Icons.calendar_today_outlined,
                            color: kDodgerBlue, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            TaskModel.formatDate(_dueDate),
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF1A1A2E)),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Jam
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _pickTime,
                    child: _pickerBox(
                      child: Row(children: [
                        const Icon(Icons.access_time_rounded,
                            color: kDodgerBlue, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          TaskModel.formatTime(_dueTime),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1A1A2E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
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
                  gradient: const LinearGradient(colors: [kDarkBlue, kDodgerBlue]),
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
                    widget.existing != null ? 'SIMPAN PERUBAHAN' : 'TAMBAH TASK',
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

  Widget _buildInput(
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
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(icon, color: kDodgerBlue, size: 20),
          filled: true,
          fillColor: kLightBlue,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kDodgerBlue, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      );

  Widget _pickerBox({required Widget child}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: kLightBlue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
//  WIDGET PEMBANTU (dipakai oleh task.dart maupun schedule.dart)
// ─────────────────────────────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color bgColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.textColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10, color: textColor, fontWeight: FontWeight.w600,
          ),
        ),
      );
}

class InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const InfoBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
      );
}

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int count;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700,
              color: color, letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: color),
            ),
          ),
        ],
      );
}

// Widget label form kecil (dipakai secara internal di file ini)
class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E),
        ),
      );
}
