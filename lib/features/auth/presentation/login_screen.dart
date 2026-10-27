import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/locale.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/brand.dart';
import '../../../core/config/env.dart';
import '../../../core/network/api_exception.dart';
import '../data/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  bool _consent = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  bool get _valid => RegExp(r'^[6-9]\d{9}$').hasMatch(_phone.text);

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final challenge = await ref.read(authControllerProvider.notifier).requestOtp(_phone.text);
      if (!mounted) return;
      context.push('/otp', extra: OtpArgs(challenge.identifier, _consent, challenge.resendAfter));
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const SizedBox(height: AppSpacing.xl),
            const Align(alignment: Alignment.centerLeft, child: BrandLogo(height: 64)),
            const SizedBox(height: AppSpacing.lg),
            Text(context.l10n.loginHeadline, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(context.l10n.loginSubhead, style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofillHints: const [AutofillHints.telephoneNumberNational],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: context.l10n.mobileNumber,
                prefixText: '+91  ',
                counterText: '',
                errorText: _error,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            MergeSemantics(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(value: _consent, onChanged: (v) => setState(() => _consent = v ?? false)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(color: AppColors.textSecondary),
                          children: [
                            TextSpan(text: context.l10n.consentStart),
                            _link(context.l10n.privacyPolicy, Env.privacyPolicyUrl),
                            TextSpan(text: context.l10n.consentAnd),
                            _link(context.l10n.terms, Env.termsUrl),
                            TextSpan(text: context.l10n.consentEnd),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _valid && _consent && !_loading ? _submit : null,
              child: _loading
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(context.l10n.getOtp),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _link(String text, String url) => TextSpan(
    text: text,
    style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600),
    recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse(url)),
  );
}

class OtpArgs {
  OtpArgs(this.identifier, this.consent, this.resendAfter);
  final String identifier;
  final bool consent;
  final int resendAfter;
}
