import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/controllers/account_status/account_status_controller.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';
import 'package:lamb_talent/shared/components/loading.dart';

import 'components/carousel_slider_item.dart';
import 'components/deposited_help_travel.dart';
import 'components/deposited_salary.dart';
import 'components/detail.dart';

class AccountStatusPage extends StatelessWidget {
  AccountStatusPage({Key? key}) : super(key: key);

  final controller = Get.put(AccountStatusController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountStatusController>(
        init: AccountStatusController(),
        didUpdateWidget: (_, _stateBuilder) {
          _stateBuilder.controller!.onInit();
        },
        builder: (_) {
          return Obx(() => !controller.loadingData.value
              ? AppScreen(
                  codePage: '16120102',
                  principalPage: true,
                  refreshController: controller.refreshController,
                  scrollController: controller.scrollController,
                  enablePullDown: true,
                  enablePullUp: false,
                  showTabs: true,
                  onRefresh: controller.onRefresh,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Column(
                      children: [
                        !controller.loadingGeneral.value
                            ? CarouselSlider(
                                items: [
                                    CarouselSliderItem(
                                      showBoleta: true,
                                      title: 'Sueldo',
                                      titleContinue: 'depositado',
                                      amount: controller.dataGeneral
                                              .containsKey('sueldo_depositado')
                                          ? controller
                                              .dataGeneral['sueldo_depositado']
                                              .toString()
                                          : '0',
                                      dateModel: controller.dateModel.value,
                                      indexItem: 0,
                                      itemCount: 5,
                                      onPressed: () {
                                        controller.getTicketPayment();
                                      },
                                      onPressedDate: () {
                                        controller.selectDate();
                                      },
                                    ),
                                    CarouselSliderItem(
                                      title: 'Ayudas',
                                      titleContinue: 'depositado',
                                      amount: controller.dataGeneral
                                              .containsKey('ayudas')
                                          ? (double.parse(controller
                                                      .dataGeneral['ayudas']
                                                      .toString()) >
                                                  0
                                              ? controller.dataGeneral['ayudas']
                                                  .toString()
                                              : (controller.dataGeneral
                                                      .containsKey(
                                                          'ayudas_saldo')
                                                  ? controller.dataGeneral[
                                                          'ayudas_saldo']
                                                      .toString()
                                                  : '0'))
                                          : '0',
                                      dateModel: controller.dateModel.value,
                                      indexItem: 1,
                                      itemCount: 5,
                                      onPressed: () {
                                        controller.getTicketPayment();
                                      },
                                      onPressedDate: () {
                                        controller.selectDate();
                                      },
                                    ),
                                    CarouselSliderItem(
                                      title: 'Viajes',
                                      titleContinue: 'depositado',
                                      amount: controller.dataGeneral
                                              .containsKey('viajes')
                                          ? (double.parse(controller
                                                      .dataGeneral['viajes']
                                                      .toString()) >
                                                  0
                                              ? controller.dataGeneral['viajes']
                                                  .toString()
                                              : (controller.dataGeneral
                                                      .containsKey(
                                                          'viajes_saldo')
                                                  ? controller.dataGeneral[
                                                          'viajes_saldo']
                                                      .toString()
                                                  : '0'))
                                          : '0',
                                      dateModel: controller.dateModel.value,
                                      indexItem: 2,
                                      itemCount: 5,
                                      onPressed: () {
                                        controller.getTicketPayment();
                                      },
                                      onPressedDate: () {
                                        controller.selectDate();
                                      },
                                    ),
                                    CarouselSliderItem(
                                      title: 'Convenios',
                                      titleContinue: 'personales',
                                      amount: controller.dataGeneral
                                              .containsKey('adelanto_ayudas')
                                          ? controller
                                              .dataGeneral['adelanto_ayudas']
                                              .toString()
                                          : '0',
                                      dateModel: controller.dateModel.value,
                                      indexItem: 3,
                                      itemCount: 5,
                                      onPressed: () {
                                        controller.getTicketPayment();
                                      },
                                      onPressedDate: () {
                                        controller.selectDate();
                                      },
                                    ),
                                    CarouselSliderItem(
                                      title: 'A rendir',
                                      amount: controller.dataGeneral
                                              .containsKey('a_rendir')
                                          ? controller.dataGeneral['a_rendir']
                                              .toString()
                                          : '0',
                                      dateModel: controller.dateModel.value,
                                      indexItem: 4,
                                      itemCount: 5,
                                      onPressed: () {
                                        controller.getTicketPayment();
                                      },
                                      onPressedDate: () {
                                        controller.selectDate();
                                      },
                                    )
                                  ],
                                carouselController:
                                    controller.controllerCarousel,
                                options: CarouselOptions(
                                  onPageChanged: (val,
                                      CarouselPageChangedReason reason) async {
                                    controller.selectSlider.value = val;
                                    controller.loadListDetail();
                                  },
                                  height: 268,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: false,
                                  scrollDirection: Axis.horizontal,
                                ))
                            : Container(),
                        !controller.loadingDetail.value
                            ? _bodySlect()
                            : Container()
                      ],
                    );
                  }),
                )
              : Container());
        });
  }

  Widget _bodySlect() {
    Widget widgetResp = Container();
    switch (controller.selectSlider.value) {
      case 0:
        widgetResp = DepositedSalary(
          dateModel: controller.dateModel.value,
          data: controller.dataDetail,
          onChange: (val) {
            if (val) {
              loadingIndicator(onlyLoading: true, opacity: true);
            } else {
              if (Get.isDialogOpen!) {
                Get.back();
              }
            }
          },
        );
        break;
      case 1:
        widgetResp = DepositedHelpTravel(
          code: 'help',
          dateModel: controller.dateModel.value,
          onChange: (val) {
            if (val) {
              loadingIndicator(onlyLoading: true, opacity: true);
            } else {
              if (Get.isDialogOpen!) {
                Get.back();
              }
            }
          },
          data: controller.dataDetail,
          title: 'Ayudas depositado',
        );
        break;
      case 2:
        widgetResp = DepositedHelpTravel(
          code: 'travel',
          dateModel: controller.dateModel.value,
          onChange: (val) {
            if (val) {
              loadingIndicator(onlyLoading: true, opacity: true);
            } else {
              if (Get.isDialogOpen!) {
                Get.back();
              }
            }
          },
          data: controller.dataDetail,
          title: 'Viajes depositado',
        );
        break;
      case 3:
        widgetResp = Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Detail(
                listData: controller.listDataDetail,
                isModal: false,
                title: 'Convenios personales'),
          ),
        );
        break;
      case 4:
        widgetResp = Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Detail(
                listData: controller.listDataDetail,
                isModal: false,
                title: 'A rendir'),
          ),
        );
        break;
      default:
        widgetResp = Container();
    }
    return widgetResp;
  }
}
