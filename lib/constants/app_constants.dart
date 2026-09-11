// =====================================================
//  KRISHNA JEWELLERS — GLOBAL APP CONSTANTS
//  Edit ALL configurable data here in one place.
//  No need to search through code files to update.
// =====================================================

class AppConstants {
  // ─── STORE INFO ────────────────────────────────────
  static const String storeName = 'Krishna Jewellers';
  static const String storeTagline = 'Fine Gold Jewellery';
  static const String storeCity = 'Rath, Uttar Pradesh';
  static const String storeEstablished = 'Since 1991';
  static const String storeAddress = 'Khushipura, Rath, Uttar Pradesh 210431';
  static const String storeFooterText = '© Since 1991 || Krishna Jewellers || All Rights Reserved.';

  // ─── CONTACT NUMBERS ───────────────────────────────
  // Change these numbers to update phone & WhatsApp everywhere in the app
  static const String whatsappNumber = '919984123388'; // without + prefix
  static const String phoneNumber = '+919984123388';    // with + prefix for dialer

  // ─── SOCIAL MEDIA LINKS ─────────────────────────────
  // Change these URLs to update social links throughout the app
  static const String instagramUrl = 'https://www.instagram.com/_krishna_jewellers_rath/';
  static const String facebookUrl  = 'https://www.facebook.com/share/18rPmNgVsh/?mibextid=wwXIfr';
  static const String whatsappUrl  = 'https://wa.me/$whatsappNumber';

  // ─── GOOGLE MAPS ─────────────────────────────────────
  // Change this URL if the showroom location changes
  static const String googleMapsUrl =
      'https://www.google.com/maps/place/krishna+jewellers,+Khushipura,+Rath,+Uttar+Pradesh+210431/'
      '@25.5926833,79.5662587,16z/data=!4m6!3m5!1s0x399d434a0774dc51:'
      '0x76e7534921a91ce!8m2!3d25.5926833!4d79.5662587!16s%2Fg%2F11l6tmshdf';

  // ─── LIVE API ─────────────────────────────────────────
  // Change the backend URL here if the server moves
  static const String apiBaseUrl = 'https://krishna-jewellers-y7h4.onrender.com';
  static const String apiGoldRates  = '$apiBaseUrl/api/gold-rates';
  static const String apiCategories = '$apiBaseUrl/api/categories';
  static const String apiJewellery  = '$apiBaseUrl/api/jewellery';

  // ─── FAMILY MEMBERS ──────────────────────────────────
  // Add or remove family members here to update the Our Family section
  static const List<Map<String, String>> familyMembers = [
    {
      'name': 'Swargiya Shree\nBrij Kishor Soni',
      'role': 'In Loving Memory',
      'image': 'assets/images/papa.jpg',
    },
    {
      'name': 'Shree Nand Kishor Soni',
      'role': 'Family',
      'image': 'assets/images/tauji.jpg',
    },
    {
      'name': 'Rahul Soni',
      'role': 'Family',
      'image': 'assets/images/rahul.jpg',
    },
    {
      'name': 'Krishna Soni',
      'role': 'Family',
      'image': 'assets/images/krishna.jpg',
    },
  ];

  static const String familyQuote =
      '"Jewellery may be made of gold, but the true value of a family '
      'business is built on trust, love and generations."';

  // ─── ASSETS (IMAGES) ─────────────────────────────────
  static const String logoImage   = 'assets/images/logo.png';
  static const String bannerImage = 'assets/images/banner.jpg';

  // ─── TRUST / HALLMARK BADGES ─────────────────────────
  static const List<Map<String, String>> trustBadges = [
    {
      'icon': 'verified',
      'title': '100% BIS Hallmarked Gold',
      'desc': 'Guaranteed purity with authentic hallmark stamp.',
    },
    {
      'icon': 'handshake',
      'title': 'Trusted Since 1991',
      'desc': 'Generations of purity and customer satisfaction.',
    },
    {
      'icon': 'storefront',
      'title': 'Showroom in Khushipura, Rath',
      'desc': 'Visit us anytime to explore the complete collection.',
    },
  ];

  // ─── SEARCH ──────────────────────────────────────────
  // Popular search suggestions shown by default on the search screen
  static const List<String> popularSearches = [
    'Ring',
    'Necklace',
    'Jhumki',
    'Chain',
    'Kangan',
    'Mangalsutra',
    'Bala',
    'Nose Pin',
    'Pendant',
    'Payal',
  ];
}
