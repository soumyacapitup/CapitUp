import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_exception.dart';
import '../data/policy_repository.dart';
import '../../../core/locale.dart';

const _maxBytes = 20 * 1024 * 1024;

class AddPolicyScreen extends ConsumerStatefulWidget {
  const AddPolicyScreen({super.key});

  @override
  ConsumerState<AddPolicyScreen> createState() => _AddPolicyScreenState();
}

class _AddPolicyScreenState extends ConsumerState<AddPolicyScreen> {
  double? _progress;
  String? _error;

  Future<void> _pick({required bool images}) async {
    setState(() => _error = null);
    final file = await FilePicker.pickFile(
      type: images ? FileType.image : FileType.custom,
      allowedExtensions: images ? null : ['pdf'],
    );
    if (file == null) return;
    final size = await file.length();
    if (size != null && size > _maxBytes) {
      setState(() => _error = context.l10n.fileTooBig);
      return;
    }
    final ext = file.extension?.toLowerCase();
    if (!['pdf', 'jpg', 'jpeg', 'png'].contains(ext)) {
      setState(() => _error = context.l10n.wrongFileType);
      return;
    }
    await _upload(await file.readAsBytes(), file.name);
  }

  Future<void> _capture() async {
    setState(() => _error = null);
    final photo = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 85, maxWidth: 2400);
    if (photo == null) return;
    await _upload(await photo.readAsBytes(), photo.name);
  }

  Future<void> _upload(Uint8List bytes, String name) async {
    setState(() => _progress = 0);
    try {
      final doc = await ref
          .read(policyRepositoryProvider)
          .upload(bytes, name, onProgress: (p) => mounted ? setState(() => _progress = p) : null);
      if (!mounted) return;
      context.pushReplacement('/add/processing/${doc.id}');
    } on ApiException catch (e) {
      setState(() {
        _error = e.message;
        _progress = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploading = _progress != null;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.addAPolicyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(context.l10n.uploadIntro, style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.lg),
          if (uploading) ...[
            Text(context.l10n.uploadingPercent((_progress! * 100).round())),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(value: _progress),
          ] else ...[
            _SourceTile(
              icon: Icons.picture_as_pdf_rounded,
              title: context.l10n.uploadPdf,
              subtitle: context.l10n.recommendedBest,
              onTap: () => _pick(images: false),
            ),
            if (!kIsWeb)
              _SourceTile(
                icon: Icons.photo_camera_rounded,
                title: context.l10n.takePhoto,
                subtitle: context.l10n.photoTip,
                onTap: _capture,
              ),
            _SourceTile(
              icon: Icons.photo_library_rounded,
              title: context.l10n.uploadPhoto,
              subtitle: context.l10n.jpgOrPng,
              onTap: () => _pick(images: true),
            ),
            // TODO(P2): multi-page scanner with edge detection.
            _SourceTile(
              icon: Icons.edit_note_rounded,
              title: context.l10n.enterManually,
              subtitle: context.l10n.noDocumentNeeded,
              onTap: () => context.pushReplacement('/add/manual'),
            ),
            _SourceTile(
              icon: Icons.mail_outline_rounded,
              title: context.l10n.importGmail,
              subtitle: context.l10n.comingSoon,
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(_error!, style: TextStyle(color: AppColors.error)),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(context.l10n.docsEncrypted, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({required this.icon, required this.title, required this.subtitle, this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Card(
      child: ListTile(
        enabled: onTap != null,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        leading: Icon(icon, color: onTap != null ? AppColors.secondary : AppColors.textSecondary, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: onTap != null ? const Icon(Icons.chevron_right_rounded) : null,
        onTap: onTap,
      ),
    ),
  );
}
