import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../strings.dart';

/// Shimmering placeholder block. Static when the system asks for reduced motion.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({super.key, this.width, this.height = 16, this.radius = 12});
  final double? width;
  final double height;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    (MediaQuery.maybeOf(context)?.disableAnimations ?? false) ? _c.stop() : _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: AnimatedBuilder(
      animation: _c,
      builder: (_, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(-1.5 + 3 * _c.value, 0),
            end: Alignment(-0.5 + 3 * _c.value, 0),
            colors: [AppColors.skeletonBase, AppColors.skeletonHighlight, AppColors.skeletonBase],
          ),
        ),
      ),
    ),
  );
}

/// Generic page skeleton: a header block, a wide card and a few list rows.
class PageSkeleton extends StatelessWidget {
  const PageSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: strings.loading,
    child: ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const SkeletonBox(height: 160, radius: AppSpacing.radiusLg),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            for (var i = 0; i < 4; i++) ...[
              const Expanded(child: SkeletonBox(height: 72, radius: AppSpacing.radius)),
              if (i < 3) const SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        for (var i = 0; i < 3; i++) ...[
          const SkeletonBox(height: 84, radius: AppSpacing.radius),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    ),
  );
}
