import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/general/menu.dart';
import 'package:lamb_talent/resources/services/general/worker_service.dart';
import 'package:lamb_talent/shared/components/search_delegate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'change_entity.dart';
import 'custom_footer_loading.dart';

/// Código del tab de notificaciones
const String kNotificationTabCode = '16120104';

class AppScreen extends StatelessWidget {
  final Widget child;
  final String codePage;
  final RefreshController? refreshController;
  final Function()? onRefresh;
  final Function()? onLoading;
  final ScrollController scrollController;
  final bool enablePullDown;
  final bool enablePullUp;
  final bool showTabs;
  final bool principalPage;
  final bool showSearchPerson;
  final Widget? floatingActionButton;
  final Widget? bottomSheet;
  final bool showTitleHeader;
  final double leftBeforeBackground;
  final double rightBeforeBackground;
  final double bottomBeforeBackground;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final Color colorLoading;
  final VoidCallback? onShowQr;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final Color backgroundColor;

  final userPreferences = UserPreferences();

  AppScreen({
    required this.codePage,
    required this.child,
    this.refreshController,
    this.onRefresh,
    this.onLoading,
    required this.scrollController,
    this.enablePullDown = false,
    this.enablePullUp = false,
    this.showTabs = false,
    this.principalPage = false,
    this.showTitleHeader = true,
    this.showSearchPerson = true,
    this.floatingActionButton,
    this.bottomSheet,
    this.leftBeforeBackground = 4,
    this.rightBeforeBackground = 4,
    this.bottomBeforeBackground = 4,
    this.paddingLeft = Spacing.lg,
    this.paddingRight = Spacing.lg,
    this.paddingTop = Spacing.md,
    this.paddingBottom = Spacing.md,
    this.backgroundColor = ColorsApp.white,
    this.colorLoading = ColorsApp.primary,
    this.onShowQr,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final tabsData = _buildTabs();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: principalPage ? ColorsApp.primary : null,
          gradient: principalPage
              ? null
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ColorsApp.neutral50, ColorsApp.neutral100],
                ),
        ),
        child: DefaultTabController(
          initialIndex: tabsData.initialIndex,
          length: tabsData.tabs.length,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildAppBar(context),
            body: _buildBody(),
            bottomNavigationBar: _buildBottomNavBar(tabsData),
            bottomSheet: bottomSheet,
            floatingActionButton: floatingActionButton,
          ),
        ),
      ),
    );
  }

  /// Obtiene el saludo según la hora del día
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos días, ';
    } else if (hour < 19) {
      return 'Buenas tardes, ';
    } else {
      return 'Buenas noches, ';
    }
  }

  /// Obtiene el nombre a mostrar
  String _getDisplayName() {
    if (userPreferences.fullnamePerson == null) {
      return '';
    }
    if (!userPreferences.isWorkerChild) {
      final split = userPreferences.fullnamePerson.toString().split(' ');
      return '${split[0]} ${split.length > 1 ? split[1] : ''}';
    }
    return userPreferences.fullnamePerson.toString();
  }

  /// Construye los tabs y retorna el índice inicial
  _TabsData _buildTabs() {
    int initialIndex = 0;
    List<Widget> tabs = [];
    List<Menu> menu = userPreferences.menu ?? [];

    for (int index = 0; index < menu.length; index++) {
      final element = menu[index];
      if (codePage == element.code) {
        initialIndex = index;
      }
      tabs.add(_buildTabItem(element));
    }

    return _TabsData(tabs: tabs, initialIndex: initialIndex);
  }

  /// Construye un item de tab individual
  Widget _buildTabItem(Menu element) {
    final isSelected = codePage == element.code;
    final hasNotifications =
        element.code == kNotificationTabCode && userPreferences.cantNotify > 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: hasNotifications
            ? _buildTabWithBadge(element, isSelected)
            : _buildTabContent(element, isSelected),
      ),
    );
  }

  /// Contenido básico del tab (ícono + título)
  Widget _buildTabContent(Menu element, bool isSelected) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Image.asset(
          element.icon.toString(),
          height: 30.0,
          fit: BoxFit.cover,
          color:
              isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
        ),
        Text(element.title.toString()),
      ],
    );
  }

  /// Tab con badge de notificaciones
  Widget _buildTabWithBadge(Menu element, bool isSelected) {
    return Stack(
      children: [
        _buildTabContent(element, isSelected),
        Positioned(
          top: 0.0,
          left: 0.0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: ColorsApp.danger,
              borderRadius: BorderRadius.circular(50),
            ),
            constraints: const BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: Text(
              userPreferences.cantNotify.toString(),
              style: GoogleFonts.montserrat(
                color: ColorsApp.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  /// Construye el AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: showTitleHeader ? 72.0 : null,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [ColorsApp.primary, ColorsApp.primaryLight],
          ),
        ),
      ),
      title: Row(
        children: [
          // Logo LAMB
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset('assets/icons/logo.png', fit: BoxFit.contain),
          ),
          const SizedBox(width: Spacing.sm),
          // Saludo + nombre + entidad
          if (showTitleHeader)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!userPreferences.isWorkerChild)
                    Text(
                      '${_getGreeting()} 👋',
                      style: GoogleFonts.montserrat(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  Text(
                    _getDisplayName(),
                    style: GoogleFonts.montserrat(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (userPreferences.nameEntity != null)
                    Text(
                      userPreferences.nameEntity.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => _showSettingsModal(context),
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
        ),
      ],
    );
  }

  /// Modal de configuración — agrupa acciones según permisos del usuario
  void _showSettingsModal(BuildContext context) {
    final canChangeEntity =
        userPreferences.cantEntities > 1 || userPreferences.cantDeptos > 1;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: ColorsApp.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.lg),
              topRight: Radius.circular(AppRadius.lg),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ColorsApp.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Info del usuario
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    Spacing.lg, Spacing.sm, Spacing.lg, Spacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: ColorsApp.neutral100,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Image.asset('assets/icons/logo.png',
                          fit: BoxFit.contain),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userPreferences.fullnamePerson?.toString() ?? '',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorsApp.neutral900,
                            ),
                          ),
                          if (userPreferences.nameEntity != null)
                            Text(
                              userPreferences.nameEntity.toString(),
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: ColorsApp.neutral500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Opciones según permisos
              if (onShowQr != null)
                _buildSettingsOption(
                  icon: Icons.qr_code_2,
                  label: 'Ver QR',
                  onTap: () {
                    Navigator.pop(ctx);
                    onShowQr!();
                  },
                ),
              if (canChangeEntity)
                _buildSettingsOption(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Cambiar entidad',
                  onTap: () {
                    Navigator.pop(ctx);
                    showModalChangeEntity(context);
                  },
                ),
              if (userPreferences.searchPerson && showSearchPerson)
                _buildSettingsOption(
                  icon: Icons.person_search_outlined,
                  label: 'Buscar trabajador',
                  onTap: () {
                    Navigator.pop(ctx);
                    _searchWorker(context);
                  },
                ),
              if (userPreferences.isWorkerChild)
                _buildSettingsOption(
                  icon: Icons.arrow_back_outlined,
                  label: 'Volver a mis datos',
                  onTap: () {
                    Navigator.pop(ctx);
                    _backToHome();
                  },
                ),
              const Divider(height: 1),
              _buildSettingsOption(
                icon: Icons.logout_outlined,
                label: 'Cerrar sesión',
                color: ColorsApp.danger,
                onTap: () {
                  Navigator.pop(ctx);
                  _logout(context);
                },
              ),
              SizedBox(height: MediaQuery.of(ctx).padding.bottom + Spacing.sm),
            ],
          ),
        );
      },
    );
  }

  /// Opción individual del modal de configuración
  Widget _buildSettingsOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final effectiveColor = color ?? ColorsApp.neutral800;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg, vertical: Spacing.md),
        child: Row(
          children: [
            Icon(icon, color: effectiveColor, size: 22),
            const SizedBox(width: Spacing.md),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: effectiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el cuerpo de la pantalla
  Widget _buildBody() {
    final refresher = _buildSmartRefresher(
      child: principalPage
          ? SingleChildScrollView(child: child)
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: paddingTop),
                child: child,
              ),
            ),
    );

    if (principalPage) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
        ),
        child: refresher,
      );
    }

    return Container(
      padding: EdgeInsets.only(
        left: leftBeforeBackground,
        right: rightBeforeBackground,
        top: 0,
        bottom: bottomBeforeBackground,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          color: backgroundColor,
          padding: EdgeInsets.only(
            left: paddingLeft,
            right: paddingRight,
            top: 0,
            bottom: paddingBottom,
          ),
          child: refresher,
        ),
      ),
    );
  }

  /// Construye el SmartRefresher reutilizable
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

  /// Construye la barra de navegación inferior
  Widget? _buildBottomNavBar(_TabsData tabsData) {
    if (!showTabs) return null;

    return Container(
      color: ColorsApp.primary,
      child: TabBar(
        unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
        labelColor: Colors.white,
        indicatorColor: Colors.white,
        dividerColor: Colors.transparent,
        onTap: (val) {
          if (tabsData.initialIndex != val &&
              userPreferences.menu != null &&
              val < userPreferences.menu!.length) {
            Get.offAllNamed(userPreferences.menu![val].url.toString());
          }
        },
        labelPadding: const EdgeInsets.symmetric(vertical: 8.0),
        tabs: tabsData.tabs,
      ),
    );
  }

  /// Cierra sesión
  void _logout(BuildContext context) {
    final storage = GetStorage();
    storage.remove('passwordLamb');
    storage.remove('tokenLamb');
    String tokenNotify = userPreferences.tokenNotify;
    userPreferences.clear();
    userPreferences.tokenNotify = tokenNotify;
    Get.offAllNamed('login');
  }

  void _searchWorker(BuildContext buildContext) async {
    final searchResult = await showSearch(
      context: buildContext,
      delegate: SearchDelgateCustom(
          listData: (query) async {
            dynamic listPersons = [];
            Map<String, String> params = {
              'id_entidad': userPreferences.idEntity.toString(),
              // 'id_depto': userPreferences.idDeparment.toString(),
              'id_acceso_nivel': userPreferences.idNivelAcceso.isNotEmpty
                  ? userPreferences.idNivelAcceso.toString()
                  : '',
              'search_option': userPreferences.searchOption.toString(),
              'restringido': 'S',
              'per_page': '15',
              'page': '1',
              'search': query.toString()
            };
            final workerService = WorkerService();
            final list = await workerService.getMyWorkers(params);
            listPersons = list.data;
            return listPersons;
          },
          fieldLabel: 'Buscar trabajador',
          nameTitle: 'nombreapellido',
          nameSubTitle: 'num_documento',
          nameImg: 'foto_url'),
      //query: 'Hola'
    );
    if (searchResult != null) {
      userPreferences.isWorkerChild = true;

      userPreferences.idWorker = int.parse(searchResult['id_trabajador'] != null
          ? searchResult['id_trabajador'].toString()
          : '-1');
      userPreferences.nroDocument = searchResult['num_documento'];
      /* userPreferences.idEntity =
          int.parse(searchResult['id_entidad'].toString());
      userPreferences.idDeparment = searchResult['id_depto'].toString(); */
      userPreferences.idPerson =
          int.parse(searchResult['id_persona'].toString());
      userPreferences.fullnamePerson =
          searchResult['nombreapellido'].toString();
      Get.forceAppUpdate();
    }
  }

  void _backToHome() {
    userPreferences.isWorkerChild = false;
    userPreferences.idEntity = userPreferences.idEntityFather;
    userPreferences.idDeparment = userPreferences.idDeparmentFathher;
    userPreferences.idPerson = userPreferences.idPersonFather;
    userPreferences.nroDocument = userPreferences.nroDocumentFather;
    userPreferences.idWorker = userPreferences.idWorkerFather;
    userPreferences.fullnamePerson = userPreferences.fullnamePersonFather;
    // reset data father
    userPreferences.idEntityFather = 0;
    userPreferences.idDeparmentFathher = '';
    userPreferences.idPersonFather = 0;
    userPreferences.nroDocumentFather = '';
    userPreferences.idWorkerFather = 0;
    userPreferences.fullnamePersonFather = '';
    Get.forceAppUpdate();
  }
}

/// Clase auxiliar para almacenar datos de los tabs
class _TabsData {
  final List<Widget> tabs;
  final int initialIndex;

  _TabsData({required this.tabs, required this.initialIndex});
}
