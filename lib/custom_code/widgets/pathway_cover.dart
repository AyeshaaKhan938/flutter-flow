import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Official Kingdom Heirs book covers bundled with the app, by pathway
/// stableId. A `coverImageUrl` set in the CMS takes precedence.
const kBundledPathwayCovers = {
  'come-and-see',
  'rooted-in-christ',
  'holy-spirit-in-the-life-of-every-christian',
  'kingdom-heirs-foundations',
  'counterfeit-gospels',
  'joseph-the-dreamer-and-the-holy-spirit',
  'the-heart-of-a-king',
  'inner-healing-and-deliverance',
  'the-new-man',
  'a-letter-to-my-catholic-family',
  'who-is-isa-al-masih',
  'shepherds-lantern-allegory',
};

const _kCoverBackground = [Color(0xFF0E1630), Color(0xFF1E2A5A)];

/// A pathway's front cover, shown whole (never cropped) on a Kingdom Heirs
/// background, or a "Draft cover" placeholder until approved art exists.
/// Used on the pathway card, the overview page and the locked preview so
/// the same cover appears everywhere.
class PathwayCover extends StatelessWidget {
  const PathwayCover({
    super.key,
    required this.pathwayId,
    this.coverUrl = '',
    this.height = 160.0,
    this.locked = false,
  });

  final String pathwayId;
  final String coverUrl;
  final double height;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final placeholder = _Placeholder(height: height);
    Widget image;
    if (coverUrl.trim().isNotEmpty) {
      image = CachedNetworkImage(
        imageUrl: coverUrl.trim(),
        height: height,
        fit: BoxFit.contain,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => placeholder,
      );
    } else if (kBundledPathwayCovers.contains(pathwayId)) {
      image = Image.asset(
        'assets/images/cover_$pathwayId.jpg',
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => placeholder,
      );
    } else {
      return _frame(placeholder);
    }
    return _frame(Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(child: image),
    ));
  }

  Widget _frame(Widget child) => Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _kCoverBackground,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            if (locked)
              Positioned(
                top: 10.0,
                right: 10.0,
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: const BoxDecoration(
                    color: Color(0x99000000),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.lock, color: Colors.white, size: 18.0),
                ),
              ),
          ],
        ),
      );
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD9B45A);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_stories_outlined,
              color: gold, size: (height * 0.3).clamp(24.0, 56.0)),
          const SizedBox(height: 6.0),
          Text(
            'KINGDOM HEIRS',
            style: GoogleFonts.cinzel(
              color: gold,
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            'Draft cover',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11.0,
            ),
          ),
        ],
      ),
    );
  }
}
