import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/theme/app_colors.dart';

/// Brand identity in one place. Swap the name here and drop the logo into assets/brand/logo.png.
class Brand {
  static const name = 'CapitUp';
  static const logoAsset = 'assets/brand/logo.png';
}

class _Logo {
  _Logo(this.image, this.crop);
  final ui.Image image;

  /// The visible (non-transparent) area of the image.
  final Rect crop;
  double get aspect => crop.width / crop.height;
}

Future<_Logo?>? _logoFuture;

/// Loads the logo and finds its visible bounds, so empty margin in the PNG never makes the logo look tiny.
Future<_Logo?> _loadLogo() => _logoFuture ??= () async {
  try {
    final data = await rootBundle.load(Brand.logoAsset);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final image = (await codec.getNextFrame()).image;
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    var minX = image.width, minY = image.height, maxX = -1, maxY = -1;
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final i = (y * image.width + x) * 4;
        final a = bytes.getUint8(i + 3);
        // Visible = not transparent and not near-white (many exported logos have a white box).
        final r = bytes.getUint8(i), g = bytes.getUint8(i + 1), b = bytes.getUint8(i + 2);
        final whiteish = r > 245 && g > 245 && b > 245;
        if (a > 24 && !whiteish) {
          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
          if (y < minY) minY = y;
          if (y > maxY) maxY = y;
        }
      }
    }
    if (maxX < 0) return _Logo(image, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
    return _Logo(image, Rect.fromLTRB(minX.toDouble(), minY.toDouble(), (maxX + 1).toDouble(), (maxY + 1).toDouble()));
  } catch (_) {
    return null;
  }
}();

/// The brand logo from assets/brand/logo.png, trimmed to its visible area, or a text wordmark until that file
/// exists. [height] is the height of the *visible* logo.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.height = 28, this.onDark = false});
  final double height;
  final bool onDark;

  @override
  Widget build(BuildContext context) => Semantics(
    label: Brand.name,
    image: true,
    child: FutureBuilder<_Logo?>(
      future: _loadLogo(),
      builder: (context, snap) {
        final logo = snap.data;
        if (snap.connectionState != ConnectionState.done) return SizedBox(height: height);
        if (logo == null) return _Wordmark(height: height, onDark: onDark);
        return SizedBox(
          height: height,
          width: height * logo.aspect,
          child: CustomPaint(painter: _LogoPainter(logo)),
        );
      },
    ),
  );
}

class _LogoPainter extends CustomPainter {
  _LogoPainter(this.logo);
  final _Logo logo;

  @override
  void paint(Canvas canvas, Size size) =>
      canvas.drawImageRect(logo.image, logo.crop, Offset.zero & size, Paint()..filterQuality = FilterQuality.high);

  @override
  bool shouldRepaint(_LogoPainter old) => old.logo != logo;
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.height, required this.onDark});
  final double height;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final main = onDark || AppColors.dark ? Colors.white : AppColors.ink;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: height,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryFill, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(height * 0.3),
          ),
          child: Icon(Icons.trending_up_rounded, color: AppColors.gold, size: height * 0.7),
        ),
        SizedBox(width: height * 0.25),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Capit',
                style: TextStyle(color: main),
              ),
              const TextSpan(
                text: 'Up',
                style: TextStyle(color: AppColors.gold),
              ),
            ],
          ),
          style: TextStyle(fontSize: height * 0.72, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
      ],
    );
  }
}
