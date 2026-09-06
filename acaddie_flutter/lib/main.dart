import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/curriculum_models.dart';
import 'models/user_model.dart';
import 'services/academic_engine.dart';
import 'services/auth_service.dart';
import 'screens/simulation_studio_screen.dart';
import 'screens/impact_report_screen.dart';
import 'screens/academic_map_screen.dart';
import 'screens/what_if_screen.dart';
import 'screens/auth_screens.dart';
import 'screens/course_catalog_screen.dart';
import 'screens/simulation_history_screen.dart';

import 'services/theme_service.dart';
import 'services/firebase_backend_service.dart';
import 'widgets/acaddie_logo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.init();
  await FirebaseBackendService.init();
  final user = await FirebaseBackendService.getCurrentUser();
  runApp(AcaddieApp(initialUser: user));
}

// ─────────────────────────────────────────────────────────────────────────────
// ROOT APP
// ─────────────────────────────────────────────────────────────────────────────
class AcaddieApp extends StatelessWidget {
  final AcaddieUser? initialUser;
  const AcaddieApp({super.key, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'ACADDIE — Think. Simulate. Decide.',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeService.lightTheme,
          darkTheme: ThemeService.darkTheme,
          home: _AuthGate(initialUser: initialUser),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AUTH GATE — routes between Login/Register/Shell
// ─────────────────────────────────────────────────────────────────────────────
class _AuthGate extends StatefulWidget {
  final AcaddieUser? initialUser;
  const _AuthGate({this.initialUser});

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  late bool _isLoggedIn;
  bool _showRegister = false;
  AcaddieUser? _user;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = widget.initialUser != null;
    _user = widget.initialUser;
  }

  void _onLoginSuccess() async {
    final user = await AuthService.getLoggedInUser();
    setState(() {
      _isLoggedIn = true;
      _user = user;
    });
  }

  void _onLogout() async {
    await AuthService.logout();
    setState(() {
      _isLoggedIn = false;
      _showRegister = false;
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return AcaddieShell(user: _user, onLogout: _onLogout);
    }
    if (_showRegister) {
      return RegisterScreen(
        onRegisterSuccess: _onLoginSuccess,
        onGoToLogin: () => setState(() => _showRegister = false),
      );
    }
    return LoginScreen(
      onLoginSuccess: _onLoginSuccess,
      onGoToRegister: () => setState(() => _showRegister = true),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN SHELL  (Sidebar + Content)
// ─────────────────────────────────────────────────────────────────────────────
enum AcaddieTab { dashboard, studio, report, map, whatif, history, courses }

class AcaddieShell extends StatefulWidget {
  final AcaddieUser? user;
  final VoidCallback onLogout;
  const AcaddieShell({super.key, this.user, required this.onLogout});

  @override
  State<AcaddieShell> createState() => _AcaddieShellState();
}

class _AcaddieShellState extends State<AcaddieShell>
    with TickerProviderStateMixin {
  AcaddieTab _activeTab = AcaddieTab.dashboard;
  SimulationResult? _activeSimulation;
  bool _isSimulating = false;
  String _simulatingStep = '';
  late AnimationController _pulseCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  String? _evidenceCourseId;

  @override
  void initState() {
    super.initState();
    _pulseCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();
    // Preload initial simulation from history
    if (AcademicEngine.history.isNotEmpty) {
      _activeSimulation = AcademicEngine.history.first;
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Run simulation with animated "processing" overlay ──────────────────────
  Future<void> _runSimulation({
    required String courseId,
    required String action,
    String? topicId,
    String? newTopicName,
    double? newTopicWeeks,
    int? practicalMarks,
    String? facultyReason,
  }) async {
    setState(() => _isSimulating = true);

    final steps = [
      'Traversing dependency graph...',
      'Evaluating CLO coverage impact...',
      'Modeling prerequisite risk...',
      'Calculating downstream cascade...',
      'Detecting curriculum gaps...',
      'Analyzing student readiness...',
      'Generating What-If alternatives...',
    ];

    for (final step in steps) {
      setState(() => _simulatingStep = step);
      await Future.delayed(const Duration(milliseconds: 380));
    }

    final result = AcademicEngine.runSimulation(
      courseId: courseId,
      action: action,
      topicId: topicId,
      newTopicName: newTopicName,
      newTopicWeeks: newTopicWeeks,
      practicalMarks: practicalMarks,
      facultyReason: facultyReason,
    );

    setState(() {
      _activeSimulation = result;
      _isSimulating = false;
      _activeTab = AcaddieTab.report;
    });
  }

  void _navigate(AcaddieTab tab) {
    setState(() => _activeTab = tab);
    _fadeCtrl.reset();
    _fadeCtrl.forward();
  }

  // ── Build content for each tab ─────────────────────────────────────────────
  Widget _buildContent() {
    switch (_activeTab) {
      case AcaddieTab.dashboard:
        return _DashboardView(
          activeSimulation: _activeSimulation,
          pulseCtrl: _pulseCtrl,
          onNavigate: _navigate,
          onRunPreset: (int preset) {
            if (preset == 1) {
              _runSimulation(
                courseId: 'CSE-207',
                action: 'REMOVE_TOPIC',
                topicId: 'DS-6',
                facultyReason:
                    'Syllabus congestion: testing offloading graphs to save 3.5 weeks.',
              );
            } else if (preset == 2) {
              _runSimulation(
                courseId: 'CSE-405',
                action: 'CHANGE_ASSESSMENT',
                practicalMarks: 25,
                facultyReason:
                    'Industry recruiters emphasize hands-on model training over theory.',
              );
            } else {
              _runSimulation(
                courseId: 'CSE-401',
                action: 'ADD_TOPIC',
                newTopicName: 'Python Programming for Scientific Computing',
                newTopicWeeks: 2.0,
                facultyReason: 'Modernize AI tooling with NumPy and PyTorch.',
              );
            }
          },
        );
      case AcaddieTab.studio:
        return SimulationStudioScreen(
          initialCourseId:
              _evidenceCourseId ?? _activeSimulation?.course.id,
          onRunSimulation: ({
            required String courseId,
            required String action,
            String? topicId,
            String? newTopicName,
            double? newTopicWeeks,
            int? practicalMarks,
            String? facultyReason,
          }) {
            _runSimulation(
              courseId: courseId,
              action: action,
              topicId: topicId,
              newTopicName: newTopicName,
              newTopicWeeks: newTopicWeeks,
              practicalMarks: practicalMarks,
              facultyReason: facultyReason,
            );
          },
        );
      case AcaddieTab.report:
        return ImpactReportScreen(
          simulation: _activeSimulation,
          onViewOnMap: () => _navigate(AcaddieTab.map),
          onComparePlans: () => _navigate(AcaddieTab.whatif),
          onExportReport: _showExportDialog,
          onOpenEvidence: (ev) => _showEvidenceDialog(ev),
        );
      case AcaddieTab.map:
        return AcademicMapScreen(
          activeSimulation: _activeSimulation,
          onSimulateCourse: (courseId) {
            setState(() => _evidenceCourseId = courseId);
            _navigate(AcaddieTab.studio);
          },
          onOpenEvidence: (ev) => _showEvidenceDialog(ev),
        );
      case AcaddieTab.whatif:
        return WhatIfScreen(
          simulation: _activeSimulation,
          onViewOnMap: () => _navigate(AcaddieTab.map),
          onExportReport: _showExportDialog,
        );
      case AcaddieTab.history:
        return SimulationHistoryScreen(
          onLoadSimulation: (sim) {
            setState(() => _activeSimulation = sim);
            _navigate(AcaddieTab.report);
          },
        );
      case AcaddieTab.courses:
        return CourseCatalogScreen(
          onSimulateCourse: (courseId) {
            setState(() => _evidenceCourseId = courseId);
            _navigate(AcaddieTab.studio);
          },
        );
    }
  }

  void _showEvidenceDialog(EvidenceItem ev) {
    showDialog(
      context: context,
      builder: (_) => _EvidenceDialog(evidence: ev),
    );
  }

  void _showExportDialog() {
    if (_activeSimulation == null) return;
    showDialog(
      context: context,
      builder: (_) => _ExportDialog(simulation: _activeSimulation!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060D1A),
      body: Stack(
        children: [
          Row(
            children: [
              // ── Sidebar ──────────────────────────────────────────────────
              _Sidebar(
                activeTab: _activeTab,
                hasSimulation: _activeSimulation != null,
                riskLevel: _activeSimulation?.riskLevel,
                onNavigate: _navigate,
                user: widget.user,
                onLogout: widget.onLogout,
              ),

              // ── Main Content ─────────────────────────────────────────────
              Expanded(
                child: Column(
                  children: [
                    _TopBar(
                      activeTab: _activeTab,
                      simulation: _activeSimulation,
                      pulseCtrl: _pulseCtrl,
                      onJudgeDemo: () => _runSimulation(
                        courseId: 'CSE-207',
                        action: 'REMOVE_TOPIC',
                        topicId: 'DS-6',
                        facultyReason:
                            'Judge Demo: Evaluating impact of removing Graph Algorithms.',
                      ),
                    ),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: _buildContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── AI Simulation Processing Overlay ─────────────────────────────
          if (_isSimulating) _SimulatingOverlay(step: _simulatingStep),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SIDEBAR
// ─────────────────────────────────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final AcaddieTab activeTab;
  final bool hasSimulation;
  final String? riskLevel;
  final Function(AcaddieTab) onNavigate;
  final AcaddieUser? user;
  final VoidCallback onLogout;

  const _Sidebar({
    required this.activeTab,
    required this.hasSimulation,
    required this.riskLevel,
    required this.onNavigate,
    required this.onLogout,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final riskColor = riskLevel == 'HIGH'
        ? const Color(0xFFEF4444)
        : riskLevel == 'MEDIUM'
            ? const Color(0xFFF59E0B)
            : const Color(0xFF10B981);

    return Container(
      width: 220,
      color: const Color(0xFF080F1E),
      child: Column(
        children: [
          // Logo area
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: AcaddieLogo(
              size: 34,
              isDark: ThemeService.isDark,
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.06), height: 1),
          const SizedBox(height: 12),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _sidebarSection('WORKSPACE'),
                _navItem(AcaddieTab.dashboard, Icons.dashboard_rounded,
                    'Dashboard'),
                _navItem(
                    AcaddieTab.studio, Icons.tune_rounded, 'Simulation Studio'),
                const SizedBox(height: 12),
                _sidebarSection('RESULTS'),
                _navItem(AcaddieTab.report, Icons.analytics_rounded,
                    'Impact Report',
                    badge: hasSimulation ? riskLevel : null,
                    badgeColor: hasSimulation ? riskColor : null),
                _navItem(
                    AcaddieTab.map, Icons.hub_rounded, 'Academic Map'),
                _navItem(AcaddieTab.whatif, Icons.compare_arrows_rounded,
                    'What-If Matrix'),
                const SizedBox(height: 12),
                _sidebarSection('REFERENCE'),
                _navItem(
                    AcaddieTab.courses, Icons.menu_book_rounded, 'Course Catalog'),
                _navItem(AcaddieTab.history, Icons.history_rounded,
                    'Simulation History',
                    badge: AcademicEngine.history.isNotEmpty
                        ? '${AcademicEngine.history.length}'
                        : null,
                    badgeColor: const Color(0xFF6366F1)),
              ],
            ),
          ),

          // User profile + logout footer
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
                const SizedBox(height: 10),

                // User info card
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.07)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.person,
                                color: Color(0xFF38BDF8), size: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.fullName.isNotEmpty == true
                                      ? user!.fullName
                                      : 'Faculty',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  user?.varsityName.isNotEmpty == true
                                      ? user!.varsityName
                                      : 'AUST',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                      color: const Color(0xFF475569),
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Engine status
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('Engine Online',
                              style: GoogleFonts.inter(
                                  color: const Color(0xFF475569),
                                  fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            foregroundColor: const Color(0xFFF87171),
                            backgroundColor:
                                const Color(0xFFEF4444).withValues(alpha: 0.06),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          icon: const Icon(Icons.logout, size: 14),
                          label: Text('Sign Out',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                          onPressed: onLogout,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6, top: 4),
      child: Text(title,
          style: GoogleFonts.inter(
            color: const Color(0xFF334155),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          )),
    );
  }

  Widget _navItem(AcaddieTab tab, IconData icon, String label,
      {String? badge, Color? badgeColor}) {
    final isActive = activeTab == tab;
    return GestureDetector(
      onTap: () => onNavigate(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF0284C7).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: const Color(0xFF0284C7).withOpacity(0.3))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isActive
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF475569),
                size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.inter(
                    color: isActive ? Colors.white : const Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  )),
            ),
            if (badge != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeColor ?? const Color(0xFF0284C7))
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (badgeColor ?? const Color(0xFF0284C7))
                        .withOpacity(0.4),
                  ),
                ),
                child: Text(badge,
                    style: TextStyle(
                      color: badgeColor ?? const Color(0xFF38BDF8),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    )),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final AcaddieTab activeTab;
  final SimulationResult? simulation;
  final AnimationController pulseCtrl;
  final VoidCallback onJudgeDemo;

  const _TopBar({
    required this.activeTab,
    required this.simulation,
    required this.pulseCtrl,
    required this.onJudgeDemo,
  });

  String get _title {
    switch (activeTab) {
      case AcaddieTab.dashboard:
        return 'Academic Decision Center';
      case AcaddieTab.studio:
        return 'Simulation Studio';
      case AcaddieTab.report:
        return 'Impact Report';
      case AcaddieTab.map:
        return 'Academic Map';
      case AcaddieTab.whatif:
        return 'What-If Matrix';
      case AcaddieTab.history:
        return 'Simulation History';
      case AcaddieTab.courses:
        return 'Course Catalog';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.isDark;

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF080F1E) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            _title,
            style: GoogleFonts.cormorantGaramond(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const Spacer(),

          // Theme Switcher Button (Dark / Light Mode)
          InkWell(
            onTap: () => ThemeService.toggleTheme(),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : const Color(0xFFCBD5E1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    size: 15,
                    color: isDark
                        ? const Color(0xFFFBBF24)
                        : const Color(0xFF0284C7),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isDark ? 'Light' : 'Dark',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Active simulation badge
          if (simulation != null) ...[
            AnimatedBuilder(
              animation: pulseCtrl,
              builder: (_, __) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444)
                      .withOpacity(0.05 + pulseCtrl.value * 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFEF4444)
                          .withOpacity(0.3 + pulseCtrl.value * 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444)
                            .withOpacity(0.5 + pulseCtrl.value * 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Active: ${simulation!.course.code} • ${simulation!.riskLevel} RISK',
                      style: const TextStyle(
                          color: Color(0xFFF87171),
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],

          // 1-Click Judge Demo button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.bolt, size: 15),
            label: Text('1-Click Judge Demo',
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w600)),
            onPressed: onJudgeDemo,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SIMULATING OVERLAY
// ─────────────────────────────────────────────────────────────────────────────
class _SimulatingOverlay extends StatelessWidget {
  final String step;

  const _SimulatingOverlay({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.82),
      child: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0284C7).withOpacity(0.2),
                blurRadius: 40,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(height: 20),
              Text('AI Simulation Engine',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Processing academic change impact...',
                  style: GoogleFonts.inter(
                      color: const Color(0xFF64748B), fontSize: 12)),
              const SizedBox(height: 24),
              const LinearProgressIndicator(
                backgroundColor: Color(0xFF1E293B),
                color: Color(0xFF0284C7),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Color(0xFF38BDF8)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(step,
                          style: GoogleFonts.inter(
                              color: const Color(0xFF38BDF8), fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('⚡ 7 academic dimensions • Graph traversal engine',
                  style: GoogleFonts.inter(
                      color: const Color(0xFF334155),
                      fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD VIEW
// ─────────────────────────────────────────────────────────────────────────────
class _DashboardView extends StatelessWidget {
  final SimulationResult? activeSimulation;
  final AnimationController pulseCtrl;
  final Function(AcaddieTab) onNavigate;
  final Function(int) onRunPreset;

  const _DashboardView({
    required this.activeSimulation,
    required this.pulseCtrl,
    required this.onNavigate,
    required this.onRunPreset,
  });

  @override
  Widget build(BuildContext context) {
    final sim = activeSimulation;
    final riskColor = sim == null
        ? const Color(0xFF64748B)
        : sim.riskLevel == 'HIGH'
            ? const Color(0xFFEF4444)
            : sim.riskLevel == 'MEDIUM'
                ? const Color(0xFFF59E0B)
                : const Color(0xFF10B981);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF0A1628)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFF38BDF8).withOpacity(0.3)),
                        ),
                        child: Text('AUST CSE CARNIVAL 8.0 — AI BUILD HACKATHON',
                            style: GoogleFonts.inter(
                                color: const Color(0xFF38BDF8),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8)),
                      ),
                      const SizedBox(height: 16),
                      Text('Think. Simulate. Decide.',
                          style: GoogleFonts.cormorantGaramond(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                          )),
                      const SizedBox(height: 8),
                      Text(
                          'Google Maps for Academic Decisions.\nDon\'t change curriculum blindly — simulate first.',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF64748B),
                            fontSize: 14,
                            height: 1.5,
                          )),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.tune, size: 16),
                            label: Text('Open Simulation Studio',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600)),
                            onPressed: () => onNavigate(AcaddieTab.studio),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.2)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.hub, size: 16),
                            label: Text('View Academic Map',
                                style: GoogleFonts.inter()),
                            onPressed: () => onNavigate(AcaddieTab.map),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                // Stats column
                Column(
                  children: [
                    _statCard('7', 'Courses Modeled', const Color(0xFF0284C7)),
                    const SizedBox(height: 12),
                    _statCard('35', 'Topics Tracked', const Color(0xFF6366F1)),
                    const SizedBox(height: 12),
                    _statCard('22', 'CLOs Mapped', const Color(0xFF10B981)),
                    const SizedBox(height: 12),
                    _statCard('7', 'Impact Dimensions',
                        const Color(0xFFF59E0B)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Active simulation card
          if (sim != null) ...[
            GestureDetector(
              onTap: () => onNavigate(AcaddieTab.report),
              child: AnimatedBuilder(
                animation: pulseCtrl,
                builder: (_, __) => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.05 + pulseCtrl.value * 0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: riskColor
                            .withOpacity(0.3 + pulseCtrl.value * 0.1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: riskColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: riskColor.withOpacity(0.3)),
                        ),
                        child: Center(
                          child: Text('${sim.overallScore}',
                              style: TextStyle(
                                  color: riskColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${sim.riskLevel} RISK — ${sim.course.code}: ${sim.course.name}',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(sim.executiveHeadline,
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF38BDF8),
                                side: BorderSide(
                                    color: const Color(0xFF38BDF8)
                                        .withOpacity(0.3))),
                            onPressed: () => onNavigate(AcaddieTab.report),
                            child: Text('View Report',
                                style: GoogleFonts.inter(fontSize: 12)),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.15))),
                            onPressed: () => onNavigate(AcaddieTab.map),
                            child: Text('Ripple Map',
                                style: GoogleFonts.inter(fontSize: 12)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Quick Preset Scenarios
          Text('Quick Demo Scenarios',
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _scenarioCard(
                  icon: Icons.remove_circle_outline,
                  color: const Color(0xFFEF4444),
                  label: 'Scenario 1',
                  title: 'Remove Graph Algorithms',
                  subtitle:
                      'CSE 207 → Remove 3.5-week critical topic and see cascade.',
                  risk: 'HIGH RISK',
                  onTap: () => onRunPreset(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _scenarioCard(
                  icon: Icons.balance,
                  color: const Color(0xFFF59E0B),
                  label: 'Scenario 2',
                  title: 'Shift ML Assessment Marks',
                  subtitle:
                      'CSE 405 → Increase practical weight from 40% to 55%.',
                  risk: 'MEDIUM RISK',
                  onTap: () => onRunPreset(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _scenarioCard(
                  icon: Icons.add_circle_outline,
                  color: const Color(0xFF10B981),
                  label: 'Scenario 3',
                  title: 'Add Python to AI Course',
                  subtitle:
                      'CSE 401 → Add "Python for Scientific Computing" topic.',
                  risk: 'LOW RISK',
                  onTap: () => onRunPreset(3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Feature grid
          Text('Platform Capabilities',
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 3.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _featureChip(Icons.account_tree, '7-Dimension Analysis'),
              _featureChip(Icons.hub, 'Graph Traversal Engine'),
              _featureChip(Icons.compare_arrows, 'What-If Plan Matrix'),
              _featureChip(Icons.help_outline, '"Why?" Evidence Layer'),
              _featureChip(Icons.waves, 'Live Ripple Visualization'),
              _featureChip(Icons.gavel, 'Faculty Decision Authority'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 28, fontWeight: FontWeight.w800)),
          Text(label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _scenarioCard({
    required IconData icon,
    required Color color,
    required String label,
    required String title,
    required String subtitle,
    required String risk,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(label,
                    style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(risk,
                      style: TextStyle(
                          color: color, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(title,
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: GoogleFonts.inter(
                    color: const Color(0xFF64748B), fontSize: 11, height: 1.4)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.bolt, color: color, size: 12),
                const SizedBox(width: 4),
                Text('Run Simulation',
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF38BDF8), size: 15),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label,
                style: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8), fontSize: 11)),
          ),
        ],
      ),
    );
  }
}



// ─────────────────────────────────────────────────────────────────────────────
// EVIDENCE DIALOG
// ─────────────────────────────────────────────────────────────────────────────
class _EvidenceDialog extends StatelessWidget {
  final EvidenceItem evidence;

  const _EvidenceDialog({required this.evidence});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 620,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('WHY? EVIDENCE CHAIN',
                          style: GoogleFonts.inter(
                              color: const Color(0xFFA78BFA),
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    Text(evidence.title,
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close,
                      color: Color(0xFF64748B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(evidence.summary,
                style: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontSize: 12,
                    height: 1.5)),
            const SizedBox(height: 16),

            // Causal paths
            ...evidence.paths.map((p) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFF6366F1).withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(p.fromCourse,
                              style: GoogleFonts.inter(
                                  color: const Color(0xFF38BDF8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward,
                                size: 14,
                                color: const Color(0xFF6366F1)
                                    .withOpacity(0.6)),
                          ),
                          Text(p.toCourse,
                              style: GoogleFonts.inter(
                                  color: const Color(0xFFA78BFA),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${p.fromTopic} [${p.relation}] ${p.toTopic}',
                          style: GoogleFonts.inter(
                              color: const Color(0xFF64748B), fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(p.academicReason,
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              height: 1.4)),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified,
                      size: 14, color: Color(0xFF38BDF8)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        'Academic Standard: ${evidence.academicStandardReference}',
                        style: GoogleFonts.inter(
                            color: const Color(0xFF38BDF8), fontSize: 10)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXPORT DIALOG
// ─────────────────────────────────────────────────────────────────────────────
class _ExportDialog extends StatelessWidget {
  final SimulationResult simulation;

  const _ExportDialog({required this.simulation});

  @override
  Widget build(BuildContext context) {
    final sim = simulation;
    final riskColor = sim.riskLevel == 'HIGH'
        ? const Color(0xFFEF4444)
        : sim.riskLevel == 'MEDIUM'
            ? const Color(0xFFF59E0B)
            : const Color(0xFF10B981);

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 680,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          children: [
            // Dialog Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Colors.white.withOpacity(0.06))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Official Academic Impact Report',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Report content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // University header
                    Center(
                      child: Column(
                        children: [
                          Text(AcademicEngine.university.name,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(AcademicEngine.university.department,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(
                              'Academic Change Impact Analysis Report',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  color: const Color(0xFF38BDF8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.white.withOpacity(0.1)),
                    const SizedBox(height: 16),
                    _reportRow('Report ID:', sim.simulationId),
                    _reportRow('Target Course:',
                        '${sim.course.code} — ${sim.course.name}'),
                    _reportRow('Change Type:',
                        sim.action.replaceAll('_', ' ')),
                    if (sim.targetTopic != null)
                      _reportRow('Target Topic:', sim.targetTopic!.name),
                    _reportRow('Faculty Rationale:', sim.facultyReason),
                    _reportRow('Curriculum Version:',
                        AcademicEngine.university.curriculumVersion),
                    const SizedBox(height: 20),
                    // Risk verdict
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: riskColor.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.assessment,
                              color: riskColor, size: 32),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Overall Impact Score: ${sim.overallScore}/100 (${sim.riskLevel} RISK)',
                                  style: TextStyle(
                                      color: riskColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(sim.riskLabel,
                                  style: GoogleFonts.inter(
                                      color: riskColor.withOpacity(0.7),
                                      fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Executive Summary',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(sim.executiveOverall,
                        style: GoogleFonts.inter(
                            color: const Color(0xFF94A3B8),
                            fontSize: 12,
                            height: 1.6)),
                    const SizedBox(height: 16),
                    Text('Recommended Action',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(sim.recommendedAction,
                        style: GoogleFonts.inter(
                            color: const Color(0xFF38BDF8),
                            fontSize: 12,
                            height: 1.5)),
                    const SizedBox(height: 20),
                    // Signature lines
                    Divider(color: Colors.white.withOpacity(0.1)),
                    const SizedBox(height: 16),
                    Text('Committee Sign-Off',
                        style: GoogleFonts.inter(
                            color: const Color(0xFF64748B),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _sigLine('Course Instructor'),
                        const SizedBox(width: 20),
                        _sigLine('Head of Department'),
                        const SizedBox(width: 20),
                        _sigLine('Curriculum Committee Chair'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Colors.white.withOpacity(0.06))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                            color: Colors.white.withOpacity(0.2))),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close',
                        style: GoogleFonts.inter(fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label,
                style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.inter(
                    color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _sigLine(String role) {
    return Expanded(
      child: Column(
        children: [
          Container(
              height: 1,
              color: Colors.white.withOpacity(0.15)),
          const SizedBox(height: 6),
          Text(role,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: const Color(0xFF475569), fontSize: 10)),
        ],
      ),
    );
  }
}
