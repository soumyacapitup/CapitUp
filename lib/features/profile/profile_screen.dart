import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/app_colors.dart';
import '../../core/brand.dart';
import '../../core/config/env.dart';
import '../../core/widgets/policy_card.dart';
import '../account/presentation/settings_screens.dart';
import '../auth/data/auth_controller.dart';
import '../../core/locale.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    Widget tile(IconData icon, String title, VoidCallback onTap, {String? subtitle}) => ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profile)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 128),
        children: [
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(AppSpacing.md),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryFill,
                child: Text(
                  (user?.fullName?.isNotEmpty ?? false) ? user!.fullName!.characters.first.toUpperCase() : '?',
                  style: const TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
              title: Text(user?.fullName ?? '', style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(user?.phone ?? user?.email ?? ''),
              trailing: const Icon(Icons.edit_outlined),
              onTap: () => context.push('/settings/profile'),
            ),
          ),
          SectionHeader(context.l10n.account),
          Card(
            child: Column(
              children: [
                tile(Icons.family_restroom_rounded, 'Family members', () => context.push('/family')),
                tile(Icons.notifications_none_rounded, 'Notifications', () => context.push('/settings/notifications')),
                const AppLockTile(),
                const AppLanguageTile(),
                const AppearanceTile(),
                const LanguageTile(),
                tile(Icons.shield_outlined, 'Privacy & data', () => context.push('/privacy')),
              ],
            ),
          ),
          SectionHeader(context.l10n.helpLegal),
          Card(
            child: Column(
              children: [
                tile(Icons.help_outline_rounded, 'Help & support', () => context.push('/support')),
                tile(
                  Icons.description_outlined,
                  context.l10n.termsConditions,
                  () => launchUrl(Uri.parse(Env.termsUrl)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout_rounded, color: AppColors.error),
              title: Text(context.l10n.logOut, style: TextStyle(color: AppColors.error)),
              onTap: () => ref.read(authControllerProvider.notifier).logout(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text('${Brand.name} · v0.4.0', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
