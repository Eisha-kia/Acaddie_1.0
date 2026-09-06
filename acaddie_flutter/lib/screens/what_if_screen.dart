import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/curriculum_models.dart';

class WhatIfScreen extends StatelessWidget {
  final SimulationResult? simulation;
  final VoidCallback onViewOnMap;
  final VoidCallback onExportReport;

  const WhatIfScreen({
    super.key,
    required this.simulation,
    required this.onViewOnMap,
    required this.onExportReport,
  });

  @override
  Widget build(BuildContext context) {
    if (simulation == null || simulation!.alternatives.isEmpty) {
      return const Center(child: Text("No active simulation to compare.", style: TextStyle(color: Colors.white)));
    }

    final plans = simulation!.alternatives;

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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF0284C7).withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                        child: const Text("WHAT-IF MULTI-PLAN MATRIX", style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Compare Academic Decision Alternatives",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text("Evaluate trade-offs between proposed modification and synthesized alternatives for ${simulation!.course.code}.", style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withOpacity(0.2))),
                        icon: const Icon(Icons.hub, size: 16),
                        label: const Text("View on Map", style: TextStyle(fontSize: 12)),
                        onPressed: onViewOnMap,
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), foregroundColor: Colors.white),
                        icon: const Icon(Icons.print, size: 16),
                        label: const Text("Export Report", style: TextStyle(fontSize: 12)),
                        onPressed: onExportReport,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Plan Cards Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: plans.map((plan) {
                  final isSafest = plan.isSafest;
                  final planColor = plan.riskLevel == "HIGH" ? const Color(0xFFEF4444) : plan.riskLevel == "MEDIUM" ? const Color(0xFFF59E0B) : const Color(0xFF10B981);

                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSafest ? const Color(0xFF10B981) : Colors.white.withOpacity(0.08),
                          width: isSafest ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isSafest) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(10)),
                              child: const Text("✓ LOWEST MODELED IMPACT", style: TextStyle(color: Color(0xFF064E3B), fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(plan.riskLevel, style: TextStyle(color: planColor, fontWeight: FontWeight.bold, fontSize: 11)),
                              Text("${plan.overallImpact} / 100", style: TextStyle(color: planColor, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(plan.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 6),
                          Text(plan.description, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, height: 1.4)),
                          const SizedBox(height: 12),

                          // Pros
                          const Text("Advantages:", style: TextStyle(color: Color(0xFF34D399), fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          ...plan.pros.map((p) => Text("+ $p", style: const TextStyle(color: Colors.white, fontSize: 10))),
                          const SizedBox(height: 8),

                          // Cons
                          const Text("Trade-offs:", style: TextStyle(color: Color(0xFFF87171), fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          ...plan.cons.map((c) => Text("- $c", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10))),
                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSafest ? const Color(0xFF10B981).withOpacity(0.1) : const Color(0xFF1E293B).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text("Rationale: ${plan.recommendationRationale}", style: TextStyle(color: isSafest ? const Color(0xFFA7F3D0) : const Color(0xFF94A3B8), fontSize: 10, height: 1.3)),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Side-by-side Table Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("SIDE-BY-SIDE DIMENSION MATRIX", style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    Table(
                      border: TableBorder(horizontalInside: BorderSide(color: Colors.white.withOpacity(0.06))),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: const Color(0xFF1E293B).withOpacity(0.4)),
                          children: [
                            const Padding(padding: EdgeInsets.all(10), child: Text("Dimension", style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 11))),
                            ...plans.map((p) => Padding(padding: const EdgeInsets.all(10), child: Text(p.name, style: TextStyle(color: p.isSafest ? const Color(0xFF34D399) : Colors.white, fontWeight: FontWeight.bold, fontSize: 11)))),
                          ],
                        ),
                        _tableRow("Overall Impact Score", plans.map((p) => "${p.overallImpact}/100 (${p.riskLevel})").toList(), isHighlight: true),
                        _tableRow("CLO Impact", plans.map((p) => p.cloImpact).toList()),
                        _tableRow("Prerequisite Risk", plans.map((p) => p.prerequisiteRisk).toList()),
                        _tableRow("Downstream Disruption", plans.map((p) => p.downstreamRisk).toList()),
                        _tableRow("Curriculum Gap", plans.map((p) => p.curriculumGap).toList()),
                        _tableRow("Assessment Imbalance", plans.map((p) => p.assessmentRisk).toList()),
                        _tableRow("Student Readiness", plans.map((p) => p.studentReadiness).toList()),
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

  TableRow _tableRow(String label, List<String> values, {bool isHighlight = false}) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(10), child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11))),
        ...values.map((v) => Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            v,
            style: TextStyle(
              color: isHighlight ? const Color(0xFF38BDF8) : const Color(0xFF94A3B8),
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              fontSize: 11,
            ),
          ),
        )),
      ],
    );
  }
}
