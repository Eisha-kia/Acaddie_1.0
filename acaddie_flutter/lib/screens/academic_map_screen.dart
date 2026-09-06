import 'package:flutter/material.dart';
import '../models/curriculum_models.dart';
import '../services/academic_engine.dart';

class AcademicMapScreen extends StatefulWidget {
  final SimulationResult? activeSimulation;
  final Function(String courseId) onSimulateCourse;
  final Function(EvidenceItem evidence) onOpenEvidence;

  const AcademicMapScreen({
    super.key,
    required this.activeSimulation,
    required this.onSimulateCourse,
    required this.onOpenEvidence,
  });

  @override
  State<AcademicMapScreen> createState() => _AcademicMapScreenState();
}

class _AcademicMapScreenState extends State<AcademicMapScreen> {
  Course? _selectedCourse;

  final Map<String, Offset> nodePositions = {
    "CSE-101": const Offset(100, 240),
    "CSE-207": const Offset(280, 240),
    "CSE-301": const Offset(480, 140),
    "CSE-305": const Offset(480, 320),
    "CSE-307": const Offset(480, 440),
    "CSE-401": const Offset(680, 140),
    "CSE-405": const Offset(880, 240),
  };

  final List<List<String>> edges = [
    ["CSE-101", "CSE-207"],
    ["CSE-207", "CSE-301"],
    ["CSE-207", "CSE-305"],
    ["CSE-207", "CSE-307"],
    ["CSE-301", "CSE-401"],
    ["CSE-401", "CSE-405"],
    ["CSE-301", "CSE-405"],
  ];

  RippleNode? _getRipple(String courseId) {
    if (widget.activeSimulation == null) return null;
    try {
      return widget.activeSimulation!.rippleEffect.firstWhere((r) => r.nodeId == courseId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
                        ),
                        child: const Text("INTERACTIVE GRAPH", style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      if (widget.activeSimulation != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
                          ),
                          child: const Text("⚡ RIPPLE EFFECT ACTIVE", style: TextStyle(color: Color(0xFFF87171), fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text("Department Academic Dependency Map", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Text("Visual representation of course prerequisites and downstream ripple effects.", style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Graph Canvas Container
          Container(
            height: 520,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF060A14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Stack(
              children: [
                // Custom Paint for Edges
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GraphEdgesPainter(
                      positions: nodePositions,
                      edges: edges,
                      activeSimulation: widget.activeSimulation,
                    ),
                  ),
                ),

                // Course Node Widgets
                ...AcademicEngine.courses.map((course) {
                  final pos = nodePositions[course.id] ?? const Offset(500, 250);
                  final ripple = _getRipple(course.id);
                  final isSelected = _selectedCourse?.id == course.id;

                  Color borderColor = Colors.white.withOpacity(0.15);
                  Color bgColor = const Color(0xFF0F172A);
                  if (ripple != null) {
                    if (ripple.color == "crimson") {
                      borderColor = const Color(0xFFEF4444);
                      bgColor = const Color(0xFFEF4444).withOpacity(0.12);
                    } else if (ripple.color == "amber") {
                      borderColor = const Color(0xFFF59E0B);
                      bgColor = const Color(0xFFF59E0B).withOpacity(0.12);
                    } else {
                      borderColor = const Color(0xFF10B981);
                      bgColor = const Color(0xFF10B981).withOpacity(0.12);
                    }
                  }
                  if (isSelected) {
                    borderColor = const Color(0xFF38BDF8);
                  }

                  return Positioned(
                    left: pos.dx - 70,
                    top: pos.dy - 40,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCourse = course;
                        });
                      },
                      child: Container(
                        width: 145,
                        height: 80,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor, width: ripple != null || isSelected ? 2 : 1),
                          boxShadow: [
                            if (ripple != null)
                              BoxShadow(
                                color: borderColor.withOpacity(0.3),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(course.code, style: TextStyle(color: ripple != null ? borderColor : const Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 11)),
                                Text("Sem ${course.semester}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 9)),
                              ],
                            ),
                            Text(
                              course.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            if (ripple != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: borderColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  ripple.level,
                                  style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                              )
                            else
                              Text("${course.credit} Cr • ${course.topics.length} Topics", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 8)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Map Legend
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Legend", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        _legendItem(const Color(0xFFEF4444), "High Impact / Source Change"),
                        const SizedBox(height: 4),
                        _legendItem(const Color(0xFFF59E0B), "Medium Downstream Disruption"),
                        const SizedBox(height: 4),
                        _legendItem(const Color(0xFF10B981), "Low Risk / Enriched Course"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Selected Course Drawer / Inspector
          if (_selectedCourse != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFF0284C7).withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                            child: Text(_selectedCourse!.code, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 10),
                          Text(_selectedCourse!.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(width: 10),
                          Text("Semester ${_selectedCourse!.semester} • ${_selectedCourse!.credit} Credits", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                            icon: const Icon(Icons.tune, size: 16),
                            label: const Text("Simulate Change on this Course", style: TextStyle(fontSize: 12)),
                            onPressed: () => widget.onSimulateCourse(_selectedCourse!.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                            onPressed: () => setState(() => _selectedCourse = null),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_selectedCourse!.description, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4)),
                  const SizedBox(height: 16),

                  // Topics & CLOs Grid
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Topics
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Syllabus Topics (${_selectedCourse!.topics.length})", style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 8),
                            ..._selectedCourse!.topics.map((t) => Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFF1E293B).withOpacity(0.5), borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(t.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                  Text("${t.weeks} wks", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),

                      // CLOs
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Course Learning Outcomes (${_selectedCourse!.clos.length})", style: const TextStyle(color: Color(0xFFA855F7), fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 8),
                            ..._selectedCourse!.clos.map((c) => Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFF1E293B).withOpacity(0.5), borderRadius: BorderRadius.circular(6)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(c.id, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                      Text("[${c.bloomLevel}]", style: const TextStyle(color: Color(0xFFC084FC), fontSize: 10, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(c.description, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
      ],
    );
  }
}

class _GraphEdgesPainter extends CustomPainter {
  final Map<String, Offset> positions;
  final List<List<String>> edges;
  final SimulationResult? activeSimulation;

  _GraphEdgesPainter({
    required this.positions,
    required this.edges,
    required this.activeSimulation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in edges) {
      final start = positions[edge[0]];
      final end = positions[edge[1]];
      if (start == null || end == null) continue;

      bool isRipple = false;
      if (activeSimulation != null) {
        final startRipple = activeSimulation!.rippleEffect.any((r) => r.nodeId == edge[0]);
        final endRipple = activeSimulation!.rippleEffect.any((r) => r.nodeId == edge[1]);
        isRipple = startRipple && endRipple;
      }

      final paint = Paint()
        ..color = isRipple ? const Color(0xFFEF4444) : Colors.white.withOpacity(0.18)
        ..strokeWidth = isRipple ? 2.5 : 1.2
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(start.dx, start.dy);
      final midX = (start.dx + end.dx) / 2;
      path.cubicTo(midX, start.dy, midX, end.dy, end.dx, end.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
