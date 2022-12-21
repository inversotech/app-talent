import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/enviroment/enviroment.dart';
import 'package:photo_view/photo_view.dart';

class ShowPhoto extends StatelessWidget {
  final String imageUrl;
  final String token;
  final bool isMultiple;
  final List<String>? photos;
  final int indexStart;
  const ShowPhoto(
      {Key? key,
      this.imageUrl = '',
      required this.token,
      this.isMultiple = false,
      this.photos,
      this.indexStart = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: !isMultiple
                ? imageUrl.contains('http')
                    ? CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: imageUrl.toString(),
                        placeholder: (context, url) => const Image(
                          image: AssetImage('assets/img/image-default.png'),
                        ),
                        imageBuilder: (context, imageProvider) =>
                            PhotoView(imageProvider: imageProvider),
                        errorWidget: (context, url, error) {
                          return const Image(
                              image:
                                  AssetImage('assets/img/image-default.png'));
                        },
                      )
                    : CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: Env.api.apiMessengerShell.toString() +
                            'storage/file?fileName='.toString() +
                            imageUrl.toString(),
                        httpHeaders: {'Authorization': token},
                        placeholder: (context, url) => const Image(
                          image: AssetImage('assets/img/image-default.png'),
                        ),
                        imageBuilder: (context, imageProvider) =>
                            PhotoView(imageProvider: imageProvider),
                        errorWidget: (context, url, error) {
                          return const Image(
                              image:
                                  AssetImage('assets/img/image-default.png'));
                        },
                      )
                : CarouselSlider(
                    items: List.generate(
                        photos!.length,
                        (indexItem) => Builder(builder: (context) {
                              String photo = photos![indexItem];
                              return photo.isNotEmpty &&
                                      !photo.contains('empty')
                                  ? photo.contains('http')
                                      ? CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          imageUrl: photo.toString(),
                                          placeholder: (context, url) =>
                                              const Image(
                                            image: AssetImage(
                                                'assets/img/image-default.png'),
                                          ),
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              PhotoView(
                                                  imageProvider: imageProvider),
                                          errorWidget: (context, url, error) {
                                            return const Image(
                                                image: AssetImage(
                                                    'assets/img/image-default.png'));
                                          },
                                        )
                                      : CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          imageUrl: Env.api.apiMessengerShell
                                                  .toString() +
                                              'storage/file?fileName='
                                                  .toString() +
                                              photo.toString(),
                                          httpHeaders: {'Authorization': token},
                                          placeholder: (context, url) =>
                                              const Image(
                                            image: AssetImage(
                                                'assets/img/image-default.png'),
                                          ),
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              PhotoView(
                                                  imageProvider: imageProvider),
                                          errorWidget: (context, url, error) {
                                            return const Image(
                                                image: AssetImage(
                                                    'assets/img/image-default.png'));
                                          },
                                        )
                                  : Image.asset('assets/img/image-default.png');
                            })),
                    options: CarouselOptions(
                        height: double.infinity,
                        enlargeCenterPage: false,
                        viewportFraction: 1,
                        initialPage: indexStart,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        scrollDirection: Axis.horizontal),
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
