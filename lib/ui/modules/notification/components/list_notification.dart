import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/resources/models/notification/notification_general.dart';

class ListNotification extends StatelessWidget {
  final List<NotificationGeneralModel> listData;
  final BoxConstraints constraints;
  final void Function(NotificationGeneralModel) onPressed;
  Function(Foto) onPressedLike;
  Function(Foto) onPressedComment;
  Function(Foto) onPressedShare;
  ListNotification(
      {Key? key,
      required this.listData,
      required this.constraints,
      required this.onPressed,
      required this.onPressedLike,
      required this.onPressedComment,
      required this.onPressedShare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (listData.isNotEmpty) {
      return ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          primary: false,
          itemBuilder: (context, index) {
            final item = listData[index];
            return Column(
              children: [_getCardNotify(item)],
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
                height: 1, color: ColorsApp.primary, thickness: 2);
          },
          itemCount: listData.length);
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

  Widget _getCardNotify(NotificationGeneralModel item) {
    Widget result = Container();
    switch (item.codigo) {
      case 'msm_evento':
        result = _cardEvent(item);
        break;
      case 'msm_album':
        result = _cardAlbum(item);
        break;
      case 'msm_notificacion':
        result = _cardNotification(item);
        break;
      default:
    }
    return result;
  }

  Widget _cardEvent(NotificationGeneralModel item) {
    final month = capitalize(DateFormat.MMM('es').format(item.fechaInicio!));
    final monthAbbreviation = month.substring(0, month.length - 1);
    List<Widget> groupsWidget = [];
    for (var val in item.grupos!) {
      groupsWidget.add(Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: ColorsApp.primary),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
          child: Text(val.grupoNombre.toString(),
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  color: ColorsApp.white,
                  fontSize: 14.0)),
        ),
      ));
    }
    return SizedBox(
      width: double.infinity,
      child: InkWell(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  item.imagenUrl!.isNotEmpty &&
                          !item.imagenUrl!.contains('empty')
                      ? SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: item.imagenUrl.toString(),
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) {
                                return Container();
                              },
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 12.0, left: 12.0, top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        item.showFechaHora == '1'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(monthAbbreviation,
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 25.0)),
                                  Text(item.fechaInicio!.day.toString(),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 25.0))
                                ],
                              )
                            : Container(),
                        const SizedBox(width: 12.0),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.mensaje.toString(),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0)),
                              item.showFechaHora == '1'
                                  ? Text(
                                      DateFormat.MMMMd('es')
                                              .format(item.fechaInicio!) +
                                          ' ' +
                                          Jiffy(item.fechaInicio.toString(),
                                                  'yyyy-MM-dd HH:mm')
                                              .format('hh:mm a'),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0))
                                  : Container(),
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
                ],
              ),
            ),
          ),
          onTap: () {
            onPressed(item);
          }),
    );
  }

  Widget _cardAlbum(NotificationGeneralModel item) {
    final month = capitalize(DateFormat.MMM('es').format(item.fechaInicio!));
    final monthAbbreviation = month.substring(0, month.length - 1);
    List<Widget> groupsWidget = [];
    for (var val in item.grupos!) {
      groupsWidget.add(Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: ColorsApp.primary),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
          child: Text(val.grupoNombre.toString(),
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
        child: Column(
          children: [
            CardPhotos(
              photos: item.fotos!,
              onPressedLike: (photo) {
                onPressedLike(photo);
              },
              onPressedComment: (photo) {
                onPressedComment(photo);
              },
              onPressedShare: (photo) {
                onPressedShare(photo);
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 12.0, left: 12.0, bottom: 12.0),
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(monthAbbreviation,
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400, fontSize: 25.0)),
                        Text(item.fechaInicio!.day.toString(),
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400, fontSize: 25.0))
                      ],
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.mensaje.toString(),
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400, fontSize: 16.0)),
                          Text(DateFormat.MMMMd('es').format(item.fechaInicio!),
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
            // onPressed(item);
          ],
        ),
      ),
    );
  }

  Widget _cardNotification(NotificationGeneralModel item) {
    List<Widget> groupsWidget = [];
    for (var val in item.grupos!) {
      groupsWidget.add(Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: ColorsApp.primary),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
          child: Text(val.grupoNombre.toString(),
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  color: ColorsApp.white,
                  fontSize: 14.0)),
        ),
      ));
    }
    return SizedBox(
      width: double.infinity,
      child: InkWell(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: groupsWidget,
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat.MMMMd('es').format(item.fechaInicio!),
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500, fontSize: 16.0)),
                      Text(
                          Jiffy(item.fechaInicio.toString(), 'yyyy-MM-dd HH:mm')
                              .format('hh:mm a'),
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400, fontSize: 12.0)),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(item.mensaje.toString(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400, fontSize: 16.0)),
                  const SizedBox(height: 8.0),
                  item.imagenUrl!.isNotEmpty &&
                          !item.imagenUrl!.contains('empty')
                      ? SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: item.imagenUrl.toString(),
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) {
                                return Container();
                              },
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          onTap: () {
            onPressed(item);
          }),
    );
  }
}

class CardPhotos extends StatefulWidget {
  List<Foto> photos;
  Function(Foto) onPressedLike;
  Function(Foto) onPressedComment;
  Function(Foto) onPressedShare;
  CardPhotos(
      {Key? key,
      required this.photos,
      required this.onPressedLike,
      required this.onPressedComment,
      required this.onPressedShare})
      : super(key: key);

  @override
  State<CardPhotos> createState() => _CardPhotosState();
}

class _CardPhotosState extends State<CardPhotos> {
  int itemChangePhoto = 1;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CarouselSlider(
          items: List.generate(
              widget.photos.length,
              (indexItem) => Builder(builder: (context) {
                    Foto photo = widget.photos[indexItem];
                    return Column(
                      children: [
                        photo.imagenUrl!.isNotEmpty &&
                                !photo.imagenUrl!.contains('empty')
                            ? SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fitHeight,
                                    imageUrl: photo.imagenUrl.toString(),
                                    placeholder: (context, url) => Container(),
                                    errorWidget: (context, url, error) {
                                      return Container();
                                    },
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        widget.onPressedLike(photo);
                                        setState(() {
                                          photo.like = !photo.like;
                                        });
                                      },
                                      icon: Icon(photo.like
                                          ? Icons.favorite
                                          : Icons.favorite_outline)),
                                  IconButton(
                                      onPressed: () {
                                        widget.onPressedComment(photo);
                                      },
                                      icon: const Icon(
                                          Icons.mode_comment_outlined)),
                                ],
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    direction: Axis.horizontal,
                                    children: List<Widget>.generate(
                                        widget.photos.length, (index) {
                                      return Icon(
                                        Icons.circle_rounded,
                                        size: 10,
                                        color: index == indexItem
                                            ? Colors.black
                                            : Colors.black12,
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: null, icon: Container()),
                                  IconButton(
                                      onPressed: () {
                                        widget.onPressedShare(photo);
                                      },
                                      icon: const Icon(Icons.share)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  })),
          options: CarouselOptions(
            height: 350,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                itemChangePhoto = index + 1;
              });
            },
          ),
        ),
        Positioned(
          right: 12.0,
          top: 12.0,
          child: Container(
            decoration: BoxDecoration(
                color: ColorsApp.control,
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
