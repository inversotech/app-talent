import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/notification/likes_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

class Likes extends StatelessWidget {
  final String origen;
  final String idOrigen;
  const Likes({Key? key, required this.origen, required this.idOrigen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LikesController>(
        init: LikesController(origen: origen, idOrigen: idOrigen),
        didUpdateWidget: (_, _stateBuilder) {
          _stateBuilder.controller!.onInit();
        },
        builder: (controller) {
          return AppScreen(
            codePage: '16120104',
            principalPage: false,
            refreshController: controller.refreshController,
            scrollController: controller.scrollController,
            enablePullDown: true,
            enablePullUp: true,
            showTabs: false,
            paddingLeft: 0,
            paddingRight: 0,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: Obx(() => controller.loadingData.value
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: AppBar(
                          centerTitle: true,
                          leading: Transform.translate(
                            offset: const Offset(-15, -8),
                            child: IconButton(
                              onPressed: () {
                                controller.goToBack();
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
                              'Me gusta',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  color: ColorsApp.primary),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 0, bottom: 0.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: ColorsApp.primary),
                              borderRadius: BorderRadius.circular(25.0)),
                          child: TextFormField(
                            controller: controller.search,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(bottom: 12.0),
                                alignLabelWithHint: true,
                                icon: const Icon(Icons.search),
                                labelStyle: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    color: ColorsApp.primary),
                                labelText: 'Buscar',
                                hintText: 'Buscar...',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never),
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: ColorsApp.primary),
                            onEditingComplete: () {
                              controller.onListData();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Container(child: _listLikes(controller)),
                      const SizedBox(
                        height: 80.0,
                      ),
                    ],
                  )
                : Container()),
          );
        });
  }

  Widget _listLikes(LikesController controller) {
    if (controller.listData.isNotEmpty) {
      return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
              children: List.generate(controller.listData.length, (index) {
            final item = controller.listData[index];
            return Padding(
              padding: const EdgeInsets.only(bottom:12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 35,
                      height: 35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: item.personaAvatar.toString(),
                          placeholder: (context, url) => const Icon(Icons.person),
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.person);
                          },
                        ),
                      )),
                  Flexible(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                        child: Text(item.personaFullname.toString() + ' ',
                            style: GoogleFonts.montserrat(
                                color: ColorsApp.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0))),
                  )
                ],
              ),
            );
          })));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text('No hay resultados para mostrar.',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: ColorsApp.primary)),
        ),
      );
    }
  }
}
