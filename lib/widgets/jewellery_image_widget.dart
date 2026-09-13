import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

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
      content = CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: fit,
        errorWidget: (context, url, error) => _buildPlaceholder(),
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: AppColors.goldBgGradientTop,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.goldDark,
            ),
          ),
        ),
      );
    } else if (path.startsWith('data:image/')) {
      final base64String = path.split(',').last;
      content = Image.memory(
        base64Decode(base64String),
        width: width,
        height: height,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      String cleanPath = path;
      if (cleanPath.startsWith('/')) {
        cleanPath = cleanPath.substring(1);
      }

      if (cleanPath.startsWith('assets/')) {
        // It's a local asset
        content = Image.asset(
          cleanPath,
          width: width,
          height: height,
          fit: fit,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else {
        // It's a backend image path like 'images/...'
        final fullUrl = '${AppConstants.apiBaseUrl}/$cleanPath';
        content = CachedNetworkImage(
          imageUrl: fullUrl,
          width: width,
          height: height,
          fit: fit,
          errorWidget: (context, url, error) => _buildPlaceholder(),
          placeholder: (context, url) => Container(
            width: width,
            height: height,
            color: AppColors.goldBgGradientTop,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.goldDark,
              ),
            ),
          ),
        );
      }
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
