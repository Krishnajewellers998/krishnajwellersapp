import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../domain/entities/gold_rates_entity.dart';

class GoldRatesCard extends StatelessWidget {
  final GoldRatesEntity rates;
  final bool isLoading;

  const GoldRatesCard({
    super.key,
    required this.rates,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title Bar with luxury gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9B7200), AppColors.gold, Color(0xFF9B7200)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bolt, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'LIVE GOLD RATES ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  '(Per 10 Gram)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // 3 Columns: 24K, 22K, 18K
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildRatePillar(
                    title: '24K GOLD',
                    price: isLoading ? '...' : currencyFormatter.format(rates.rate24K),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildRatePillar(
                    title: '22K GOLD',
                    price: isLoading ? '...' : currencyFormatter.format(rates.rate22K),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildRatePillar(
                    title: '18K GOLD',
                    price: isLoading ? '...' : currencyFormatter.format(rates.rate18K),
                  ),
                ),
              ],
            ),
          ),

          // Updated status footer
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Live synchronized with Krishna Jewellers',
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatePillar({required String title, required String price}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.goldBgGradientTop,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.goldBorder.withValues(alpha: 0.8)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9B7200),
              fontSize: 11,
              fontFamily: 'serif',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            price,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111111),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
