import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E90FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E90FF),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> todoList = [];
  final TextEditingController _controller = TextEditingController();
  int updateIndex = -1;

  static const Color dodgerBlue = Color(0xFF1E90FF);
  static const Color lightBlue = Color(0xFFE8F4FF);
  static const Color darkBlue = Color(0xFF1565C0);

  void addList(String task) {
    if (task.trim().isEmpty) return;
    setState(() {
      todoList.add(task.trim());
      _controller.clear();
    });
  }

  void updateListItem(String task, int index) {
    if (task.trim().isEmpty) return;
    setState(() {
      todoList[index] = task.trim();
      updateIndex = -1;
      _controller.clear();
    });
  }

  void deleteItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF1E90FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
            SizedBox(width: 10),
            Text(
              "MyTasks",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${todoList.length} tasks",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top decorative wave container
          Container(
            height: 16,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF1E90FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Task list
          Expanded(
            child: todoList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 72, color: dodgerBlue.withOpacity(0.3)),
                        const SizedBox(height: 12),
                        Text(
                          "No tasks yet!",
                          style: TextStyle(
                            fontSize: 18,
                            color: dodgerBlue.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Add something below to get started.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      final isEditing = updateIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: isEditing ? lightBlue : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isEditing
                                ? dodgerBlue
                                : Colors.blue.withOpacity(0.15),
                            width: isEditing ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: dodgerBlue.withOpacity(0.07),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: lightBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                  color: dodgerBlue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            todoList[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ActionButton(
                                icon: Icons.edit_outlined,
                                color: dodgerBlue,
                                bgColor: lightBlue,
                                onTap: () {
                                  setState(() {
                                    _controller.text = todoList[index];
                                    updateIndex = index;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              _ActionButton(
                                icon: Icons.delete_outline,
                                color: const Color(0xFFE53935),
                                bgColor: const Color(0xFFFFEBEE),
                                onTap: () => deleteItem(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: dodgerBlue.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1A1A2E),
                    ),
                    decoration: InputDecoration(
                      hintText: updateIndex != -1
                          ? 'Edit task...'
                          : 'Add a new task...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        updateIndex != -1
                            ? Icons.edit_outlined
                            : Icons.add_task,
                        color: dodgerBlue,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: lightBlue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: dodgerBlue, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                    ),
                    onSubmitted: (val) => updateIndex != -1
                        ? updateListItem(val, updateIndex)
                        : addList(val),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => updateIndex != -1
                      ? updateListItem(_controller.text, updateIndex)
                      : addList(_controller.text),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF1E90FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: dodgerBlue.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      updateIndex != -1 ? Icons.check_rounded : Icons.add_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}