import 'package:administrador/config/pushMessage.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//com.example.push_app
 class NotificationsState extends Equatable {
  final AuthorizationStatus status;
  final List<PushMessage> notifications;

  const NotificationsState(
      {this.status = AuthorizationStatus.notDetermined,
      this.notifications = const []});

  NotificationsState copyWith(
          {AuthorizationStatus? status, List<PushMessage>? notifications}) =>
      NotificationsState(
        status: status ?? this.status,
          notifications: notifications ?? this.notifications,
          );

  @override
  List<Object> get props => [status, notifications];
}
