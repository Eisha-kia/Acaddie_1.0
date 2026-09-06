import 'package:flutter/material.dart';
import '../models/curriculum_models.dart';

class ImpactReportScreen extends StatefulWidget {
  final SimulationResult? simulation;
  final VoidCallback onViewOnMap;
  final VoidCallback onComparePlans;
  final VoidCallback onExportReport;
  final Function(EvidenceItem evidence) onOpenEvidence;

  const ImpactReportScreen({
    super.key,
    required this.simulation,
    required this.onViewOnMap,
    required this.onComparePlans,
    required this.onExportReport,
    required this.onOpenEvidence,
  });

  @override
  State<ImpactReportScreen> createState() => _ImpactReportScreenState();
}

class _ImpactReportScreenState extends State<ImpactReportScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _notesController = TextEditingController();
  bool _savedFeedback = false;

  @override
  void initState() {
    super.initState();
    if (widget.simulation != null) {
      _notesController.text = widget.simulation!.facultyNotes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sim = widget.simulation;
    if (sim == null) {
      return const Center(child: Text("No simulation data available.", style: TextStyle(color: Colors.white)));
    }

    final isHighRisk = sim.riskLevel == "HIGH";
    final isMediumRisk = sim.riskLevel == "MEDIUM";
    final riskColor = isHighRisk ? const Color(0xFFEF4444) : isMediumRisk ? const Color(0xFFF59E0B) : const Color(0xFF10B981);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
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
                            decoration: BoxDecoration(color: const Color(0xFF0284C7).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                            child: Text(sim.course.code, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: riskColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: riskColor.withOpacity(0.4))),
                            child: Text("${sim.riskLevel} RISK (${sim.overallScore}/100)", style: TextStyle(color: riskColor, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
                            child: Text("Confidence: ${sim.confidence}%", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text("Academic Change Impact Report", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text("Simulation ID: ${sim.simulationId} • ${sim.course.name}", style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withOpacity(0.2))),
                        icon: const Icon(Icons.hub, size: 16),
                        label: const Text("View on Map", style: TextStyle(fontSize: 12)),
                        onPressed: widget.onViewOnMap,
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withOpacity(0.2))),
                        icon: const Icon(Icons.compare_arrows, size: 16),
                        label: const Text("Compare Plans", style: TextStyle(fontSize: 12)),
                        onPressed: widget.onComparePlans,
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), foregroundColor: Colors.white),
                        icon: const Icon(Icons.print, size: 16),
                        label: const Text("Export Report", style: TextStyle(fontSize: 12)),
                        onPressed: widget.onExportReport,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Score Gauge + Executive Briefing Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gauge Card
                  Container(
                    width: 220,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: riskColor, width: 4),
                            boxShadow: [BoxShadow(color: riskColor.withOpacity(0.3), blurRadius: 16)],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${sim.overallScore}", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: riskColor, height: 1)),
                                const Text("/ 100", style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(sim.riskLabel, textAlign: TextAlign.center, style: TextStyle(color: riskColor, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text("Multi-factor weighted score", style: TextStyle(color: Color(0xFF64748B), fontSize: 9)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Executive Briefing Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("EXECUTIVE BRIEFING FOR CURRICULUM COMMITTEE", style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(sim.executiveHeadline, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 8),
                          Text(sim.executiveOverall, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), height: 1.5)),
                          const SizedBox(height: 12),

                          // Key Risks
                          ...sim.executiveRisks.map((r) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFEF4444)),
                                const SizedBox(width: 6),
                                Expanded(child: Text(r, style: const TextStyle(color: Colors.white, fontSize: 11))),
                              ],
                            ),
                          )),
                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.2)),
                            ),
                            child: Text("Strategy Recommendation: ${sim.recommendedAction}", style: const TextStyle(color: Color(0xFF93C5FD), fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Before vs After Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("BEFORE VS. PREDICTED AFTER CURRICULAR STATE", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Before
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xFF1E293B).withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("CURRENT BASELINE", style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text("CLO Attainment: 85% on ${sim.cloImpact.isNotEmpty ? sim.cloImpact.first.cloId : "CLO-3"}", style: const TextStyle(color: Colors.white, fontSize: 12)),
                                Text("Assessment: ${sim.currentTheory}% Theory / ${sim.currentPractical}% Practical", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // After
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xFFEF4444).withOpacity(0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.2))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("PREDICTED STATE AFTER CHANGE", style: TextStyle(color: Color(0xFFF87171), fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text("CLO Attainment: 62% on ${sim.cloImpact.isNotEmpty ? sim.cloImpact.first.cloId : "CLO-3"} (Δ -23%)", style: const TextStyle(color: Color(0xFFF87171), fontSize: 12, fontWeight: FontWeight.bold)),
                                Text("Assessment: ${sim.predictedTheory}% Theory / ${sim.predictedPractical}% Practical", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 7-Dimension Tabs
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab Bar
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          _tabButton(0, "CLO Impact (${sim.cloImpact.length})"),
                          _tabButton(1, "Prerequisite Risk (${sim.prereqRiskLevel})"),
                          _tabButton(2, "Downstream Cascade (${sim.downstreamImpact.length})"),
                          _tabButton(3, "Curriculum Gaps (${sim.curriculumGaps.length})"),
                          _tabButton(4, "Student Readiness (${sim.readinessRiskLevel})"),
                        ],
                      ),
                    ),
                    const Divider(color: Color(0xFF1E293B), height: 1),

                    // Tab Contents
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildTabContent(sim),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Faculty Authority Decision Card
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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("FACULTY IN CONTROL", style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold)),
                            Text("Record Faculty Academic Decision", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFEF4444).withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                          child: Text("Status: ${sim.facultyDecision.replaceAll('_', ' ')}", style: const TextStyle(color: Color(0xFFF87171), fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _decisionChip(sim, "REJECT_PROPOSAL", "Reject Proposal (High Risk)", const Color(0xFFEF4444)),
                        _decisionChip(sim, "MODIFY_PROPOSAL", "Adopt Plan B/C (Tuned)", const Color(0xFFF59E0B)),
                        _decisionChip(sim, "SEND_FOR_REVIEW", "Send to Curriculum Committee", const Color(0xFF38BDF8)),
                        _decisionChip(sim, "ACCEPT_PROPOSAL", "Accept Proposal", const Color(0xFF10B981)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _notesController,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(
                        hintText: "Add faculty committee audit notes...",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                        filled: true,
                        fillColor: const Color(0xFF1E293B).withOpacity(0.5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_savedFeedback ? "✓ Decision saved to history!" : "AI advises; faculty makes the final decision.", style: TextStyle(color: _savedFeedback ? const Color(0xFF34D399) : const Color(0xFF64748B), fontSize: 11)),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), foregroundColor: Colors.white),
                          icon: const Icon(Icons.check, size: 14),
                          label: const Text("Save Decision", style: TextStyle(fontSize: 12)),
                          onPressed: () {
                            setState(() {
                              sim.facultyNotes = _notesController.text;
                              _savedFeedback = true;
                            });
                            Future.delayed(const Duration(seconds: 3), () {
                              if (mounted) setState(() => _savedFeedback = false);
                            });
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

  Widget _tabButton(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    return ChoiceChip(
      label: Text(title),
      selected: isSelected,
      selectedColor: const Color(0xFF0284C7),
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF94A3B8), fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      onSelected: (_) => setState(() => _selectedTabIndex = index),
    );
  }

  Widget _buildTabContent(SimulationResult sim) {
    if (_selectedTabIndex == 0) {
      // CLO Impact
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Course Learning Outcome (CLO) Reductions", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              if (sim.evidenceItems.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.help_outline, size: 14, color: Color(0xFF38BDF8)),
                  label: const Text("Inspect 'Why?' Evidence", style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12)),
                  onPressed: () => widget.onOpenEvidence(sim.evidenceItems.first),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...sim.cloImpact.map((clo) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1E293B).withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(clo.cloId, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFF0284C7).withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                          child: Text(clo.bloomLevel, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10)),
                        ),
                      ],
                    ),
                    Text("${clo.beforeCoverage}% ➔ ${clo.afterCoverage}% (${clo.delta}%)", style: TextStyle(color: clo.delta < 0 ? const Color(0xFFF87171) : const Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(clo.description, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
              ],
            ),
          )),
        ],
      );
    } else if (_selectedTabIndex == 1) {
      // Prerequisite Risk
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Prerequisite Broken Dependency Alert (${sim.prereqRiskLevel})", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              if (sim.evidenceItems.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.help_outline, size: 14, color: Color(0xFF38BDF8)),
                  label: const Text("Inspect 'Why?' Evidence", style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12)),
                  onPressed: () => widget.onOpenEvidence(sim.evidenceItems.first),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(sim.prereqSummary, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 12),
          ...sim.brokenTopics.map((t) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFEF4444).withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3))),
            child: Row(
              children: [
                const Icon(Icons.link_off, size: 14, color: Color(0xFFEF4444)),
                const SizedBox(width: 8),
                Expanded(child: Text(t, style: const TextStyle(color: Color(0xFFF87171), fontSize: 11, fontWeight: FontWeight.w600))),
              ],
            ),
          )),
        ],
      );
    } else if (_selectedTabIndex == 2) {
      // Downstream Cascade
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Transitive Downstream Courses Affected", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          ...sim.downstreamImpact.map((d) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1E293B).withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${d.courseCode}: ${d.courseName} (Distance: ${d.distance})", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(d.reason, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                    ],
                  ),
                ),
                Text("${d.impactScore}", style: TextStyle(color: d.impactScore > 60 ? const Color(0xFFF87171) : const Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          )),
        ],
      );
    } else if (_selectedTabIndex == 3) {
      // Curriculum Gaps
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Curriculum Knowledge Gap Detection", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          if (sim.curriculumGaps.isEmpty)
            const Text("✓ No critical curriculum gaps detected.", style: TextStyle(color: Color(0xFF34D399), fontSize: 12))
          else
            ...sim.curriculumGaps.map((g) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFEF4444).withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("⚠️ ${g.concept}", style: const TextStyle(color: Color(0xFFF87171), fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(g.description, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  const SizedBox(height: 6),
                  Text("Remedy: ${g.suggestedRemedy}", style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11)),
                ],
              ),
            )),
        ],
      );
    } else {
      // Student Readiness
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("7th Dimension: Student Transition Readiness", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF59E0B).withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3))),
            child: Text(sim.readinessFriction, style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.5)),
          ),
        ],
      );
    }
  }

  Widget _decisionChip(SimulationResult sim, String value, String label, Color color) {
    final isSelected = sim.facultyDecision == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: color.withOpacity(0.3),
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(color: isSelected ? color : Colors.white, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      side: BorderSide(color: isSelected ? color : Colors.white.withOpacity(0.1)),
      onSelected: (val) {
        if (val) setState(() => sim.facultyDecision = value);
      },
    );
  }
}
