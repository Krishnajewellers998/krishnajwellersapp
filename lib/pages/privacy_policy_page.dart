import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.gold),
        title: const Text(
          'PRIVACY POLICY',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero banner
            Container(
              color: AppColors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LEGAL & TRANSPARENCY',
                    style: TextStyle(
                      color: AppColors.gold.withAlpha(180),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'serif',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Effective Date: 11 September 2026  •  Last Updated: 11 September 2026',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Intro card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: const Border(
                        left: BorderSide(color: AppColors.goldDark, width: 4),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Krishna Jewellers ("we", "us", or "our") operates the Krishna Jewellers mobile '
                      'application ("App"). This Privacy Policy explains how we handle information when '
                      'you use our App.',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF444444),
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _PolicySection(
                    number: '1',
                    title: 'Information We Collect',
                    body: 'The Krishna Jewellers App is designed to display jewellery designs, jewellery '
                        'information, shop information, and gold rates.\n\n'
                        'The App does not directly collect or store personal information from users.\n\n'
                        'We do not require users to create an account or provide:',
                    bulletPoints: const [
                      'Name',
                      'Mobile number',
                      'Email address',
                      'Password',
                      'Home address',
                      'Payment or banking information',
                      'Government identification information',
                    ],
                  ),

                  _PolicySection(
                    number: '2',
                    title: 'Jewellery Designs',
                    body: 'The App displays jewellery photographs and related information for viewing purposes. '
                        'The App does not currently provide online jewellery purchasing or payment functionality.',
                  ),

                  _PolicySection(
                    number: '3',
                    title: 'Get Enquiry – WhatsApp',
                    body: 'The App provides a "Get Enquiry" button that allows users to contact Krishna Jewellers '
                        'through WhatsApp regarding jewellery designs.\n\n'
                        'When a user chooses this option, the App redirects the user to WhatsApp. Any information '
                        'provided by the user through WhatsApp is handled according to WhatsApp\'s own privacy policy.\n\n'
                        'The Krishna Jewellers App does not collect or store WhatsApp conversations or personal '
                        'information through the App.',
                  ),

                  _PolicySection(
                    number: '4',
                    title: 'Gold Rates',
                    body: 'The App displays current/live gold-rate information provided through our system. '
                        'Gold rates are for informational purposes and may change from time to time.',
                  ),

                  _PolicySection(
                    number: '5',
                    title: 'Google Maps, Instagram and Facebook',
                    body: 'The App may provide buttons or links to Google Maps, Instagram, and Facebook. '
                        'These buttons are provided only to help users access Krishna Jewellers\' shop location, '
                        'social media pages, and other publicly available business information.\n\n'
                        'The App does not collect the user\'s Google Maps, Instagram, or Facebook account information.\n\n'
                        'When a user opens these third-party services, their use is governed by the respective '
                        'service\'s own privacy policy and terms.',
                  ),

                  _PolicySection(
                    number: '6',
                    title: 'Permissions',
                    body: 'The App does not require access to the following permissions for its normal operation:',
                    bulletPoints: const [
                      'Camera',
                      'Microphone',
                      'Contacts',
                      'Photos / Gallery',
                      'Device location',
                      'SMS',
                      'Call logs',
                    ],
                  ),

                  _PolicySection(
                    number: '7',
                    title: 'Payments',
                    body: 'The App does not currently provide online payment or checkout functionality. '
                        'No payment or banking information is collected through the App.',
                  ),

                  _PolicySection(
                    number: '8',
                    title: 'Third-Party Services',
                    body: 'The App may redirect users to third-party services such as WhatsApp, Google Maps, '
                        'Instagram, and Facebook. These services operate independently and may collect or process '
                        'information according to their own privacy policies.\n\n'
                        'Krishna Jewellers does not control the privacy practices of these third-party services.',
                  ),

                  _PolicySection(
                    number: '9',
                    title: 'Data Security',
                    body: 'Because the App does not directly collect or store users\' personal information, '
                        'Krishna Jewellers does not maintain a personal user database through the App. '
                        'We take reasonable measures to maintain the security and proper functioning of the App.',
                  ),

                  _PolicySection(
                    number: '10',
                    title: 'Children\'s Privacy',
                    body: 'The App is not specifically directed toward children and does not knowingly collect '
                        'personal information from children.',
                  ),

                  _PolicySection(
                    number: '11',
                    title: 'Changes to This Privacy Policy',
                    body: 'We may update this Privacy Policy from time to time if the App or its features change. '
                        'Any updated Privacy Policy will be made available through the Privacy Policy page.',
                  ),

                  // Contact section
                  _PolicySection(
                    number: '12',
                    title: 'Contact Us',
                    body: 'For questions regarding this Privacy Policy, users may contact Krishna Jewellers '
                        'using the contact details below.',
                    contactInfo: true,
                  ),

                  _PolicySection(
                    number: '13',
                    title: 'Acceptance',
                    body: 'By using the Krishna Jewellers App, you acknowledge that you have read and '
                        'understood this Privacy Policy.',
                  ),

                  const SizedBox(height: 20),

                  // Footer note
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppConstants.storeName.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontFamily: 'serif',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          AppConstants.storeFooterText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
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

class _PolicySection extends StatelessWidget {
  final String number;
  final String title;
  final String body;
  final List<String>? bulletPoints;
  final bool contactInfo;

  const _PolicySection({
    required this.number,
    required this.title,
    required this.body,
    this.bulletPoints,
    this.contactInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.goldBorder)),
            ),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.goldDark, AppColors.gold],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF444444),
                    height: 1.65,
                  ),
                ),

                if (bulletPoints != null) ...[
                  const SizedBox(height: 10),
                  ...bulletPoints!.map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.goldBgGradientTop,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.goldBorder),
                            ),
                            child: const Center(
                              child: Text(
                                '✗',
                                style: TextStyle(
                                  color: AppColors.goldDark,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            point,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                if (contactInfo) ...[
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.goldBorder),
                    ),
                    child: Column(
                      children: [
                        _ContactRow(label: 'Business', value: AppConstants.storeName),
                        _ContactRow(label: 'Phone', value: AppConstants.phoneNumber),
                        _ContactRow(label: 'Address', value: AppConstants.storeAddress),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String label;
  final String value;

  const _ContactRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.goldBorder)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.goldDark,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: AppColors.textMain),
            ),
          ),
        ],
      ),
    );
  }
}
