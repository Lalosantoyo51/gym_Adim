import 'package:administrador/screens/gym/models/pushModel.dart';
import 'package:flutter/material.dart';

class DetallePushHistorial extends StatelessWidget {
  PushModel pushModel;
   DetallePushHistorial({Key? key, required this.pushModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textSyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("Notificacion",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      body:vista(context, textSyles),
    );
  }

  Padding vista(BuildContext context, TextTheme textSyles) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
    child: Column(
      children: [
        if(pushModel.imagen !=null)
          SizedBox(
              height: MediaQuery.of(context).size.height/2,
              child: Image.network(pushModel.imagen!)),
        const SizedBox(height: 30,),
        Text(pushModel.asunto!, style: textSyles.titleMedium,),
        const Divider(),
      ],
    ),
  );
  }
}
