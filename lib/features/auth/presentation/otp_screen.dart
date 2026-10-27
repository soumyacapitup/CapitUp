import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/locale.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_exception.dart';
import '../data/auth_controller.dart';
import 'login_screen.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.args});
  final OtpArgs args;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _code = TextEditingController();
  bool _loading = false;
  String? _error;
  late int _secondsLeft = widget.args.resendAfter;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) return t.cancel();
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // On success the router redirects away from this screen.
      await ref
          .read(authControllerProvider.notifier)
          .verifyOtp(widget.args.identifier, _code.text, consent: widget.args.consent);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    try {
      final c = await ref.read(authControllerProvider.notifier).requestOtp(widget.args.identifier);
      setState(() => _secondsLeft = c.resendAfter);
      _startTimer();
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(context.l10n.otpTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(context.l10n.otpSentTo(widget.args.identifier), style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _code,
              autofocus: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, letterSpacing: 12, fontWeight: FontWeight.w600),
              onChanged: (v) {
                setState(() {});
                if (v.length == 6 && !_loading) _verify();
              },
              decoration: InputDecoration(counterText: '', errorText: _error),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _code.text.length == 6 && !_loading ? _verify : null,
              child: _loading
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(context.l10n.verify),
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: TextButton(
                onPressed: _secondsLeft > 0 ? null : _resend,
                child: Text(_secondsLeft > 0 ? context.l10n.resendIn(_secondsLeft) : context.l10n.resendCode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
