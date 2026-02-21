import 'package:bestapp_package/src/widgets/loading/be-load-circular.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Implementação para mobile/desktop com cache (CachedNetworkImage).
class BeImageCached extends StatelessWidget {
  final String url;
  final Widget? placeholder;
  final Widget? notFound;
  final double? radius;
  final double? sizeIcon;

  BeImageCached({
    Key? key,
    required this.url,
    this.notFound,
    this.placeholder,
    this.radius,
    this.sizeIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: radius != null
              ? BorderRadius.circular(radius!)
              : BorderRadius.circular(10),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) =>
          placeholder ??
          Container(
            child: beloadCircular(),
          ),
      errorWidget: (context, url, error) =>
          notFound ??
          Container(
            child: Icon(
              Icons.panorama_outlined,
              size: sizeIcon ?? 90,
              color: Colors.grey[400]!.withOpacity(0.5),
            ),
          ),
    );
  }
}
