import 'dart:async';
import 'dart:convert';
import 'package:administrador/config/pushMessage.dart';
import 'package:administrador/firebase_options.dart';
import 'package:administrador/screens/Autentificacion/Controller/controlador_auth.dart';
import 'package:administrador/screens/Autentificacion/Model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('hola init s');
  await Firebase.initializeApp();
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int pushCount = 0;

  final Future<void> Function() resquestLocalNotificationsPermission;
  final void Function({
  required int id,
  String? titulo,
  String? body,
  String? data,
})? showLocalNotifications;

  NotificationsBloc(this.resquestLocalNotificationsPermission, this.showLocalNotifications) : super(const NotificationsState()) {
    print('entra 1 ');

    on<NotificationStatusChange>(_notificationsStatusChanged);
    //TODO3:Crear el listener # _onPushMessageRececived
    on<NotificationRecived>(_onPushMessageRececived);

    //verificar estado de las notificaciones
    _initialStatusCheck();

    // listener para noticaciones app abierta
    _onForeGroundMessage();
  }



  void handleRemoteMessage(RemoteMessage message) async{
    if (message.notification == null) return;
    final notification = PushMessage(
        messageId:
        message.messageId?.replaceAll(':', '').replaceAll("%", '') ?? '',
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
        data: message.data,
        sentDate: message.sentTime ?? DateTime.now(),
        imageUrl: message.notification!.android!.imageUrl);
    if(showLocalNotifications != null){
      showLocalNotifications!(
          id: ++pushCount,
          data: message.messageId?.replaceAll(':', '').replaceAll("%", '') ?? '',
          body: message.notification!.body,
          titulo: message.notification!.title);
    }
    add(NotificationRecived(notification));
  }
  void lim() => emit(state.copyWith(notifications: []));


  //TODO:add nuevo evento

  void _onForeGroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

//permisos de notifications
  void requesPermisions() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    //solicitar permiso a local notification
    if(resquestLocalNotificationsPermission != null){
      await resquestLocalNotificationsPermission!();
    }
    add(NotificationStatusChange(settings.authorizationStatus));
  }

  static Future<void> initializeFCM() async {

    await Firebase.initializeApp(
      name: "admin",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }


  void _notificationsStatusChanged(
      NotificationStatusChange event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  void _onPushMessageRececived(
      NotificationRecived event, Emitter<NotificationsState> emit) {
    emit(state
        .copyWith(notifications: [event.pushMessage, ...state.notifications]));
    _getFCMToken();
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    settings.authorizationStatus;
    add(NotificationStatusChange(settings.authorizationStatus));
  }

  void _getFCMToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    var usu = sp.getString("usuario");
    UserModel user;
    print('token ${token}');
    sp.setString("token", "$token" );
    if (usu != null) {
      user = UserModel.fromJson2(json.decode(usu));
      print('el id del usuario ${user.idU}');
      await ControladorAuth().insetDispositivo(int.parse(user.idU.toString()), "${sp.getString("token")}");

    }



  }
  void getFCMToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    var usu = sp.getString("usuario");
    UserModel user;
    print('token ${token}');
    sp.setString("token", "$token" );
    if (usu != null) {
      user = UserModel.fromJson2(json.decode(usu));
      print('el id del usuario ${user.idU}');
      await ControladorAuth().insetDispositivo(int.parse(user.idU.toString()), "${sp.getString("token")}");

    }
  }

  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications
        .any((element) => element.messageId == pushMessageId);
    if (!exist) return null;
    return state.notifications
        .firstWhere((element) => element.messageId == pushMessageId);
  }
}
