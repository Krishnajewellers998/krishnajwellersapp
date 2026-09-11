import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../widgets/jewellery_image_widget.dart';

class ContactTab extends StatelessWidget {
  const ContactTab({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback: try browser
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: const Text(
          'CONTACT & STORE VISIT',
          style: TextStyle(
            color: AppColors.gold,
            fontFamily: 'serif',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Store Identity Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.black, AppColors.headerDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.goldShadow,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 2),
                    ),
                    child: ClipOval(
                      child: JewelleryImageWidget(
                        imagePath: AppConstants.logoImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppConstants.storeName.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontFamily: 'serif',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.storeAddress,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.goldDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'ESTABLISHED ${AppConstants.storeEstablished}'.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // WhatsApp
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
              ),
              onPressed: () => _launch(AppConstants.whatsappUrl),
              icon: const Icon(Icons.chat, size: 22),
              label: Text(
                'Chat on WhatsApp (${AppConstants.phoneNumber})',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            // Phone Call
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.goldDark, width: 1.5),
                foregroundColor: AppColors.goldDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _launch('tel:${AppConstants.phoneNumber}'),
              icon: const Icon(Icons.call, size: 22),
              label: Text(
                'Direct Call Store (${AppConstants.phoneNumber})',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            // Google Maps
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.gold,
                side: const BorderSide(color: AppColors.gold),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _launch(AppConstants.googleMapsUrl),
              icon: const Icon(Icons.pin_drop, size: 22),
              label: const Text(
                'Navigate with Google Maps',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),

            // Address box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.goldBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.goldDark, size: 28),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.storeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'serif',
                        ),
                      ),
                      Text(
                        AppConstants.storeAddress,
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Social Channels
            const Text(
              'FOLLOW OUR SOCIALS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                color: AppColors.goldDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE1306C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _launch(AppConstants.instagramUrl),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Instagram', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _launch(AppConstants.facebookUrl),
                    icon: const Icon(Icons.facebook),
                    label: const Text('Facebook', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
