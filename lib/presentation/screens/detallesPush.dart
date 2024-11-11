import 'package:administrador/config/pushMessage.dart';
import 'package:administrador/presentation/blocs/notifications/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetallesPush extends StatelessWidget {
  final String pushMessageId;
  const DetallesPush({Key? key,required this.pushMessageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PushMessage? message = context.watch<NotificationsBloc>().getMessageById(pushMessageId);
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("Notificacion",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      body:
      (message != null)
          ? _DetallesVista(message: message!,)
          : const Center(child: Text("Notificacion no existe"),),
    );
  }
}
class _DetallesVista extends StatelessWidget {
  final PushMessage message;
  const _DetallesVista({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textSyles = Theme.of(context).textTheme;
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: Column(
        children: [
          if(message.imageUrl !=null)
            SizedBox(
                height: MediaQuery.of(context).size.height/2,
                child: Image.network(message.imageUrl!)),
          const SizedBox(height: 30,),
          Text(message.title, style: textSyles.titleMedium,),
          Text(message.body, style: textSyles.subtitle1,),
          const Divider(),
        ],
      ),
    );
  }
}


