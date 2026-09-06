import 'package:flutter/material.dart';
import '../services/course_content_ai_assistant.dart';

/// Interactive modal dialog for the AI Course Content Conflict & Dependency Assistant
class ContentConflictAssistantModal extends StatefulWidget {
  final ContentAnalysisResult analysis;
  final VoidCallback onConfirm; // e.g. "Continue Anyway" or "Keep Content"
  final VoidCallback? onEditAlternative; // e.g. "Edit Content"
  final VoidCallback onCancel; // e.g. "Cancel"

  const ContentConflictAssistantModal({
    super.key,
    required this.analysis,
    required this.onConfirm,
    this.onEditAlternative,
    required this.onCancel,
  });

  /// Static helper to display the modal
  static Future<void> show({
    required BuildContext context,
    required ContentAnalysisResult analysis,
    required VoidCallback onConfirm,
    VoidCallback? onEditAlternative,
    required VoidCallback onCancel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ContentConflictAssistantModal(
        analysis: analysis,
        onConfirm: onConfirm,
        onEditAlternative: onEditAlternative,
        onCancel: onCancel,
      ),
    );
  }

  @override
  State<ContentConflictAssistantModal> createState() => _ContentConflictAssistantModalState();
}

class _ContentConflictAssistantModalState extends State<ContentConflictAssistantModal> {
  bool _showDependencyDetails = false;

  Color get _severityColor {
    switch (widget.analysis.severity) {
      case ContentConflictSeverity.safe:
        return const Color(0xFF10B981); // Emerald
      case ContentConflictSeverity.info:
        return const Color(0xFF0284C7); // Blue
      case ContentConflictSeverity.warning:
        return const Color(0xFFD97706); // Amber
      case ContentConflictSeverity.critical:
        return const Color(0xFFDC2626); // Crimson Red
    }
  }

  Color get _severityBgColor {
    switch (widget.analysis.severity) {
      case ContentConflictSeverity.safe:
        return const Color(0xFFECFDF5);
      case ContentConflictSeverity.info:
        return const Color(0xFFF0F9FF);
      case ContentConflictSeverity.warning:
        return const Color(0xFFFFFBEB);
      case ContentConflictSeverity.critical:
        return const Color(0xFFFEF2F2);
    }
  }

