import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/controllers/notification/album_detail_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

class AlbumDetail extends StatelessWidget {
  final String id;
  final bool loadBack;
  const AlbumDetail({Key? key, required this.id, this.loadBack = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlbumDetailController>(
        init: AlbumDetailController(id: id),
        didUpdateWidget: (_, stateBuilder) {
          stateBuilder.controller!.onInit();
        },
        builder: (controller) {
          return AppScreen(
            codePage: '16120104',
            principalPage: false,
            refreshController: controller.refreshController,
            scrollController: controller.scrollController,
            enablePullDown: true,
            enablePullUp: false,
            showTabs: false,
            onRefresh: controller.onRefresh,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Obx(() => !controller.loadingData.value
                  ? Column(
                      children: [
                        const SizedBox(height: 8.0),
                        AppBar(
                          centerTitle: true,
                          leading: Transform.translate(
                            offset: const Offset(-15, -8),
                            child: IconButton(
                              onPressed: () {
                                controller.goToBack(loadBack);
                              },
                              iconSize: 40,
                              icon: const Icon(Icons.chevron_left,
                                  color: ColorsApp.primary),
                            ),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.white,
                          toolbarHeight: 40.0,
                          title: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Detalle del album',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  color: ColorsApp.primary),
                            ),
                          ),
                        ),
                        _cardEventPrincipal(controller),
                        _cardEventDetail(controller),
                      ],
                    )
                  : Container());
            }),
          );
        });
  }

  Widget _cardEventPrincipal(AlbumDetailController controller) {
    final month =
        capitalize(DateFormat.MMM('es').format(controller.album.fecha!));
    final monthAbbreviation = month.substring(0, month.length - 1);
    List<Widget> groupsWidget = [];
    for (var val in controller.listGroups) {
      groupsWidget.add(Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: ColorsApp.primary),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
          child: Text(val.nombre.toString(),
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  color: ColorsApp.white,
                  fontSize: 14.0)),
        ),
      ));
    }
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(monthAbbreviation,
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400, fontSize: 25.0)),
                    Text(controller.album.fecha!.day.toString(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400, fontSize: 25.0))
                  ],
                ),
                const SizedBox(width: 12.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.album.nombre.toString(),
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400, fontSize: 16.0)),
                      Text(
                          DateFormat.MMMMd('es')
                              .format(controller.album.fecha!),
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400, fontSize: 14.0)),
                      const SizedBox(height: 8.0),
                      Row(
                        children: groupsWidget,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardEventDetail(AlbumDetailController controller) {
    return SizedBox(
        width: double.infinity,
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.album.descripcion != null &&
                            controller.album.descripcion!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text('Descripción',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0)),
                          )
                        : Container(),
                    controller.album.descripcion != null &&
                            controller.album.descripcion!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(controller.album.descripcion.toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0)),
                          )
                        : Container(),
                    controller.album.fotos!.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.showPhoto(controller
                                      .album.fotos![index].imagenUrl
                                      .toString());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: ClipRRect(
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: controller
                                          .album.fotos![index].imagenUrl
                                          .toString(),
                                      placeholder: (context, url) =>
                                          const Image(
                                        image: AssetImage(
                                            'assets/img/image-default.png'),
                                      ),
                                      errorWidget: (context, url, error) {
                                        return const Image(
                                            image: AssetImage(
                                                'assets/image/user-default.png'));
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: controller.album.fotos!.length)
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                  'No se encontró imágenes para mostrar.',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      color: ColorsApp.primary)),
                            ),
                          )
                  ],
                ))));
  }
}
