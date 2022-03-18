import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lamb_talent/core/colors.dart';

class ShowPhoto extends StatelessWidget {
  final String imageUrl;
  const ShowPhoto({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: imageUrl.toString(),
              placeholder: (context, url) => const Image(
                image: AssetImage('assets/img/image-default.png'),
              ),
              errorWidget: (context, url, error) {
                return const Image(
                    image: AssetImage('assets/image/user-default.png'));
              },
            ),
          ),
          Positioned(
              top: 40,
              left: 0,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: ColorsApp.white,
                  )))
        ],
      ),
    );
  }
}
