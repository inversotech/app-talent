import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'custom_footer_loading.dart';

/// Pantalla secundaria para navegación stack.
/// Usar esta pantalla para páginas que se abren desde la principal
/// (justificaciones, permisos, vacaciones, etc.)
class SecondaryScreen extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget? titleWidget;
  final RefreshController? refreshController;
  final Function()? onRefresh;
  final Function()? onLoading;
  final ScrollController scrollController;
  final bool enablePullDown;
  final bool enablePullUp;
  final Widget? floatingActionButton;
  final VoidCallback? onBackPressed;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final Color colorLoading;
  final Color backgroundColor;
  final List<Widget>? actions;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  SecondaryScreen({
    this.title = '',
    this.titleWidget,
    required this.child,
    required this.scrollController,
    this.refreshController,
    this.onRefresh,
    this.onLoading,
    this.enablePullDown = false,
    this.enablePullUp = false,
    this.floatingActionButton,
    this.onBackPressed,
    this.paddingLeft = 12,
    this.paddingRight = 12,
    this.paddingTop = 8,
    this.paddingBottom = 8,
    this.colorLoading = ColorsApp.primary,
    this.backgroundColor = ColorsApp.white,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorsApp.primary, ColorsApp.primaryVariant],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          body: _buildBody(),
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: onBackPressed ?? () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      centerTitle: true,
      title: titleWidget ??
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
      actions: actions,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: ColoredBox(
          color: backgroundColor,
          child: Padding(
            padding: EdgeInsets.only(
              left: paddingLeft,
              right: paddingRight,
              top: paddingTop,
              bottom: paddingBottom,
            ),
            child: _buildSmartRefresher(
              child: SingleChildScrollView(child: child),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmartRefresher({required Widget child}) {
    return SmartRefresher(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      controller: refreshController ?? _refreshController,
      onRefresh: enablePullDown ? onRefresh : null,
      onLoading: enablePullUp ? onLoading : null,
      scrollDirection: Axis.vertical,
      header: const WaterDropMaterialHeader(),
      footer: CustomFooterLoading(colorLoading: colorLoading),
      scrollController: scrollController,
      physics: const ScrollPhysics(),
      child: child,
    );
  }
}
