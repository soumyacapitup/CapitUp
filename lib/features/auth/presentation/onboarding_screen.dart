import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/brand.dart';
import '../../../core/locale.dart';
import '../../../core/security/app_lock.dart';
import '../../../core/ui/art.dart';

final onboardingDoneProvider = NotifierProvider<OnboardingController, bool>(OnboardingController.new);

class OnboardingController extends Notifier<bool> {
  static const _key = 'onboarding_done';

  @override
  bool build() => ref.read(sharedPrefsProvider).getBool(_key) ?? false;

  Future<void> complete() async {
    await ref.read(sharedPrefsProvider).setBool(_key, true);
    state = true;
  }
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _Page {
  const _Page(this.scene, this.bg, this.title, this.body);
  final Scene scene;
  final Color bg;
  final String title;
  final String body;
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static List<(Scene, Color)> get _scenes => [
    (Scene.organise, AppColors.surfaceTint),
    (Scene.ask, AppColors.goldTint),
    (Scene.remind, AppColors.lavenderTint),
    (Scene.family, AppColors.errorTint),
  ];

  List<_Page> _pagesFor(AppLocalizations t) {
    final text = [
      (t.onb1Title, t.onb1Body),
      (t.onb2Title, t.onb2Body),
      (t.onb3Title, t.onb3Body),
      (t.onb4Title, t.onb4Body),
    ];
    return [for (var i = 0; i < _scenes.length; i++) _Page(_scenes[i].$1, _scenes[i].$2, text[i].$1, text[i].$2)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() => ref.read(onboardingDoneProvider.notifier).complete();

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final pages = _pagesFor(t);
    final last = _page == pages.length - 1;
    final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return AnimatedContainer(
      duration: reduce ? Duration.zero : const Duration(milliseconds: 350),
      color: pages[_page].bg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.sm, 0),
                // On a narrow phone with large text the two buttons shrink rather than overflow; the logo
                // keeps at least 72 px.
                child: LayoutBuilder(
                  builder: (context, box) => Row(
                    children: [
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(fit: BoxFit.scaleDown, child: BrandLogo(height: 44)),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: (box.maxWidth - 72).clamp(0, double.infinity)),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const LanguageSwitch(),
                              TextButton(onPressed: _finish, child: Text(t.skip)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    final p = pages[i];
                    return LayoutBuilder(
                      builder: (context, box) {
                        // The illustration takes what the screen can spare, so small phones never overflow.
                        final art = (box.maxHeight * 0.52).clamp(120.0, 320.0);
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: box.maxHeight),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SceneArt(p.scene, size: art),
                                const SizedBox(height: AppSpacing.md),
                                Semantics(
                                  header: true,
                                  child: Text(
                                    p.title,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 28),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  p.body,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.45),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < pages.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.all(4),
                      width: i == _page ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _page ? AppColors.primary : AppColors.primary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: FilledButton(
                  onPressed: () => last
                      ? _finish()
                      : _controller.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(last ? t.getStarted : t.next),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
