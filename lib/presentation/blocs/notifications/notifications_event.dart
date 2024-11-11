
import 'package:administrador/config/pushMessage.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationsEvent  {
  const NotificationsEvent();
}

class NotificationStatusChange extends NotificationsEvent{
  final AuthorizationStatus status;
  NotificationStatusChange(this.status);




}
class NotificationRecived extends NotificationsEvent {
  //TODO2:NotificationRecived # PussMesage
  final PushMessage pushMessage;
  NotificationRecived(this.pushMessage);
}