import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/academic_engine.dart';

class SimulationStudioScreen extends StatefulWidget {
  final String? initialCourseId;
  final Function({
    required String courseId,
    required String action,
    String? topicId,
    String? newTopicName,
    double? newTopicWeeks,
    int? practicalMarks,
    String? facultyReason,
  }) onRunSimulation;

  const SimulationStudioScreen({
    super.key,
    this.initialCourseId,
    required this.onRunSimulation,
  });

  @override
  State<SimulationStudioScreen> createState() => _SimulationStudioScreenState();
}

class _SimulationStudioScreenState extends State<SimulationStudioScreen> {
  late String _selectedCourseId;
  String _action = "REMOVE_TOPIC";
  String? _selectedTopicId;
  final TextEditingController _newTopicController = TextEditingController();
  double _newTopicWeeks = 2.0;
  int _practicalMarks = 25;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCourseId = widget.initialCourseId ?? "CSE-207";
    _updateDefaultTopic();
  }

  void _updateDefaultTopic() {
    final course = AcademicEngine.getCourse(_selectedCourseId);
    if (_selectedCourseId == "CSE-207") {
      _selectedTopicId = "DS-6"; // Default to Graph Algorithms for demo
    } else if (course.topics.isNotEmpty) {
      _selectedTopicId = course.topics.first.id;
    }
  }

  void _loadPreset(int presetNum) {
    setState(() {
      if (presetNum == 1) {
        _selectedCourseId = "CSE-207";
        _action = "REMOVE_TOPIC";
        _selectedTopicId = "DS-6";
        _reasonController.text = "Syllabus congestion: testing offloading graphs to save 3.5 weeks.";
      } else if (presetNum == 2) {
        _selectedCourseId = "CSE-405";
        _action = "CHANGE_ASSESSMENT";
        _practicalMarks = 25;
        _reasonController.text = "Industry recruiters emphasize hands-on model training over theory.";
      } else if (presetNum == 3) {
        _selectedCourseId = "CSE-401";
        _action = "ADD_TOPIC";
        _newTopicController.text = "Python Programming for Scientific Computing";
        _newTopicWeeks = 2.0;
        _reasonController.text = "Modernize AI tooling with NumPy and PyTorch essentials.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final course = AcademicEngine.getCourse(_selectedCourseId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
                ),
                child: const Text("CHANGE IMPACT STUDIO", style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 6),
              Text(
                "Simulate an Academic Change",
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Text("Configure a proposed syllabus or curriculum change. Acaddie will model the ripple effects across the degree graph.", style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
              const SizedBox(height: 20),

              // Presets Bar
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    const Text("Quick Presets:", style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFF87171), side: const BorderSide(color: Color(0xFFEF4444))),
                      onPressed: () => _loadPreset(1),
                      child: const Text("🔴 Scenario 1: Remove Graph Algorithms", style: TextStyle(fontSize: 11)),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFBBF24), side: const BorderSide(color: Color(0xFFF59E0B))),
                      onPressed: () => _loadPreset(2),
                      child: const Text("🟡 Scenario 2: Shift ML Marks", style: TextStyle(fontSize: 11)),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF34D399), side: const BorderSide(color: Color(0xFF10B981))),
                      onPressed: () => _loadPreset(3),
                      child: const Text("🟢 Scenario 3: Add Python to AI", style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Configuration Form Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step 1: Select Course
                    const Text("STEP 1: SELECT TARGET COURSE", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AcademicEngine.courses.map((c) {
                        final isSelected = c.id == _selectedCourseId;
                        return ChoiceChip(
                          label: Text("${c.code} (${c.name})"),
                          selected: isSelected,
                          selectedColor: const Color(0xFF0284C7).withOpacity(0.3),
                          backgroundColor: const Color(0xFF1E293B).withOpacity(0.5),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF38BDF8) : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          side: BorderSide(color: isSelected ? const Color(0xFF38BDF8) : Colors.white.withOpacity(0.1)),
                          onSelected: (val) {
                            if (val) {
                              setState(() {
                                _selectedCourseId = c.id;
                                _updateDefaultTopic();
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Step 2: Select Action Type
                    const Text("STEP 2: SELECT ACADEMIC CHANGE TYPE", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _action,
                      dropdownColor: const Color(0xFF1E293B),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF1E293B).withOpacity(0.5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      items: const [
                        DropdownMenuItem(value: "REMOVE_TOPIC", child: Text("1. Remove Topic (Evaluate downstream breakage & curriculum gap)")),
                        DropdownMenuItem(value: "ADD_TOPIC", child: Text("2. Add Topic (Evaluate workload, modernization & student readiness)")),
                        DropdownMenuItem(value: "CHANGE_ASSESSMENT", child: Text("3. Change Assessment Marks (Theory vs Practical rebalancing)")),
                        DropdownMenuItem(value: "MOVE_TOPIC", child: Text("4. Move Topic (Relocate topic to downstream course)")),
                        DropdownMenuItem(value: "CHANGE_PREREQUISITE", child: Text("5. Change Prerequisite (Modify course entry requirements)")),
                      ],
                      onChanged: (val) => setState(() => _action = val ?? "REMOVE_TOPIC"),
                    ),
                    const SizedBox(height: 24),

                    // Step 3: Parameter Configuration
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("STEP 3: CONFIGURE PARAMETERS FOR ${course.code}", style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),

                          if (_action == "REMOVE_TOPIC") ...[
                            const Text("Select Topic to Remove:", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _selectedTopicId,
                              dropdownColor: const Color(0xFF1E293B),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF1E293B),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              items: course.topics.map((t) {
                                return DropdownMenuItem(
                                  value: t.id,
                                  child: Text("${t.name} (${t.weeks} wks • ${t.importance})"),
                                );
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedTopicId = val),
                            ),
                          ],

                          if (_action == "ADD_TOPIC") ...[
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("New Topic Title:", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: _newTopicController,
                                        style: const TextStyle(color: Colors.white, fontSize: 13),
                                        decoration: InputDecoration(
                                          hintText: "e.g. Python Programming for Scientific Computing",
                                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                                          filled: true,
                                          fillColor: const Color(0xFF1E293B),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Instructional Weeks:", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                      const SizedBox(height: 6),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(color: Colors.white, fontSize: 13),
                                        decoration: InputDecoration(
                                          hintText: "2.0",
                                          filled: true,
                                          fillColor: const Color(0xFF1E293B),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onChanged: (val) {
                                          final parsed = double.tryParse(val);
                                          if (parsed != null) _newTopicWeeks = parsed;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],

                          if (_action == "CHANGE_ASSESSMENT") ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Proposed Practical Weight: $_practicalMarks%", style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 13)),
                                Text("Predicted Theory Weight: ${100 - _practicalMarks}%", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                              ],
                            ),
                            Slider(
                              min: 10,
                              max: 60,
                              divisions: 10,
                              value: _practicalMarks.toDouble(),
                              activeColor: const Color(0xFF38BDF8),
                              onChanged: (val) => setState(() => _practicalMarks = val.round()),
                            ),
                            Text("Current in ${course.code}: ${course.practicalPercentage}% Practical / ${course.theoryPercentage}% Theory", style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Step 4: Faculty Reason
                    const Text("STEP 4: ACADEMIC RATIONALE (OPTIONAL)", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reasonController,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "e.g. Pruning congested topics to improve foundational student comprehension...",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                        filled: true,
                        fillColor: const Color(0xFF1E293B).withOpacity(0.5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Action Submit Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("⚡ Analyzes 7 dimensions across the degree graph", style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.bolt, size: 18),
                          label: const Text("Run AI Simulation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          onPressed: () {
                            widget.onRunSimulation(
                              courseId: _selectedCourseId,
                              action: _action,
                              topicId: _selectedTopicId,
                              newTopicName: _newTopicController.text,
                              newTopicWeeks: _newTopicWeeks,
                              practicalMarks: _practicalMarks,
                              facultyReason: _reasonController.text,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
