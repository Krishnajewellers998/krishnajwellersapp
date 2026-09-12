import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/jewellery_models.dart';
import '../widgets/jewellery_image_widget.dart';

class JewelleryDetailPage extends StatefulWidget {
  final JewelleryItem item;

  const JewelleryDetailPage({super.key, required this.item});

  @override
  State<JewelleryDetailPage> createState() => _JewelleryDetailPageState();
}

class _JewelleryDetailPageState extends State<JewelleryDetailPage> {
  int _selectedImageIndex = 0;

  void _openWhatsAppEnquiry() async {
    final message = Uri.encodeComponent(
      'Hello ${AppConstants.storeName}, I am interested in enquiry for "${widget.item.name}" (Category: ${widget.item.category}, Weight: ${widget.item.weight ?? 'N/A'}g). Please share details!',
    );
    final uri = Uri.parse('https://wa.me/${AppConstants.whatsappNumber}?text=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  void _callStore() async {
    final uri = Uri.parse('tel:${AppConstants.phoneNumber}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.item.allImages;
    final currentImage = images.isNotEmpty ? images[_selectedImageIndex] : widget.item.singleImage;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.gold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.item.name.toUpperCase(),
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppColors.goldBorder)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Call Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.goldDark, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _callStore,
                icon: const Icon(Icons.call, color: AppColors.goldDark, size: 20),
                label: const Text(
                  'Call',
                  style: TextStyle(color: AppColors.goldDark, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              // WhatsApp Direct Enquiry
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 2,
                  ),
                  onPressed: _openWhatsAppEnquiry,
                  icon: const Icon(Icons.chat, color: Colors.white),
                  label: const Text(
                    'Enquire on WhatsApp',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Hero Image with Gold Frame
            Container(
              width: double.infinity,
              height: 340,
              color: const Color(0xFFFBF9F5),
              child: Hero(
                tag: 'item_${widget.item.id}',
                child: JewelleryImageWidget(
                  imagePath: currentImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Thumbnail Carousel if multiple images exist
            if (images.length > 1) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 70,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, idx) {
                    final isSelected = idx == _selectedImageIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = idx;
                        });
                      },
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppColors.gold : AppColors.goldBorder,
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: JewelleryImageWidget(
                            imagePath: images[idx],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Item Details Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.goldBgGradientTop,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.goldBorder),
                    ),
                    child: Text(
                      widget.item.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  if (widget.item.weight != null && widget.item.weight!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.scale, color: AppColors.goldDark, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'Estimated Weight: ${widget.item.weight} Grams',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.goldBorder),
                  const SizedBox(height: 12),

                  const Text(
                    'About This Piece',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'serif',
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.item.description != null && widget.item.description!.isNotEmpty
                        ? widget.item.description!
                        : 'Exquisitely handcrafted fine jewellery by Krishna Jewellers. Hallmark certified pure gold design crafted with traditional heritage and modern perfection in Rath, Uttar Pradesh.',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: AppColors.textMuted,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Store Trust Badges
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.goldBorder),
                    ),
                    child: const Column(
                      children: [
                        _BadgeRow(
                          icon: Icons.verified,
                          title: '100% BIS Hallmarked Gold',
                          desc: 'Guaranteed purity with authentic hallmark stamp.',
                        ),
                        SizedBox(height: 10),
                        _BadgeRow(
                          icon: Icons.handshake,
                          title: 'Trusted Since 1991',
                          desc: 'Generations of purity and customer satisfaction.',
                        ),
                        SizedBox(height: 10),
                        _BadgeRow(
                          icon: Icons.storefront,
                          title: 'Showroom in Khushipura, Rath',
                          desc: 'Visit us anytime to explore the complete collection.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _BadgeRow({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.goldDark, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
