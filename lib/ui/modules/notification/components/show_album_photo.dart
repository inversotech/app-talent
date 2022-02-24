import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/notification/album_photo_controller.dart';

class ShowAlbumPhoto extends StatelessWidget {
  final String imageUrl;
  const ShowAlbumPhoto({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlbumPhotoController>(
        init: AlbumPhotoController(id: 'id'),
        builder: (controller) {
          return Obx(() => GestureDetector(
                onTap: () {
                  controller.clickPage.value = !controller.clickPage.value;
                },
                child: Scaffold(
                  backgroundColor: Colors.black,
                  body: Center(
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
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniCenterDocked,
                  floatingActionButton: controller.clickPage.value
                      ? Container(
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.5),
                          padding: const EdgeInsets.only(
                              top: 12.0, left: 12.0, right: 12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Este es un comentario de prueba y es demasiado extenso, solo es para verificar si se adapta correctamente en el eplicativo, gracias por ver la foto atentamente el ingeniero Ulices Julca Huancas',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      color: Colors.white)),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('5 likes',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                          color: Colors.white)),
                                  Text('10 comentarios',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                          color: Colors.white))
                                ],
                              ),
                              const Divider(endIndent: 1, color: Colors.white),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('Like',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('Comentar',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                  )
                                ],
                              ),
                            ],
                          ))
                      : null,
                ),
              ));
        });
  }
}
