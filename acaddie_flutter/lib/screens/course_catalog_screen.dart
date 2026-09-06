import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/curriculum_models.dart';
import '../services/academic_engine.dart';

class CourseCatalogScreen extends StatefulWidget {
  final Function(String courseId) onSimulateCourse;

  const CourseCatalogScreen({
    super.key,
    required this.onSimulateCourse,
  });

  @override
  State<CourseCatalogScreen> createState() => _CourseCatalogScreenState();
}

class _CourseCatalogScreenState extends State<CourseCatalogScreen> {
  String? _selectedId;
  String _semesterFilter = 'ALL';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allCourses = AcademicEngine.courses;

    // Filter by semester and search query
    final filteredCourses = allCourses.where((c) {
      if (_semesterFilter != 'ALL' && c.semester.toString() != _semesterFilter) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = c.code.toLowerCase().contains(q) ||
            c.name.toLowerCase().contains(q) ||
            c.description.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();

    final selected = _selectedId != null
        ? allCourses.firstWhere((c) => c.id == _selectedId,
            orElse: () => allCourses.first)
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
            ),
            child: Text(
              'DEPARTMENT COURSE CATALOG — AUST CSE 2025-2026',
              style: GoogleFonts.inter(
                color: const Color(0xFF38BDF8),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Title & Subtitle
          Text(
            'Courses, Syllabi & Outcomes',
            style: GoogleFonts.cormorantGaramond(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Inspect syllabus topics, Course Learning Outcomes (CLOs), and prerequisite relationships for AUST CSE.',
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          // Controls Bar (Search + Semester Filters)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Row(
              children: [
                // Search Input
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: TextField(
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        icon: const Icon(Icons.search,
                            color: Color(0xFF64748B), size: 18),
                        hintText: 'Search courses by code or title (e.g., CSE-207, Algorithms)...',
                        hintStyle: GoogleFonts.inter(
                            color: const Color(0xFF475569), fontSize: 12),
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() => _searchQuery = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Semester Filter Dropdown
                Row(
                  children: [
                    Text(
                      'Semester: ',
                      style: GoogleFonts.inter(
                          color: const Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.08)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _semesterFilter,
                          dropdownColor: const Color(0xFF1E293B),
                          style: GoogleFonts.inter(
                              color: Colors.white, fontSize: 12),
                          items: const [
                            DropdownMenuItem(
                                value: 'ALL', child: Text('All Semesters')),
                            DropdownMenuItem(
                                value: '1', child: Text('Semester 1')),
                            DropdownMenuItem(
                                value: '3', child: Text('Semester 3')),
                            DropdownMenuItem(
                                value: '4', child: Text('Semester 4')),
                            DropdownMenuItem(
                                value: '5', child: Text('Semester 5')),
                            DropdownMenuItem(
                                value: '6', child: Text('Semester 6')),
                            DropdownMenuItem(
                                value: '7', child: Text('Semester 7')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _semesterFilter = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Course Grid
          if (filteredCourses.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Icon(Icons.search_off, size: 48, color: Color(0xFF475569)),
                  const SizedBox(height: 12),
                  Text(
                    'No courses match your filter.',
                    style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8), fontSize: 14),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: filteredCourses.map((c) {
                final isSelected = c.id == _selectedId;
                return GestureDetector(
                  onTap: () => setState(() =>
                      _selectedId = isSelected ? null : c.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(16),
                    width: 220,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0284C7).withOpacity(0.12)
                          : const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF38BDF8)
                            : Colors.white.withOpacity(0.07),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF38BDF8).withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              c.code,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF38BDF8),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Sem ${c.semester}',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          c.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              '${c.credit} Cr • ${c.topics.length} topics',
                              style: GoogleFonts.inter(
                                  color: const Color(0xFF64748B),
                                  fontSize: 10),
                            ),
                            const Spacer(),
                            Icon(
                              isSelected
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: const Color(0xFF64748B),
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          // Course Detail Inspector Panel
          if (selected != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF38BDF8).withOpacity(0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${selected.code} — ${selected.name}',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  selected.type,
                                  style: GoogleFonts.inter(
                                      color: const Color(0xFF34D399),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Semester ${selected.semester} • ${selected.credit} Credits • Prerequisite: ${selected.prerequisites.isEmpty ? 'None' : selected.prerequisites.join(', ')}',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.bolt, size: 16),
                        label: Text(
                          'Simulate Change',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () =>
                            widget.onSimulateCourse(selected.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    selected.description,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Topics Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Syllabus Topics (${selected.topics.length})',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF38BDF8),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...selected.topics.map((t) => Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B)
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          t.name,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F172A),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '${t.weeks}w • ${t.importance}',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF94A3B8),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),

                      // CLOs Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Course Learning Outcomes (${selected.clos.length})',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFA855F7),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...selected.clos.map((c) => Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B)
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            c.id,
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF9333EA)
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '[${c.bloomLevel}]',
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFFC084FC),
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        c.description,
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF94A3B8),
                                          fontSize: 11,
                                          height: 1.4,
                                        ),
                                      ),
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
        ],
      ),
    );
  }
}
