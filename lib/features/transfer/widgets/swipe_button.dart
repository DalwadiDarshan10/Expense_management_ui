import 'package:flutter/material.dart';
import 'package:expense/core/theme/app_colors.dart';

class SwipeButton extends StatefulWidget {
  final VoidCallback onSwipeCompleted;
  final String text;
  final bool enabled;

  const SwipeButton({
    super.key,
    required this.onSwipeCompleted,
    this.text = 'SWIPE TO TRANSFER',
    this.enabled = true,
  });

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> {
  double _dragValue = 0.0;
  bool _isCompleted = false;
  final double _height = 56.0;
  final double _handleSize = 48.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final dragLimit = totalWidth - _handleSize - 8; // 8 is padding

        return Container(
          height: _height,
          width: totalWidth,
          decoration: BoxDecoration(
            color: widget.enabled
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Centered Text
              Center(
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    // Use explicit style or AppTextStyles if match found
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 16,
                  ),
                ),
              ),

              // Draggable Handle
              Positioned(
                left: 4 + (dragLimit * _dragValue), // 4 is padding
                top: 4,
                bottom: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (!widget.enabled || _isCompleted) return;
                    setState(() {
                      double delta = details.primaryDelta! / dragLimit;
                      _dragValue += delta;
                      _dragValue = _dragValue.clamp(0.0, 1.0);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (!widget.enabled || _isCompleted) return;
                    if (_dragValue > 0.9) {
                      setState(() {
                        _dragValue = 1.0;
                        _isCompleted = true;
                      });
                      widget.onSwipeCompleted();
                    } else {
                      setState(() {
                        _dragValue = 0.0;
                      });
                    }
                  },
                  child: Container(
                    width: _handleSize,
                    height: _handleSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Rounded square/circle
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
