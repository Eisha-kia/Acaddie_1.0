import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AcaddieLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isDark;

  const AcaddieLogo({
    super.key,
    this.size = 44,
    this.showText = true,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
      children: [
        // Emblem Icon
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0284C7),
                Color(0xFF4F46E5),
                Color(0xFF06B6D4),
              ],
            ),
            borderRadius: BorderRadius.circular(size * 0.26),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                blurRadius: size * 0.3,
                offset: Offset(0, size * 0.08),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Academic mortarboard + AI neural node glyph
              Icon(
                Icons.auto_stories,
                color: Colors.white.withValues(alpha: 0.3),
                size: size * 0.7,
              ),
              Icon(
                Icons.hub_rounded,
                color: Colors.white,
                size: size * 0.52,
              ),
            ],
          ),
        ),

        if (showText) ...[
          SizedBox(width: size * 0.28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'ACADDIE',
                    style: GoogleFonts.cormorantGaramond(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontWeight: FontWeight.w700,
                      fontSize: size * 0.54,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '1.0',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF38BDF8),
                        fontSize: size * 0.22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'ACADEMIC IMPACT SIMULATOR',
                style: GoogleFonts.inter(
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                  fontSize: size * 0.2,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ],
    ),
    );
  }
}
