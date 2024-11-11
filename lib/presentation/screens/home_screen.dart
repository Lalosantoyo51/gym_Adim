import 'package:administrador/screens/gym/models/pushModel.dart';
import 'package:administrador/screens/gym/providers/provider_novedad.dart';
import 'package:administrador/widgets/colum_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:administrador/config/pushMessage.dart';
import 'package:administrador/config/router/app_router.dart';
import 'package:administrador/presentation/blocs/notifications/bloc.dart';
import 'package:administrador/presentation/screens/detallePushHistorial.dart';
import 'package:administrador/presentation/screens/detallesPush.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Notificaciones",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: _HomeVIer(),
    );
  }
}

class _HomeVIer extends StatefulWidget {
  const _HomeVIer({Key? key}) : super(key: key);

  @override
  State<_HomeVIer> createState() => _HomeVIerState();
}

class _HomeVIerState extends State<_HomeVIer> {
  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  init() {
    final novedad = Provider.of<provider_novedad>(context, listen: false);
    novedad.getHitorialPush();
  }

  @override
  Widget build(BuildContext context) {
    final novedad = Provider.of<provider_novedad>(context);

    final notifications =
        context.watch<NotificationsBloc>().state.notifications;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ColumnBuilder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return contenerdor(notification, context);
            },
          ),
          ColumnBuilder(
            itemCount: novedad.listpush.length,
            itemBuilder: (context, index) {
              return contenerdorMo(novedad.listpush[index], context);
            },
          ),
        ],
      ),
    );
  }

  ListTile contenerdor(PushMessage notification, BuildContext context) {
    return ListTile(
        //TODO: COMPLEMENTAR ESTA IMPLEMENTACION
        //TITLE
        title: Text(notification.title),
        subtitle: Text(notification.body),
        leading: notification.imageUrl != null
            ? Image.network(notification.imageUrl!)
            : null,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetallesPush(pushMessageId: notification.messageId),
              ));
        });
  }

  ListTile contenerdorMo(PushModel notification, BuildContext context) {
    return ListTile(
        //TODO: COMPLEMENTAR ESTA IMPLEMENTACION
        //TITLE
        title: Text(notification.asunto!),
        leading: notification.imagen != null
            ? Image.network(
                notification.imagen!,
                errorBuilder: (context, error, stackTrace) => Image.asset("assets/aptitud-fisica.png"),
              )
            : null,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetallePushHistorial(pushModel: notification),
              ));
        });
  }
}
