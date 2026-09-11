import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class JewelleryImageWidget extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const JewelleryImageWidget({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    final path = imagePath?.trim() ?? '';

    if (path.isEmpty) {
      content = _buildPlaceholder();
    } else if (path.startsWith('http://') || path.startsWith('https://')) {
      content = Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: AppColors.goldBgGradientTop,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.goldDark,
              ),
            ),
          );
        },
      );
    } else {
      // Local asset path (e.g., "images/banner.jpg" or "assets/images/banner.jpg")
      String cleanPath = path;
      if (cleanPath.startsWith('/')) {
        cleanPath = cleanPath.substring(1);
      }
      if (!cleanPath.startsWith('assets/')) {
        cleanPath = 'assets/$cleanPath';
      }

      content = Image.asset(
        cleanPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: content,
      );
    }

    return content;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.cream,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.diamond_outlined, color: AppColors.goldDark.withValues(alpha: 0.6), size: 30),
            const SizedBox(height: 4),
            Text(
              'Krishna Jewellers',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.goldDark.withValues(alpha: 0.8),
                fontFamily: 'serif',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
