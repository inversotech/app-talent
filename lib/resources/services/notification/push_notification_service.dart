import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/routers_names.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/enviroment/enviroment.dart';
import 'package:lamb_talent/ui/modules/notification/components/event_detail.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotificationService {
  static FirebaseMessaging message = FirebaseMessaging.instance;
  static String? token;

  static Future _backgroudHandler(RemoteMessage message) async {
    // print('onBackground Handler ${message.data}');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    if (message.notification != null) {
      _openNotification(
          title: message.notification!.title.toString(),
          message: message.notification!.body.toString(),
          data: message.data);
    }
  }

  static Future _onMessageOpenAppHandler(RemoteMessage message) async {
    _openNotificationDetail(message.data);
  }

  static Future initializeAppFirebase() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    final _userPref = UserPreferences();
    _userPref.tokenNotify = token.toString();
    FirebaseMessaging.onBackgroundMessage(_backgroudHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenAppHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
  }

  static Future initializeAppOneSingal() async {
    //Remove this method to stop OneSignal Debugging
    if (kDebugMode) {
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    }
    OneSignal.shared.setAppId(Env.api.appIdOneSignal);
// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
      _openNotificationDetail(result.notification.additionalData!);
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });
  }

  static _openNotificationDetail(Map<String, dynamic> data) async {
    switch (data['origen'].toString()) {
      case 'msm_evento':
        Get.to(
            () => EventDetail(id: data['id_origen'].toString(), loadBack: true),
            transition: Transition.size,
            duration: const Duration(seconds: 1));
        break;
      case 'msm_album':
        Get.offAllNamed(RoutesName.notification, arguments: {
          'id_origen': data['id_origen'].toString(),
          'origen': data['origen'].toString()
        });
        break;
      case 'msm_notificacion':
        Get.offAllNamed(RoutesName.notification, arguments: {
          'id_origen': data['id_origen'].toString(),
          'origen': data['origen'].toString()
        });
        break;
      case 'msm_horario':
        if (Get.currentRoute == '/HomePage') {
          Get.forceAppUpdate();
        } else {
          Get.offAllNamed(RoutesName.home);
        }
        break;
      case 'msm_vacacion':
        if (Get.currentRoute == '/HomePage') {
          Get.forceAppUpdate();
        } else {
          Get.offAllNamed(RoutesName.home);
        }
        break;
      case 'msm_birthday':
        break;
      default:
    }
  }

  static _openNotification(
      {required String title,
      required String message,
      required Map<String, dynamic> data}) async {
    Get.snackbar(title, message,
        padding: const EdgeInsets.all(8),
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/icon.png'),
        ),
        duration: const Duration(seconds: 20),
        colorText: ColorsApp.primary,
        backgroundColor: ColorsApp.white, onTap: (_) {
      _openNotificationDetail(data);
    });
  }
}
