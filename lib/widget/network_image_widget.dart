import 'package:cached_network_image/cached_network_image.dart';
import 'package:covid/resource/resource.dart';
import 'package:flutter/material.dart';

class TTNetworkImage extends StatefulWidget {
  final double width;
  final double height;
  final String imageUrl;
  final BoxFit boxFit;
  final bool hasLoading;

  TTNetworkImage({
    Key key,
    this.width,
    this.height,
    this.imageUrl,
    this.boxFit = BoxFit.cover,
    this.hasLoading = false,
  });

  @override
  _TTNetworkImageState createState() => _TTNetworkImageState();
}

class _TTNetworkImageState extends State<TTNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl ?? '',
      width: widget.width,
      height: widget.height,
      fit: widget.boxFit,
      placeholder: (_, url) => widget.hasLoading
          ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Cl.tealish),
      )
          : null,
      errorWidget: (_, url, error) => url.isNotEmpty ? Icon(Icons.error) : null,
    );
  }
}
