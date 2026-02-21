import 'package:bestapp_package/src/widgets/loading/be-load-circular.dart';
import 'package:flutter/material.dart';

/// Implementação para Web/WASM (sem CachedNetworkImage).
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
    return ClipRRect(
      borderRadius: radius != null
          ? BorderRadius.circular(radius!)
          : BorderRadius.circular(10),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ??
              Container(
                alignment: Alignment.center,
                child: beloadCircular(),
              );
        },
        errorBuilder: (context, error, stackTrace) =>
            notFound ??
            Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.panorama_outlined,
                size: sizeIcon ?? 90,
                color: Colors.grey[400]!.withOpacity(0.5),
              ),
            ),
      ),
    );
  }
}
