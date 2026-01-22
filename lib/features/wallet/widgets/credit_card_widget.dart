import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/wallet/models/card_model.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCardWidget extends StatelessWidget {
  final CardModel card;

  const CreditCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: AppImageViewer(
              imagePath: card.cardImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Card Content
          Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bank Name
                Text(
                  card.bankName.isNotEmpty ? card.bankName : 'BANK NAME',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Card Number
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Text(
                    card.cardNumber.isNotEmpty
                        ? _formatCardNumber(card.cardNumber)
                        : '**** **** **** ****',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                // Bottom Info (Name and Expiry)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card Name',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            card.cardHolderName.isNotEmpty
                                ? card.cardHolderName
                                : 'CARD HOLDER',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w), // Add spacing between name and expiry
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exp',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          card.expiryDate.isNotEmpty
                              ? card.expiryDate
                              : 'MM/YY',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 18.w),
                    AppImageViewer(
                      imagePath: AppImages.debitCardGoldenImage,
                      height: 30.h,
                      width: 40.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCardNumber(String number) {
    number = number.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write('  '); // Add space every 4 digits
      }
      buffer.write(number[i]);
    }
    return buffer.toString();
  }
}
