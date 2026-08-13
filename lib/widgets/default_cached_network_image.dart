import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DefaultCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final ImageWidgetBuilder? imageBuilder;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;

  const DefaultCachedNetworkImage({
    required this.imageUrl,
    this.imageBuilder,
    this.placeholder,
    this.errorWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl ?? '',
      imageBuilder: imageBuilder,
      placeholder:
          placeholder ??
          (context, url) => const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          ),
      errorWidget:
          errorWidget ??
          (context, url, error) => const Center(child: Icon(Icons.error)),
    );
  }
}