  IconData get _severityIcon {
    switch (widget.analysis.severity) {
      case ContentConflictSeverity.safe:
        return Icons.check_circle_outline;
      case ContentConflictSeverity.info:
        return Icons.info_outline;
      case ContentConflictSeverity.warning:
        return Icons.warning_amber_rounded;
      case ContentConflictSeverity.critical:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.analysis;
    final isDelete = a.actionType == ContentActionType.delete;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 780),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 20, 18),
              decoration: BoxDecoration(
                color: _severityBgColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(bottom: BorderSide(color: _severityColor.withOpacity(0.2))),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _severityColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_severityIcon, color: _severityColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _severityColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  a.severityLabel.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'AI Content Assistant',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isDelete ? 'AI Content Impact Analysis' : 'AI Content Conflict Analysis',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                    onPressed: widget.onCancel,
                    tooltip: 'Dismiss',
                  ),
                ],
              ),
            ),

            // Scrollable Content Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Target Change Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isDelete ? Icons.delete_outline : Icons.add_circle_outline,
                                size: 16,
                                color: isDelete ? Colors.red : const Color(0xFF2563EB),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isDelete ? 'Proposed Removal:' : 'New Content Proposal:',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF64748B),
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  a.targetCourseCode,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '"${a.contentTitle}"',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Impact Headline
                    Row(
                      children: [
                        Icon(Icons.assessment_outlined, size: 18, color: _severityColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Impact Assessment:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _severityBgColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _severityColor.withOpacity(0.25)),
                      ),
                      child: Text(
                        a.impactSummary,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: _severityColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Analysis Bullet Points
                    ...a.analysisBulletPoints.map((pt) {
                      IconData bulletIcon;
                      Color bulletColor;
                      String cleanText = pt;

                      if (pt.startsWith('🔴')) {
                        bulletIcon = Icons.circle;
                        bulletColor = const Color(0xFFDC2626);
                        cleanText = pt.replaceFirst('🔴', '').trim();
                      } else if (pt.startsWith('⚠')) {
                        bulletIcon = Icons.warning_amber_rounded;
                        bulletColor = const Color(0xFFD97706);
                        cleanText = pt.replaceFirst('⚠', '').trim();
                      } else if (pt.startsWith('✓')) {
                        bulletIcon = Icons.check_circle_outline;
                        bulletColor = const Color(0xFF10B981);
                        cleanText = pt.replaceFirst('✓', '').trim();
                      } else {
                        bulletIcon = Icons.info_outline;
                        bulletColor = const Color(0xFF0284C7);
                        cleanText = pt.replaceFirst('ℹ', '').trim();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: 8),
                              child: Icon(bulletIcon, size: 14, color: bulletColor),
                            ),
                            Expanded(
                              child: Text(
                                cleanText,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF334155),
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Affected Content List (if any)
                    if (a.affectedItems.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(Icons.account_tree_outlined, size: 17, color: Color(0xFF2563EB)),
                          const SizedBox(width: 8),
                          Text(
                            'Affected Content Across Curriculum (${a.affectedItems.length}):',
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...a.affectedItems.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.courseCode,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1D4ED8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.courseTitle,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.yearSemester,
                                      style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.arrow_right, size: 18, color: Color(0xFF94A3B8)),
                                  Expanded(
                                    child: Text(
                                      item.moduleOrTopic,
                                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                                    ),
                                  ),
                                ],
                              ),
                              if (_showDependencyDetails) ...[
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.reason,
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                    ],

                    const SizedBox(height: 14),

                    // Why Detected
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.psychology_alt_outlined, size: 17, color: Color(0xFF64748B)),
                        const SizedBox(width: 8),
                        const Text(
                          'Why Detected:',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a.reasonExplanation,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.4),
                    ),

                    const SizedBox(height: 12),

                    // What could happen
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.trending_down_outlined, size: 17, color: Color(0xFFEF4444)),
                        const SizedBox(width: 8),
                        const Text(
                          'Potential Curriculum Impact:',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a.potentialRepercussion,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.4),
                    ),

                    const SizedBox(height: 14),

                    // AI Recommendation Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFEFF6FF),
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.auto_awesome, color: Color(0xFF2563EB), size: 16),
                              SizedBox(width: 8),
                              Text(
                                'AI Recommendation:',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            a.aiRecommendation,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E293B),
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  // Secondary Inspection Button (Review Dependencies / Similar Content)
                  if (a.affectedItems.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _showDependencyDetails = !_showDependencyDetails;
                        });
                      },
                      icon: Icon(
                        _showDependencyDetails ? Icons.expand_less : Icons.visibility_outlined,
                        size: 16,
                      ),
                      label: Text(
                        _showDependencyDetails
                            ? 'Hide Details'
                            : isDelete
                                ? 'Review Dependencies'
                                : 'Review Similar Content',
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    const SizedBox.shrink(),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Cancel Button
                      OutlinedButton(
                        onPressed: widget.onCancel,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold)),
                      ),

                      // Optional Edit Content Button (for Add)
                      if (!isDelete && widget.onEditAlternative != null) ...[
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: widget.onEditAlternative,
                          icon: const Icon(Icons.edit, size: 14),
                          label: const Text('Edit Content', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2563EB),
                            side: const BorderSide(color: Color(0xFF93C5FD)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                        ),
                      ],

                      const SizedBox(width: 8),

                      // Primary Decision Button
                      ElevatedButton(
                        onPressed: widget.onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDelete
                              ? (a.severity == ContentConflictSeverity.critical
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF0F172A))
                              : const Color(0xFF0F172A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          elevation: 0,
                        ),
                        child: Text(
                          isDelete
                              ? (a.severity == ContentConflictSeverity.critical ? 'Continue Anyway' : 'Confirm Delete')
                              : 'Keep Content',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
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
