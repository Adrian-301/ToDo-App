// ═══════════════════════════════════════════════════════════════════════════════
//  main.dart
//  Menampung: MyApp, HomeScreen
//  Mengimpor: task.dart, schedule.dart, login.dart
// ═══════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';
import 'task.dart';
import 'schedule.dart';

void main() {
  // ── Untuk mengaktifkan Firebase, tambahkan baris berikut: ──────────────────
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   Kemudian ubah main() menjadi async.
  // ───────────────────────────────────────────────────────────────────────────
  runApp(const MyApp());
}

// ─────────────────────────────────────────────────────────────────────────────
//  APP ROOT
// ─────────────────────────────────────────────────────────────────────────────

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kDodgerBlue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kDodgerBlue,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  HOME / DASHBOARD
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── State lokal (ganti dengan stream Firestore setelah integrasi DB) ────────
  final List<TaskModel>     _tasks     = [];
  final List<ScheduleModel> _schedules = [];

  // ── Timer untuk deteksi overdue otomatis ────────────────────────────────────
  // Setiap menit, setState dipanggil agar isOverdue() dievaluasi ulang.
  // Dengan begitu, task yang tepat mencapai jatuh temponya akan langsung
  // menampilkan silang merah tanpa perlu interaksi dari user.
  late final Timer _overdueTimer;

  @override
  void initState() {
    super.initState();
    _overdueTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) { if (mounted) setState(() {}); },
    );
  }

  @override
  void dispose() {
    _overdueTimer.cancel();
    super.dispose();
  }

  // ── Logout ──────────────────────────────────────────────────────────────────

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: kDodgerBlue),
            SizedBox(width: 10),
            Text('Logout'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDodgerBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      // ── Untuk Firebase Auth: await FirebaseAuth.instance.signOut(); ─────────
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    }
  }

  // ── CRUD Task ───────────────────────────────────────────────────────────────

  void _toggleTask(TaskModel task) {
    // ── Untuk Firestore: ────────────────────────────────────────────────────
    //   FirebaseFirestore.instance
    //       .collection('users').doc(task.userId)
    //       .collection('tasks').doc(task.id)
    //       .update({'isDone': !task.isDone});
    final idx = _tasks.indexOf(task);
    if (idx == -1) return;
    setState(() => _tasks[idx] = task.copyWith(isDone: !task.isDone));
  }

  void _deleteTask(TaskModel task) {
    // ── Untuk Firestore: ────────────────────────────────────────────────────
    //   FirebaseFirestore.instance
    //       .collection('users').doc(task.userId)
    //       .collection('tasks').doc(task.id)
    //       .delete();
    setState(() => _tasks.remove(task));
  }

  void _openTaskSheet({TaskModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskBottomSheet(
        existing: existing,
        onSave: (task) {
          // ── Untuk Firestore: ──────────────────────────────────────────────
          //   final ref = FirebaseFirestore.instance
          //       .collection('users').doc(task.userId)
          //       .collection('tasks');
          //   if (task.id.isEmpty) {
          //     ref.add(task.toMap());
          //   } else {
          //     ref.doc(task.id).set(task.toMap());
          //   }
          setState(() {
            if (existing != null) {
              final idx = _tasks.indexOf(existing);
              if (idx != -1) _tasks[idx] = task;
            } else {
              _tasks.add(task);
            }
          });
        },
      ),
    );
  }

  // ── CRUD Schedule ───────────────────────────────────────────────────────────

  void _deleteSchedule(ScheduleModel s) {
    // ── Untuk Firestore: ────────────────────────────────────────────────────
    //   FirebaseFirestore.instance
    //       .collection('users').doc(s.userId)
    //       .collection('schedules').doc(s.id)
    //       .delete();
    setState(() => _schedules.remove(s));
  }

  void _openScheduleSheet({ScheduleModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ScheduleBottomSheet(
        existing: existing,
        onSave: (s) {
          // ── Untuk Firestore: ──────────────────────────────────────────────
          //   final ref = FirebaseFirestore.instance
          //       .collection('users').doc(s.userId)
          //       .collection('schedules');
          //   if (s.id.isEmpty) {
          //     ref.add(s.toMap());
          //   } else {
          //     ref.doc(s.id).set(s.toMap());
          //   }
          setState(() {
            if (existing != null) {
              final idx = _schedules.indexOf(existing);
              if (idx != -1) _schedules[idx] = s;
            } else {
              _schedules.add(s);
            }
          });
        },
      ),
    );
  }

  // ── FAB: pilih tipe item baru ────────────────────────────────────────────────

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Tambah Apa?',
              style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Task
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _openTaskSheet();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: kLightBlue,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: kDodgerBlue.withOpacity(0.3)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.task_alt_outlined,
                              color: kDodgerBlue, size: 32),
                          SizedBox(height: 8),
                          Text(
                            'Task',
                            style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600,
                              color: kDodgerBlue,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Satu kali, ada jatuh tempo',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Jadwal
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _openScheduleSheet();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: kLightBlue,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: kDodgerBlue.withOpacity(0.3)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.calendar_month_outlined,
                              color: kDodgerBlue, size: 32),
                          SizedBox(height: 8),
                          Text(
                            'Jadwal',
                            style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600,
                              color: kDodgerBlue,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Berulang, pilih hari & jam',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── BUILD ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final total = _tasks.length + _schedules.length;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F7FF),

        // ── AppBar ──────────────────────────────────────────────────────────
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [kDarkBlue, kDodgerBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle_outline,
                  color: Colors.white, size: 26),
              SizedBox(width: 8),
              Text(
                'MyTasks',
                style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 22,
                  color: Colors.white, letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$total item',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Logout',
            ),
          ],
        ),

        // ── Body ────────────────────────────────────────────────────────────
        body: Column(
          children: [
            Container(
              height: 16,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kDarkBlue, kDodgerBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            Expanded(
              child: (_tasks.isEmpty && _schedules.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 72,
                              color: kDodgerBlue.withOpacity(0.3)),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada item!',
                            style: TextStyle(
                              fontSize: 18,
                              color: kDodgerBlue.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ketuk tombol + di bawah untuk menambahkan.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding:
                          const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      children: [
                        // ── Seksi TASK ────────────────────────────────
                        if (_tasks.isNotEmpty) ...[
                          SectionHeader(
                            icon: Icons.task_alt_outlined,
                            label: 'Task',
                            color: kDodgerBlue,
                            count: _tasks.length,
                          ),
                          const SizedBox(height: 8),
                          ..._tasks.map((task) => TaskCard(
                                task: task,
                                onToggle: () => _toggleTask(task),
                                onEdit: () =>
                                    _openTaskSheet(existing: task),
                                onDelete: () => _deleteTask(task),
                              )),
                          const SizedBox(height: 16),
                        ],

                        // ── Seksi JADWAL ──────────────────────────────
                        if (_schedules.isNotEmpty) ...[
                          SectionHeader(
                            icon: Icons.calendar_month_outlined,
                            label: 'Jadwal',
                            color: kDodgerBlue,
                            count: _schedules.length,
                          ),
                          const SizedBox(height: 8),
                          ..._schedules.map((s) => ScheduleCard(
                                schedule: s,
                                onEdit: () =>
                                    _openScheduleSheet(existing: s),
                                onDelete: () => _deleteSchedule(s),
                              )),
                        ],
                      ],
                    ),
            ),
          ],
        ),

        // ── FAB ─────────────────────────────────────────────────────────────
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddOptions,
          backgroundColor: kDodgerBlue,
          elevation: 6,
          child: const Icon(Icons.add_rounded,
              color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
