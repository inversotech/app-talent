import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/controllers/notification/notification_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/enviroment/enviroment.dart';
import 'package:lamb_talent/resources/models/notification/notification_general.dart';
import 'package:lamb_talent/shared/components/expanded_text.dart';

class ListNotification extends StatelessWidget {
  final List<NotificationGeneralModel> listData;
  final void Function(NotificationGeneralModel) onPressed;
  final Function(NotificationGeneralModel item, int index) onPressedLike;
  final Function(NotificationGeneralModel, bool, int indexOrigen)
      onPressedComment;
  final Function(NotificationGeneralModel) onPressedShare;
  final Function(String) onPressedLink;
  final Function(String) onPressedPhoto;
  final Function(List<String>, int) onPressedPhotos;
  final Function(NotificationGeneralModel) onPressedLikes;
  final String token;
  const ListNotification(
      {Key? key,
      required this.listData,
      required this.onPressed,
      required this.onPressedLike,
      required this.onPressedComment,
      required this.onPressedShare,
      required this.onPressedLink,
      required this.onPressedPhoto,
      required this.onPressedPhotos,
      required this.onPressedLikes,
      required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('datos token!!!!');
    print(token);
    if (listData.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
        child: ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            primary: false,
            itemBuilder: (context, index) {
              final item = listData[index];
              return Column(
                key: item.globalKey,
                children: [_getCardNotify(item, index)],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8.0);
            },
            itemCount: listData.length),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text('No se encontró información para mostrar.',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: ColorsApp.primary)),
        ),
      );
    }
  }

  Widget _getCardNotify(NotificationGeneralModel item, int index) {
    Widget result = Container();
    switch (item.codigo) {
      case 'msm_evento':
        result = _cardEvent(item);
        break;
      case 'msm_album':
        result = _cardAlbum(item, index);
        break;
      case 'msm_notificacion':
        result = _cardNotification(item);
        break;
      default:
    }
    return result;
  }

  Widget _cardEvent(NotificationGeneralModel item) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: ColorsApp.white),
      width: double.infinity,
      child: GestureDetector(
          child: Column(
            children: [
              item.imagenUrl!.isNotEmpty && !item.imagenUrl!.contains('empty')
                  ? SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                        child: item.imagenUrl!.contains('http')
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: item.imagenUrl.toString(),
                                placeholder: (context, url) => Container(),
                                errorWidget: (context, url, error) {
                                  return Container();
                                },
                              )
                            : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: Env.api.apiMessengerShell.toString() +
                                    'storage/file?fileName='.toString() +
                                    item.imagenUrl.toString(),
                                httpHeaders: {'Authorization': token},
                                placeholder: (context, url) => Container(),
                                errorWidget: (context, url, error) {
                                  return Container();
                                },
                              ),
                      ),
                    )
                  : Container(),
              Padding(
                padding:
                    const EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorsApp.primary,
                      radius: 25,
                      child: Text(item.nombreEntidad!.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: ColorsApp.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0)),
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${capitalize(DateFormat.EEEE('es').format(item.fechaInicio!).substring(0, 3))}, ${DateFormat.d('es').format(item.fechaInicio!)} de ${capitalize(DateFormat.MMM('es').format(item.fechaInicio!))} a las ${Jiffy(item.fechaInicio.toString(), 'yyyy-MM-dd HH:mm').format('hh:mm a').toLowerCase()}',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400, fontSize: 14.0)),
                          ExpandableText(
                            text: item.mensaje.toString(),
                            style: GoogleFonts.montserrat(
                                color: ColorsApp.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0),
                            trimLines: 2,
                            trimCollapsedText: '...más',
                            trimExpandedText: ' menos',
                            styleClickableText: GoogleFonts.montserrat(
                                color: ColorsApp.control,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
            ],
          ),
          onTap: () {
            onPressed(item);
          }),
    );
  }

  Widget _cardNotification(NotificationGeneralModel item) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: ColorsApp.white),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.imagenUrl!.isNotEmpty && !item.imagenUrl!.contains('empty')
              ? SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    child: item.imagenUrl!.contains('http')
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: item.imagenUrl.toString(),
                            placeholder: (context, url) => Container(),
                            errorWidget: (context, url, error) {
                              return Container();
                            },
                          )
                        : CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: Env.api.apiMessengerShell.toString() +
                                'storage/file?fileName='.toString() +
                                item.imagenUrl.toString(),
                            httpHeaders: {'Authorization': token},
                            placeholder: (context, url) => Container(),
                            errorWidget: (context, url, error) {
                              return Container();
                            },
                          ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorsApp.warning,
                      radius: 25,
                      child: Text(item.nombreEntidad!.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: ColorsApp.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0)),
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              capitalize(
                                  Jiffy(item.fechaInicio, "yyyy-MM-dd HH:mm:ss")
                                      .fromNow()),
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400, fontSize: 12.0)),
                          const SizedBox(height: 8.0),
                          ExpandableText(
                            text: item.mensaje.toString(),
                            style: GoogleFonts.montserrat(
                                color: ColorsApp.primary,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0),
                            trimLines: 3,
                            trimCollapsedText: '...más',
                            trimExpandedText: ' menos',
                            styleClickableText: GoogleFonts.montserrat(
                                color: ColorsApp.control,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          ((item.addArchivo != null && item.addArchivo == '1') ||
                  (item.addLink != null && item.addLink == '1') ||
                  (item.addVideo != null && item.addVideo == '1'))
              ? Column(
                  children: [
                    const Divider(color: ColorsApp.primary, thickness: 1),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                      child: Column(
                        children: [
                          item.addArchivo != null &&
                                  item.addArchivo == '1' &&
                                  item.archivoUrl != null &&
                                  item.archivoUrl!.isNotEmpty
                              ? GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/icons/file.png',
                                          height: 35,
                                          width: 35,
                                          color: ColorsApp.primary),
                                      const SizedBox(width: 12.0),
                                      Flexible(
                                        child: Text('Ver pdf',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w400,
                                                color: ColorsApp.primary,
                                                fontSize: 14.0),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    onPressedLink(item.archivoUrl.toString());
                                  },
                                )
                              : Container(),
                          item.addLink != null &&
                                  item.addLink == '1' &&
                                  item.link != null &&
                                  item.link!.isNotEmpty
                              ? GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/icons/link.png',
                                          height: 35,
                                          width: 35,
                                          color: ColorsApp.primary),
                                      const SizedBox(width: 12.0),
                                      Text('Ver enlace',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              color: ColorsApp.primary,
                                              fontSize: 14.0),
                                          overflow: TextOverflow.ellipsis)
                                    ],
                                  ),
                                  onTap: () {
                                    onPressedLink(item.link.toString());
                                  },
                                )
                              : Container(),
                          item.addVideo != null &&
                                  item.addVideo == '1' &&
                                  item.videoUrl != null &&
                                  item.videoUrl!.isNotEmpty
                              ? GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/icons/video.png',
                                          height: 35,
                                          width: 35,
                                          color: ColorsApp.primary),
                                      const SizedBox(width: 12.0),
                                      Text('Ver video',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              color: ColorsApp.primary,
                                              fontSize: 14.0),
                                          overflow: TextOverflow.ellipsis)
                                    ],
                                  ),
                                  onTap: () {
                                    onPressedLink(item.videoUrl.toString());
                                  })
                              : Container(),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _cardAlbum(NotificationGeneralModel item, int index) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: ColorsApp.white),
      width: double.infinity,
      child: Column(
        children: [
          item.fotos!.isNotEmpty
              ? CardPhotos(
                  photos: item.fotos!,
                  onPressedPhoto: (photo, index) {
                    onPressedPhotos(photo, index);
                  })
              : Container(),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LikeAlbum(
                        album: item,
                        onPressedLike: (albumData) {
                          onPressedLike(albumData, index);
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            onPressedComment(item, true, index);
                          },
                          icon: Image.asset('assets/icons/comment.png',
                              height: 35, width: 35, color: ColorsApp.primary)),
                      IconButton(
                          onPressed: () {
                            onPressedShare(item);
                          },
                          icon: Image.asset('assets/icons/share.png',
                              height: 35, width: 35, color: ColorsApp.primary)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Text(
                            item.countLikes.toString() +
                                (item.countLikes! > 1
                                    ? ' Me gustas'
                                    : ' Me gusta'),
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600, fontSize: 14.0)),
                        onTap: () {
                          onPressedLikes(item);
                        },
                      ),
                      const SizedBox(height: 4.0),
                      ExpandableText(
                        textHeader: item.nombreEntidad.toString() +
                            (item.mensaje!.isNotEmpty
                                ? (' | ' + item.mensaje.toString())
                                : '') +
                            ' ',
                        styleTextHeader: GoogleFonts.montserrat(
                            color: ColorsApp.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                        text: item.descripcion.toString(),
                        style: GoogleFonts.montserrat(
                            color: ColorsApp.primary,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                        trimLines: 3,
                        trimCollapsedText: '...más',
                        trimExpandedText: ' menos',
                        styleClickableText: GoogleFonts.montserrat(
                            color: ColorsApp.control,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      ),
                      item.countComentarios! > 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                child: Text(
                                    'Ver ' +
                                        item.countComentarios.toString() +
                                        (item.countComentarios! > 1
                                            ? ' comentarios'
                                            : ' comentario'),
                                    style: GoogleFonts.montserrat(
                                        color: ColorsApp.control,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0)),
                                onTap: () {
                                  onPressedComment(item, false, index);
                                },
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 8.0),
                      Text(
                          capitalize(
                              Jiffy(item.fechaInicio, "yyyy-MM-dd HH:mm:ss")
                                  .fromNow()),
                          style: GoogleFonts.montserrat(
                              color: ColorsApp.control,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // onPressed(item);
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CardPhotos extends StatefulWidget {
  List<Foto> photos;
  Function(List<String>, int) onPressedPhoto;
  CardPhotos({Key? key, required this.photos, required this.onPressedPhoto})
      : super(key: key);

  @override
  State<CardPhotos> createState() => _CardPhotosState();
}

class _CardPhotosState extends State<CardPhotos> {
  int itemChangePhoto = 1;
  int indexSelect = 0;
  final controller = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            CarouselSlider(
              items: List.generate(
                  widget.photos.length,
                  (indexItem) => Builder(builder: (context) {
                        Foto photo = widget.photos[indexItem];
                        return photo.imagenUrl!.isNotEmpty &&
                                !photo.imagenUrl!.contains('empty')
                            ? GestureDetector(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: photo.imagenUrl!.contains('http')
                                      ? CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: photo.imagenUrl.toString(),
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  'assets/img/image-default.png'),
                                          errorWidget: (context, url, error) {
                                            return Image.asset(
                                                'assets/img/image-default.png');
                                          },
                                        )
                                      : CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: Env.api.apiMessengerShell
                                                  .toString() +
                                              'storage/file?fileName='
                                                  .toString() +
                                              photo.imagenUrl.toString(),
                                          httpHeaders: {
                                            'Authorization': controller.token
                                          },
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  'assets/img/image-default.png'),
                                          errorWidget: (context, url, error) {
                                            return Image.asset(
                                                'assets/img/image-default.png');
                                          },
                                        ),
                                ),
                                onTap: () {
                                  widget.onPressedPhoto(
                                      widget.photos
                                          .map((e) =>
                                              (e.imagenUrl ?? '').toString())
                                          .toList(),
                                      indexItem);
                                },
                              )
                            : Image.asset('assets/img/image-default.png');
                      })),
              options: CarouselOptions(
                height: 200,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    itemChangePhoto = index + 1;
                    indexSelect = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      List<Widget>.generate(widget.photos.length, (index) {
                    return Icon(
                      Icons.circle_rounded,
                      size: 10,
                      color:
                          index == indexSelect ? Colors.black : Colors.black12,
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          right: 12.0,
          top: 12.0,
          child: Container(
            decoration: BoxDecoration(
                color: ColorsApp.primary,
                borderRadius: BorderRadius.circular(25)),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Text(
              itemChangePhoto.toString() +
                  '/' +
                  widget.photos.length.toString(),
              style: GoogleFonts.montserrat(
                color: ColorsApp.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class LikeAlbum extends StatefulWidget {
  NotificationGeneralModel album;
  Function(NotificationGeneralModel) onPressedLike;
  LikeAlbum({Key? key, required this.album, required this.onPressedLike})
      : super(key: key);

  @override
  State<LikeAlbum> createState() => _LikeAlbumState();
}

class _LikeAlbumState extends State<LikeAlbum> {
  NotificationGeneralModel albumData = NotificationGeneralModel();
  @override
  void initState() {
    albumData = widget.album;
    super.initState();
  }

  final userPreferences = UserPreferences();
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (!userPreferences.isWorkerChild) {
            widget.onPressedLike(albumData);
            setState(() {
              albumData.like = !albumData.like;
            });
          }
        },
        icon: albumData.like
            ? const Icon(Icons.favorite, color: ColorsApp.danger, size: 30)
            : const Icon(Icons.favorite_outline,
                color: ColorsApp.primary, size: 30));
  }
}
