import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/controllers/account_status/account_status_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';
import 'package:lamb_talent/shared/components/app_card.dart';
import 'package:lamb_talent/shared/components/app_text.dart';
import 'package:lamb_talent/shared/components/app_button.dart';
import 'package:lamb_talent/shared/components/loading.dart';

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
        didUpdateWidget: (_, stateBuilder) {
          stateBuilder.controller!.onInit();
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
                  child: Builder(builder: (BuildContext context) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    final carouselHeight =
                        screenHeight - 200; // Resta AppBar, tabs, padding

                    return Column(
                      children: [
                        // Indicadores fijos
                        Obx(() => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Spacing.sm,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List<Widget>.generate(5, (index) {
                                  final isActive =
                                      index == controller.selectSlider.value;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    width: isActive ? 24 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? ColorsApp.white
                                          : ColorsApp.white
                                              .withValues(alpha: 0.3),
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.sm),
                                    ),
                                  );
                                }),
                              ),
                            )),
                        !controller.loadingGeneral.value
                            ? CarouselSlider(
                                items: [
                                  _buildSlide0(),
                                  _buildSlide1(),
                                  _buildSlide2(),
                                  _buildSlide3(),
                                  _buildSlide4(),
                                ],
                                carouselController:
                                    controller.controllerCarousel,
                                options: CarouselOptions(
                                  onPageChanged: (val,
                                      CarouselPageChangedReason reason) async {
                                    controller.selectSlider.value = val;
                                    controller.loadListDetail();
                                  },
                                  height: carouselHeight,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: false,
                                  scrollDirection: Axis.horizontal,
                                ),
                              )
                            : Container()
                      ],
                    );
                  }),
                )
              : Container());
        });
  }

  // Slide 0: Sueldo depositado
  Widget _buildSlide0() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderCard(
            title: 'Sueldo',
            titleContinue: 'depositado',
            amount: controller.dataGeneral.containsKey('sueldo_depositado')
                ? controller.dataGeneral['sueldo_depositado'].toString()
                : '0',
            showBoleta: true,
          ),
          const SizedBox(height: Spacing.sm),
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: !controller.loadingDetail.value &&
                        controller.selectSlider.value == 0
                    ? DepositedSalary(
                        key: const ValueKey('salary'),
                        dateModel: controller.dateModel.value,
                        data: controller.dataDetail,
                        onChange: (val) {
                          if (val) {
                            loadingIndicator(onlyLoading: true, opacity: true);
                          } else {
                            Get.until((route) => !Get.isDialogOpen!);
                          }
                        },
                      )
                    : _buildDetailPlaceholder(),
              )),
        ],
      ),
    );
  }

  // Slide 1: Ayudas depositado
  Widget _buildSlide1() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderCard(
            title: 'Ayudas',
            titleContinue: 'depositado',
            amount: controller.dataGeneral.containsKey('ayudas')
                ? (double.parse(controller.dataGeneral['ayudas'].toString()) > 0
                    ? controller.dataGeneral['ayudas'].toString()
                    : (controller.dataGeneral.containsKey('ayudas_saldo')
                        ? controller.dataGeneral['ayudas_saldo'].toString()
                        : '0'))
                : '0',
          ),
          const SizedBox(height: Spacing.sm),
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: !controller.loadingDetail.value &&
                        controller.selectSlider.value == 1
                    ? DepositedHelpTravel(
                        key: const ValueKey('help'),
                        code: 'help',
                        dateModel: controller.dateModel.value,
                        onChange: (val) {
                          if (val) {
                            loadingIndicator(onlyLoading: true, opacity: true);
                          } else {
                            Get.until((route) => !Get.isDialogOpen!);
                          }
                        },
                        data: controller.dataDetail,
                        title: 'Ayudas depositado',
                      )
                    : _buildDetailPlaceholder(),
              )),
        ],
      ),
    );
  }

  // Slide 2: Viajes depositado
  Widget _buildSlide2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderCard(
            title: 'Viajes',
            titleContinue: 'depositado',
            amount: controller.dataGeneral.containsKey('viajes')
                ? (double.parse(controller.dataGeneral['viajes'].toString()) > 0
                    ? controller.dataGeneral['viajes'].toString()
                    : (controller.dataGeneral.containsKey('viajes_saldo')
                        ? controller.dataGeneral['viajes_saldo'].toString()
                        : '0'))
                : '0',
          ),
          const SizedBox(height: Spacing.sm),
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: !controller.loadingDetail.value &&
                        controller.selectSlider.value == 2
                    ? DepositedHelpTravel(
                        key: const ValueKey('travel'),
                        code: 'travel',
                        dateModel: controller.dateModel.value,
                        onChange: (val) {
                          if (val) {
                            loadingIndicator(onlyLoading: true, opacity: true);
                          } else {
                            Get.until((route) => !Get.isDialogOpen!);
                          }
                        },
                        data: controller.dataDetail,
                        title: 'Viajes depositado',
                      )
                    : _buildDetailPlaceholder(),
              )),
        ],
      ),
    );
  }

  // Slide 3: Convenios personales
  Widget _buildSlide3() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderCard(
            title: 'Convenios',
            titleContinue: 'personales',
            amount: controller.dataGeneral.containsKey('adelanto_ayudas')
                ? controller.dataGeneral['adelanto_ayudas'].toString()
                : '0',
          ),
          const SizedBox(height: Spacing.sm),
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: !controller.loadingDetail.value &&
                        controller.selectSlider.value == 3
                    ? AppCard(
                        key: const ValueKey('convenios'),
                        child: Detail(
                          listData: controller.listDataDetail,
                          isModal: false,
                          title: 'Convenios personales',
                        ),
                      )
                    : _buildDetailPlaceholder(),
              )),
        ],
      ),
    );
  }

  // Slide 4: A rendir
  Widget _buildSlide4() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderCard(
            title: 'A rendir',
            amount: controller.dataGeneral.containsKey('a_rendir')
                ? controller.dataGeneral['a_rendir'].toString()
                : '0',
          ),
          const SizedBox(height: Spacing.sm),
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: !controller.loadingDetail.value &&
                        controller.selectSlider.value == 4
                    ? AppCard(
                        key: const ValueKey('rendir'),
                        child: Detail(
                          listData: controller.listDataDetail,
                          isModal: false,
                          title: 'A rendir',
                        ),
                      )
                    : _buildDetailPlaceholder(),
              )),
        ],
      ),
    );
  }

  // Card header con estilo del sistema de diseño
  Widget _buildHeaderCard({
    required String title,
    String? titleContinue,
    required String amount,
    bool showBoleta = false,
  }) {
    final format = NumberFormat.currency(symbol: 'S/. ', locale: 'en_US');

    return AppCard.spacious(
      backgroundColor: ColorsApp.neutral50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filtro de fecha
          InkWell(
            onTap: () => controller.selectDate(),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.sm,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorsApp.neutral300,
                ),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: ColorsApp.primary,
                  ),
                  const SizedBox(width: Spacing.sm),
                  AppText.label(
                    '${controller.dateModel.value.nameMonth}, ${controller.dateModel.value.year}',
                    color: ColorsApp.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          // Contenido principal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 32,
                    color: ColorsApp.primary,
                  ),
                  const SizedBox(height: Spacing.xs),
                  AppText.h2(title, color: ColorsApp.neutral800),
                  if (titleContinue != null)
                    AppText.h2(titleContinue, color: ColorsApp.neutral800),
                ],
              ),
              if (showBoleta)
                AppButton.text(
                  text: 'Ver boleta',
                  icon: Icons.picture_as_pdf_outlined,
                  onPressed: () => controller.getTicketPayment(),
                ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          // Monto
          AppText.display1(
            format.format(double.parse(amount)),
            color: ColorsApp.primary,
          ),
        ],
      ),
    );
  }

  // Placeholder mientras carga el detalle
  Widget _buildDetailPlaceholder() {
    return const SizedBox(
      key: ValueKey('placeholder'),
      height: 100,
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
