import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_image_placeholder.dart';
import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  final String? url;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const EventImage({
    super.key,
    required this.url,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    final placeholder = EventImagePlaceholder(height: height, width: width);

    return ClipRRect(
      borderRadius: borderRadius,
      child: (imageUrl == null || imageUrl.isEmpty)
          ? placeholder
          : CachedNetworkImage(
              imageUrl: imageUrl,
              height: height,
              width: width,
              fit: BoxFit.cover,
              placeholder: (context, _) => placeholder,
              errorWidget: (context, _, _) => placeholder,
            ),
    );
  }
}
