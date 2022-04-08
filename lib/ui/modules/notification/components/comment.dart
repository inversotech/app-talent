import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/controllers/notification/comment_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/notification/comment.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

class Comment extends StatelessWidget {
  final String origen;
  final String idOrigen;
  final String idParent;
  final bool focusState;
  final int indexOrigen;
  const Comment(
      {Key? key,
      required this.origen,
      required this.idOrigen,
      required this.indexOrigen,
      this.focusState = true,
      this.idParent = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentController>(
        init: CommentController(
            origen: origen,
            idOrigen: idOrigen,
            idParent: idParent,
            indexOrigen: indexOrigen),
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
                              'Comentarios',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  color: ColorsApp.primary),
                            ),
                          ),
                        ),
                      ),
                      const Divider(color: ColorsApp.primary, thickness: 1),
                      Container(child: _listComments(controller)),
                      const SizedBox(
                        height: 80.0,
                      ),
                    ],
                  )
                : Container()),
            bottomSheet: !controller.userPref.isWorkerChild
                ? Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    color: ColorsApp.primaryVariant,
                    child: Container(
                      color: ColorsApp.primaryVariant,
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Container(
                        color: ColorsApp.white,
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 12.0, top: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => controller.answerParent.value
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, left: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                              child: Text(
                                                  'Responder a ' +
                                                      controller
                                                          .answerUserParent
                                                          .value,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          ColorsApp.control))),
                                          IconButton(
                                              icon: const Icon(Icons.close,
                                                  color: Colors.black),
                                              onPressed: () {
                                                controller
                                                    .fnCloseAnswerParent();
                                              })
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              controller: controller.mensaje,
                              autofocus: focusState,
                              focusNode: controller.focusNode,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 8.0),
                                  alignLabelWithHint: true,
                                  icon: controller.userPref.photoUrl!.isNotEmpty
                                      ? SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: controller
                                                  .userPref.photoUrl
                                                  .toString(),
                                              placeholder: (context, url) =>
                                                  const Icon(Icons.person),
                                              errorWidget:
                                                  (context, url, error) {
                                                return const Icon(Icons.person);
                                              },
                                            ),
                                          ))
                                      : const Icon(Icons.person),
                                  labelStyle: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      color: ColorsApp.primary),
                                  labelText: 'Escribir comentario',
                                  hintText: 'Escribir comentario...',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never),
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  color: ColorsApp.primary),
                              onEditingComplete: () {
                                controller.fnSaveComment(
                                    controller.idOrigen.toString(), 0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : null,
          );
        });
  }

  Widget _listComments(CommentController controller) {
    if (controller.listData.isNotEmpty) {
      return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
              children: List.generate(controller.listData.length, (index) {
            final item = controller.listData[index];
            return Column(children: [
              TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    backgroundColor: item.pressDelete ? ColorsApp.info : null),
                onLongPress: () {
                  if (!controller.userPref.isWorkerChild) {
                    controller.fnPressDelete(item, index, 0, false);
                  }
                },
                onPressed: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 35,
                        height: 35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: item.personaAvatar.toString(),
                            placeholder: (context, url) =>
                                const Icon(Icons.person),
                            errorWidget: (context, url, error) {
                              return const Icon(Icons.person);
                            },
                          ),
                        )),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.visible,
                                    text: TextSpan(
                                      text:
                                          item.personaFullname.toString() + ' ',
                                      style: GoogleFonts.montserrat(
                                          color: ColorsApp.primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: item.mensaje,
                                            style: GoogleFonts.montserrat(
                                                color: ColorsApp.primary,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.0)),
                                      ],
                                    ),
                                  ),
                                ),
                                !item.pressDelete
                                    ? LikeComment(
                                        comment: item,
                                        onPressedLike: (val) {
                                          if (!controller
                                              .userPref.isWorkerChild) {
                                            controller.fnPressLikeComment(
                                                item, index, 0, false);
                                          }
                                        })
                                    : IconButton(
                                        onPressed: () {
                                          if (!controller
                                              .userPref.isWorkerChild) {
                                            controller.fnPressDeleteComment(
                                                item, index, 0, false);
                                          }
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: ColorsApp.danger),
                                      ),
                                item.pressDelete
                                    ? IconButton(
                                        onPressed: () {
                                          if (!controller
                                              .userPref.isWorkerChild) {
                                            controller.fnPressClose(
                                                item, index, 0, false);
                                          }
                                        },
                                        icon: const Icon(Icons.close,
                                            color: Colors.black))
                                    : Container()
                              ],
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            SingleChildScrollView(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                        Jiffy(item.updatedAt,
                                                "yyyy-MM-dd HH:mm:ss")
                                            .fromNow(),
                                        style: GoogleFonts.montserrat(
                                            color: ColorsApp.control,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0)),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                      item.countLikes.toString() +
                                          (item.countLikes! > 1
                                              ? ' Me gustas'
                                              : ' Me gusta'),
                                      style: GoogleFonts.montserrat(
                                          color: ColorsApp.control,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0)),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: const EdgeInsets.all(4.0),
                                    ),
                                    onPressed: () {
                                      if (!controller.userPref.isWorkerChild) {
                                        controller.fnAnswerParent(item, index);
                                      }
                                    },
                                    child: Text('Responder',
                                        style: GoogleFonts.montserrat(
                                            color: ColorsApp.control,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _listCommentsChild(controller, item.comentarios!, index),
              item.countComentarios! > 0 && item.showMore
                  ? Padding(
                      padding: const EdgeInsets.only(left: 36.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.horizontal_rule,
                                color: ColorsApp.control),
                            GestureDetector(
                              onTap: () {
                                controller.fnShowComments(item, index);
                              },
                              child: Text(
                                  'Ver ' +
                                      (item.comentarios!.isEmpty
                                          ? item.countComentarios.toString() +
                                              (item.countComentarios! > 1
                                                  ? ' respuestas'
                                                  : ' respuesta')
                                          : 'más respuestas'),
                                  style: GoogleFonts.montserrat(
                                      color: ColorsApp.control,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ]);
          })));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text('No hay comentarios para mostrar.',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: ColorsApp.primary)),
        ),
      );
    }
  }

  Widget _listCommentsChild(CommentController controller,
      List<CommentModel> listData, int indexParent) {
    if (listData.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 8.0),
        child: ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            primary: false,
            itemBuilder: (context, index) {
              final item = listData[index];
              return TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    backgroundColor: item.pressDelete ? ColorsApp.info : null),
                onLongPress: () {
                  if (!controller.userPref.isWorkerChild) {
                    controller.fnPressDelete(item, indexParent, index, true);
                  }
                },
                onPressed: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 35,
                        height: 35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: item.personaAvatar.toString(),
                            placeholder: (context, url) =>
                                const Icon(Icons.person),
                            errorWidget: (context, url, error) {
                              return const Icon(Icons.person);
                            },
                          ),
                        )),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.visible,
                                    text: TextSpan(
                                      text:
                                          item.personaFullname.toString() + ' ',
                                      style: GoogleFonts.montserrat(
                                          color: ColorsApp.primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: item.mensaje,
                                            style: GoogleFonts.montserrat(
                                                color: ColorsApp.primary,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.0)),
                                      ],
                                    ),
                                  ),
                                ),
                                !item.pressDelete
                                    ? LikeComment(
                                        comment: item,
                                        onPressedLike: (val) {
                                          if (!controller
                                              .userPref.isWorkerChild) {
                                            controller.fnPressLikeComment(
                                                item, indexParent, index, true);
                                          }
                                        })
                                    : IconButton(
                                        onPressed: () {
                                          if (!controller
                                              .userPref.isWorkerChild) {
                                            controller.fnPressDeleteComment(
                                                item, indexParent, index, true);
                                          }
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: ColorsApp.danger),
                                      ),
                                item.pressDelete
                                    ? IconButton(
                                        onPressed: () {
                                          if (!controller
                                              .userPref.isWorkerChild) {
                                            controller.fnPressClose(
                                                item, indexParent, index, true);
                                          }
                                        },
                                        icon: const Icon(Icons.close,
                                            color: Colors.black))
                                    : Container()
                              ],
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            SingleChildScrollView(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                        Jiffy(item.updatedAt,
                                                "yyyy-MM-dd HH:mm:ss")
                                            .fromNow(),
                                        style: GoogleFonts.montserrat(
                                            color: ColorsApp.control,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0)),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                      item.countLikes.toString() +
                                          (item.countLikes! > 1
                                              ? ' Me gustas'
                                              : ' Me gusta'),
                                      style: GoogleFonts.montserrat(
                                          color: ColorsApp.control,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16.0);
            },
            itemCount: listData.length),
      );
    } else {
      return Container();
    }
  }
}

// ignore: must_be_immutable
class LikeComment extends StatefulWidget {
  CommentModel comment;
  Function(CommentModel) onPressedLike;
  LikeComment({Key? key, required this.comment, required this.onPressedLike})
      : super(key: key);

  @override
  State<LikeComment> createState() => _LikeCommentState();
}

class _LikeCommentState extends State<LikeComment> {
  CommentModel commentData = CommentModel();
  @override
  void initState() {
    commentData = widget.comment;
    super.initState();
  }

  final userPref = UserPreferences();
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (!userPref.isWorkerChild) {
            widget.onPressedLike(commentData);
            setState(() {
              commentData.like = !commentData.like;
            });
          }
        },
        icon: commentData.like
            ? const Icon(Icons.favorite, color: ColorsApp.danger)
            : const Icon(Icons.favorite_outline, color: ColorsApp.primary));
  }
}
