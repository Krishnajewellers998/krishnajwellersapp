import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

/// Mirrors the website's `getImageUrl()` in apiClient.js exactly.
///
/// Rules (same as website):
///   1. null / empty  → returns empty string (caller shows placeholder)
///   2. http:// or https:// → pass through (Cloudinary absolute URL)
///   3. data:           → pass through (base64 inline)
///   4. //              → pass through (protocol-relative)
///   5. relative path   → prepend [AppConstants.apiBaseUrl]
String resolveImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.trim().isEmpty) return '';
  final path = imagePath.trim();
  if (path.startsWith('http://') ||
      path.startsWith('https://') ||
      path.startsWith('data:') ||
      path.startsWith('//')) {
    return path;
  }
  final cleanPath = path.startsWith('/') ? path.substring(1) : path;
  return '${AppConstants.apiBaseUrl}/$cleanPath';
}

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
      // Absolute URL (e.g. Cloudinary) — pass through directly
      content = CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: fit,
        errorWidget: (context, url, error) => _buildPlaceholder(),
        placeholder: (context, url) => _buildLoadingIndicator(),
      );
    } else if (path.startsWith('//')) {
      // Protocol-relative URL — treat as https (mirrors website behaviour)
      content = CachedNetworkImage(
        imageUrl: 'https:$path',
        width: width,
        height: height,
        fit: fit,
        errorWidget: (context, url, error) => _buildPlaceholder(),
        placeholder: (context, url) => _buildLoadingIndicator(),
      );
    } else if (path.startsWith('data:image/')) {
      // Inline base64 image
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
      // Relative path — strip leading slash, resolve against API base
      String cleanPath = path.startsWith('/') ? path.substring(1) : path;

      if (cleanPath.startsWith('assets/')) {
        // Local Flutter asset
        content = Image.asset(
          cleanPath,
          width: width,
          height: height,
          fit: fit,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else {
        // Backend-hosted relative path → prepend API base URL
        final fullUrl = '${AppConstants.apiBaseUrl}/$cleanPath';
        content = CachedNetworkImage(
          imageUrl: fullUrl,
          width: width,
          height: height,
          fit: fit,
          errorWidget: (context, url, error) => _buildPlaceholder(),
          placeholder: (context, url) => _buildLoadingIndicator(),
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

  Widget _buildLoadingIndicator() {
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
