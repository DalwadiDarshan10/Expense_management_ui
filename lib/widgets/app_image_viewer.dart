import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A custom image viewer widget that supports both SVG and PNG/JPG images.
///
/// This widget automatically detects the image type based on the file extension
/// and renders appropriately using either [SvgPicture] or [Image] widget.
///
/// Example usage:
/// ```dart
/// AppImageViewer(
///   imagePath: 'assets/images/logo.svg',
///   height: 100,
///   width: 100,
/// )
/// ```
class AppImageViewer extends StatelessWidget {
  /// The path to the image file (can be asset path, network URL, or file path)
  final String imagePath;

  /// Optional height of the image
  final double? height;

  /// Optional width of the image
  final double? width;

  /// How the image should be inscribed into the space allocated for it
  final BoxFit fit;

  /// Color to apply to the image (works best with SVG)
  final Color? color;

  /// Color blend mode for the color
  final BlendMode? colorBlendMode;

  /// Widget to display while loading (for network images)
  final Widget? placeholder;

  /// Widget to display when an error occurs
  final Widget? errorWidget;

  /// Alignment of the image within its container
  final Alignment alignment;

  /// Whether the image is from a network URL
  final bool isNetworkImage;

  /// Semantic label for accessibility
  final String? semanticLabel;

  const AppImageViewer({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode,
    this.placeholder,
    this.errorWidget,
    this.alignment = Alignment.center,
    this.isNetworkImage = false,
    this.semanticLabel,
  });

  /// Factory constructor for network images
  factory AppImageViewer.network({
    Key? key,
    required String imageUrl,
    double? height,
    double? width,
    BoxFit fit = BoxFit.contain,
    Color? color,
    BlendMode? colorBlendMode,
    Widget? placeholder,
    Widget? errorWidget,
    Alignment alignment = Alignment.center,
    String? semanticLabel,
  }) {
    return AppImageViewer(
      key: key,
      imagePath: imageUrl,
      height: height,
      width: width,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      placeholder: placeholder,
      errorWidget: errorWidget,
      alignment: alignment,
      isNetworkImage: true,
      semanticLabel: semanticLabel,
    );
  }

  /// Factory constructor for asset images
  factory AppImageViewer.asset({
    Key? key,
    required String assetPath,
    double? height,
    double? width,
    BoxFit fit = BoxFit.contain,
    Color? color,
    BlendMode? colorBlendMode,
    Widget? errorWidget,
    Alignment alignment = Alignment.center,
    String? semanticLabel,
  }) {
    return AppImageViewer(
      key: key,
      imagePath: assetPath,
      height: height,
      width: width,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      errorWidget: errorWidget,
      alignment: alignment,
      isNetworkImage: false,
      semanticLabel: semanticLabel,
    );
  }

  /// Check if the image is an SVG based on file extension
  bool get _isSvg {
    final lowercasePath = imagePath.toLowerCase();
    return lowercasePath.endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      return _buildSvgImage();
    } else {
      return _buildRasterImage();
    }
  }

  /// Builds the SVG image widget
  Widget _buildSvgImage() {
    if (isNetworkImage) {
      return SvgPicture.network(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn)
            : null,
        alignment: alignment,
        semanticsLabel: semanticLabel,
        placeholderBuilder: placeholder != null
            ? (context) => placeholder!
            : null,
      );
    } else {
      return SvgPicture.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn)
            : null,
        alignment: alignment,
        semanticsLabel: semanticLabel,
        placeholderBuilder: placeholder != null
            ? (context) => placeholder!
            : null,
      );
    }
  }

  /// Builds the raster image widget (PNG, JPG, etc.)
  Widget _buildRasterImage() {
    if (isNetworkImage) {
      return Image.network(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        semanticLabel: semanticLabel,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ??
              Center(
                child: SizedBox(
                  height: height,
                  width: width,
                  child: const CircularProgressIndicator(),
                ),
              );
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildDefaultErrorWidget();
        },
      );
    } else {
      return Image.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        semanticLabel: semanticLabel,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildDefaultErrorWidget();
        },
      );
    }
  }

  /// Builds the default error widget
  Widget _buildDefaultErrorWidget() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
    );
  }
}
