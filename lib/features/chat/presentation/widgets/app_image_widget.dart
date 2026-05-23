import 'dart:io';
import 'package:flutter/material.dart';

class AppImageWidget extends StatelessWidget {
  final String path; // File, Assets and Url
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppImageWidget({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final isAssets = path.toLowerCase().startsWith('assets');

    final isNetwork = path.toLowerCase().startsWith('http');

    final isFile = !isAssets && !isNetwork;

    // if (isNetwork) {
    //   return CachedNetworkImage(
    //     imageUrl: path,
    //     width: width,
    //     height: height,
    //     fit: fit,
    //     placeholder: (
    //         BuildContext context,
    //         String url,
    //         ) {
    //       return const Center(
    //         child: CircularProgressIndicator(
    //           color: AppColors.primary,
    //         ),
    //       );
    //     },
    //     errorWidget: (
    //         BuildContext context,
    //         String url,
    //         Object error,
    //         ) {
    //       return Center(
    //         child: AppIconWidget(
    //           iconData: Icons.error,
    //           color: AppColors.error,
    //         ),
    //       );
    //     },
    //   );
    // }

    if (isAssets) {
      return Image.asset(path, width: width, height: height, fit: fit);
    }

    if (isFile) {
      return Image.file(File(path), width: width, height: height, fit: fit);
    }

    return const Placeholder();
  }
}
