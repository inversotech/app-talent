import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/general/date_model.dart';
import 'package:lamb_talent/resources/models/general/file.dart';
import 'package:lamb_talent/resources/services/account_status/account_status_service.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/shared/components/pdf_screen.dart';
import 'package:lamb_talent/shared/components/year_month_datepicker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AccountStatusController extends GetxController {
  final refreshController = RefreshController(initialRefresh: false);
  final scrollController = ScrollController();
  final controllerCarousel = CarouselController();
  final userPreferences = UserPreferences();
  var dateModel = DateModel(
          year: DateTime.now().year,
          month: DateTime.now().month,
          nameMonth: capitalize(DateFormat.MMMM('es').format(DateTime.now())))
      .obs;
  RxBool loadingData = false.obs;
  RxBool loadingGeneral = false.obs;
  RxBool loadingDetail = false.obs;
  RxInt selectSlider = 0.obs;
  Map? dataDetail;
  List listDataDetail = [];
  RxString urlBoleta = ''.obs;
  Map dataGeneral = {};
  RxString codeModule = '16120102'.obs;

  @override
  void onReady() {
    _listData();
    super.onReady();
  }

  @override
  void dispose() {
    refreshController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _listData() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    await _getAccessNivel();
    await _listDataGeneral();
    await _listDataDetail();
    Get.until((route) => !Get.isDialogOpen!);
    loadingData.value = true;
    loadingData.value = false;
  }

  Future _getAccessNivel() async {
    final Map<String, String> params = {
      'codigo_acceso': codeModule.value.toString()
    };
    final _authService = AuthService();
    final resp = await _authService.getAccessNivel(params);
    userPreferences.idNivelAcceso = resp.accesoNivel!.idAccesoNivel != null
        ? resp.accesoNivel!.idAccesoNivel.toString()
        : '';
    if (resp.accesoNivel!.idTipoNivelVista != null &&
        resp.accesoNivel!.idTipoNivelVista != '5') {
      userPreferences.searchPerson = true;
    } else {
      userPreferences.searchPerson = false;
    }
  }

  Future _listDataGeneral() async {
    final String params = 'p_id_entidad=' +
        userPreferences.idEntity.toString() +
        ';p_id_anho=' +
        dateModel.value.year.toString() +
        ';p_id_mes=' +
        dateModel.value.month.toString() +
        ';p_id_persona=' +
        userPreferences.idPerson.toString() +
        ';p_id_cta_cte=' +
        userPreferences.nroDocument.toString();
    final _accountStatusService = AccountStatusService();
    dataGeneral = await _accountStatusService.getAccountStatus(params);
    loadingGeneral.value = true;
    loadingGeneral.value = false;
  }

  Future _listDataDetail() async {
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity.toString(),
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
    };
    switch (selectSlider.value) {
      case 0:
        params['id_cta_cte'] = userPreferences.nroDocument.toString();
        params['id_persona'] = userPreferences.idPerson.toString();
        final _accountStatusService = AccountStatusService();
        dataDetail = await _accountStatusService.getItems(params);
        break;
      case 1:
        dataDetail = {
          'ingresos': dataGeneral.containsKey('ayudas_ingresos')
              ? dataGeneral['ayudas_ingresos']
              : '0',
          'descuentos': dataGeneral.containsKey('ayudas_descuentos')
              ? dataGeneral['ayudas_descuentos']
              : '0',
          'sub_total':
              dataGeneral.containsKey('ayudas') ? dataGeneral['ayudas'] : '0',
          'total': dataGeneral.containsKey('ayudas_saldo')
              ? dataGeneral['ayudas_saldo']
              : '0'
        };
        break;
      case 2:
        dataDetail = {
          'ingresos': dataGeneral.containsKey('viajes_ingresos')
              ? dataGeneral['viajes_ingresos']
              : '0',
          'descuentos': dataGeneral.containsKey('viajes_descuentos')
              ? dataGeneral['viajes_descuentos']
              : '0',
          'sub_total':
              dataGeneral.containsKey('viajes') ? dataGeneral['viajes'] : '0',
          'total': dataGeneral.containsKey('viajes_saldo')
              ? dataGeneral['viajes_saldo']
              : '0'
        };
        break;
      case 3:
        params['id_cuentaaasi'] = '1135061';
        params['id_cta_cte'] = userPreferences.nroDocument.toString();
        final _accountStatusService = AccountStatusService();
        dataDetail = await _accountStatusService.getDetailsAccount(params);
        final resp = await _accountStatusService.getDetailsAccount(params);
        List detail = [];
        Map data = {};
        if (resp != null) {
          data = resp as Map;
          if (data.containsKey('total') && data.containsKey('items')) {
            detail.add({
              'title': 'Total ingresos',
              'total': data['total'],
              'items': data['items']
            });
          } else {
            detail.add({'title': 'Total ingresos', 'total': '0', 'items': []});
          }
        }
        listDataDetail = detail;
        break;
      case 4:
        params['id_cuentaaasi'] = '1135007';
        params['id_cta_cte'] = userPreferences.nroDocument.toString();
        final _accountStatusService = AccountStatusService();
        final resp = await _accountStatusService.getDetailsAccount(params);
        List detail = [];
        Map data = {};
        if (resp != null) {
          data = resp as Map;
          if (data.containsKey('total') && data.containsKey('items')) {
            detail.add({
              'title': 'Total ingresos',
              'total': data['total'],
              'items': data['items']
            });
          } else {
            detail.add({'title': 'Total ingresos', 'total': '0', 'items': []});
          }
        }
        listDataDetail = detail;
        break;
      default:
    }
    loadingData.value = true;
    loadingData.value = false;
    loadingDetail.value = true;
    loadingDetail.value = false;
  }

  void onRefresh() async {
    await _listDataGeneral();
    // await _listDataDetail();
    refreshController.refreshCompleted();
    refreshController.loadNoData();
  }

  void loadListDetail() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    await _listDataDetail();
    Get.until((route) => !Get.isDialogOpen!);
  }

  Future getTicketPayment() async {
    loadingIndicator(onlyLoading: true, opacity: true);
    String type = userPreferences.isWorkerChild ? 'N' : 'S';
    final Map<String, String> params = {
      'id_persona': userPreferences.idPerson.toString(),
      'id_anho': dateModel.value.year.toString(),
      'id_mes': dateModel.value.month.toString(),
      'id_entidad': userPreferences.idEntity.toString(),
      'type': type
    };
    final _accountStatusService = AccountStatusService();
    FileModel ticketPayment =
        await _accountStatusService.gePaymentstTicketMonth(params);
    if (ticketPayment.file.isNotEmpty) {
      String fileName = ticketPayment.fileName.isNotEmpty
          ? ticketPayment.fileName
          : dateModel.value.month.toString() +
              '-' +
              dateModel.value.year.toString() +
              ' ' +
              userPreferences.nameEntity.toString() +
              '.pdf';
      final file = await _accountStatusService.createFileOfPdfUrl(
          ticketPayment.file, fileName);
      Get.until((route) => !Get.isDialogOpen!);
      if (file.path.isNotEmpty) {
        Get.to(() => PDFScreen(
            clave: ticketPayment.clave,
            urlFileDownload: ticketPayment.file,
            showDownload: true,
            path: file.path,
            titlePdf: fileName));
      } else {
        Get.until((route) => !Get.isDialogOpen!);
        Get.snackbar('Mensaje:', 'Ocurrió un error al abrir la boleta',
            duration: const Duration(seconds: 8),
            colorText: ColorsApp.white,
            backgroundColor: ColorsApp.danger);
      }
    } else if (ticketPayment.file.isEmpty) {
      Get.until((route) => !Get.isDialogOpen!);
      Get.snackbar('Mensaje:',
          'No se encontró boleta del mes de ' + dateModel.value.nameMonth+', '+ dateModel.value.year.toString(),
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.danger);
    }
  }

  void selectDate() async {
    final dateResult = await Get.bottomSheet(YearMonthPicker(
        selectedDate:
            DateTime(dateModel.value.year, dateModel.value.month, 1)));
    if (dateResult != null) {
      dateModel.value.month = int.parse(DateFormat.M().format(dateResult));
      dateModel.value.nameMonth =
          capitalize(DateFormat.MMMM('es').format(dateResult));
      dateModel.value.year = int.parse(DateFormat.y().format(dateResult));
      _listData();
      // Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
