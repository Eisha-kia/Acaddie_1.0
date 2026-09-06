import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/curriculum_models.dart';
import '../services/academic_engine.dart';

class SimulationHistoryScreen extends StatelessWidget {
  final Function(SimulationResult) onLoadSimulation;

  const SimulationHistoryScreen({
    super.key,
    required this.onLoadSimulation,
  });

  @override
  Widget build(BuildContext context) {
    final history = AcademicEngine.history;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
            ),
            child: Text(
              'SIMULATION AUDIT TRAIL',
              style: GoogleFonts.inter(
                color: const Color(0xFF38BDF8),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Simulation History',
            style: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${history.length} simulation(s) recorded in this session.',
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          if (history.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    const Icon(Icons.history,
                        color: Color(0xFF1E293B), size: 64),
                    const SizedBox(height: 12),
                    Text(
                      'No simulations yet.',
                      style: GoogleFonts.inter(
                          color: const Color(0xFF475569), fontSize: 14),
                    ),
                    Text(
                      'Run a simulation from the Studio.',
                      style: GoogleFonts.inter(
                          color: const Color(0xFF334155), fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            ...history.asMap().entries.map((entry) {
              final idx = entry.key;
              final sim = entry.value;
              final riskColor = sim.riskLevel == 'HIGH'
                  ? const Color(0xFFEF4444)
                  : sim.riskLevel == 'MEDIUM'
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF10B981);
              return GestureDetector(
                onTap: () => onLoadSimulation(sim),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.white.withOpacity(0.07)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: riskColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: riskColor.withOpacity(0.3)),
                        ),
                        child: Center(
                          child: Text(
                            '#${history.length - idx}',
                            style: TextStyle(
                              color: riskColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${sim.course.code}: ${sim.course.name} — ${sim.action.replaceAll("_", " ")}',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              sim.executiveHeadline,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF64748B),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: riskColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${sim.overallScore}/100 ${sim.riskLevel}',
                              style: TextStyle(
                                color: riskColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${sim.confidence}% confidence',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF475569),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
