import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkImageCustom extends StatefulWidget {
  final String url;
  final Widget Function(MemoryImage) callbackImage;
  final Widget Function(String) callbackAsset;
  NetworkImageCustom(
      {required this.url,
      required this.callbackImage,
      required this.callbackAsset});

  @override
  State<NetworkImageCustom> createState() => _NetworkImageCustomState(
      url: this.url,
      callbackImage: this.callbackImage,
      callbackAsset: this.callbackAsset);
}

class _NetworkImageCustomState extends State<NetworkImageCustom>
    with AutomaticKeepAliveClientMixin {
  final String url;
  final Widget Function(MemoryImage) callbackImage;
  final Widget Function(String) callbackAsset;
  _NetworkImageCustomState(
      {required this.url,
      required this.callbackImage,
      required this.callbackAsset});
  @override
  Widget build(context) {
    super.build(context);
    return FutureBuilder(
      // Paste your image URL inside the htt.get method as a parameter
      future: http.get(Uri.parse(widget.url)),
      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return CircularProgressIndicator(color: Colors.grey);
          case ConnectionState.done:
            if (snapshot.hasError) {
              return this.callbackAsset('Error de imagen.');
            }
            // when we get the data from the http call, we give the bodyBytes to Image.memory for showing the image
            if (snapshot.data!.statusCode != 200) {
              return this.callbackAsset('Error de imagen.');
            }
            return this.callbackImage(MemoryImage(snapshot.data!.bodyBytes));
        } // unreachable
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
/*  abstract class NetworkImageCustom1 extends ImageProvider<NetworkImage> {
  const factory NetworkImageCustom1(String url, { double scale, Map<String, String>? headers }) = network_image.NetworkImage;

  String get url;

  double get scale;
  Map<String, String>? get headers;

  @override
  ImageStreamCompleter load(NetworkImage key, DecoderCallback decode) {
    print(key);
    print(decode);
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<NetworkImage> obtainKey(ImageConfiguration configuration) {
    print(configuration);
    // TODO: implement obtainKey
    throw UnimplementedError();
  }
} */
