
import 'dart:io';

import 'package:administrador/Themes/themes.dart';
import 'package:administrador/local_notification/local_notification.dart';
import 'package:administrador/myoberride.dart';
import 'package:administrador/permisos.dart';
import 'package:administrador/presentation/blocs/notifications/bloc.dart';
import 'package:administrador/screens/Autentificacion/Screen/login.dart';
import 'package:administrador/screens/gym/providers/provider_categorias.dart';
import 'package:administrador/screens/gym/providers/provider_ejercicios.dart';
import 'package:administrador/screens/gym/providers/provider_entrenamiento.dart';
import 'package:administrador/screens/gym/providers/provider_novedad.dart';
import 'package:administrador/screens/gym/providers/provider_nutricion.dart';
import 'package:administrador/screens/gym/providers/provider_reto.dart';
import 'package:administrador/screens/gym/providers/reproductor_provider.dart';
import 'package:administrador/screens/gym/providers/reto_detalles_provider.dart';
import 'package:administrador/screens/gym/screens/perfil/Profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'screens/gym/providers/provider_rutina.dart';


void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationsBloc.initializeFCM();
  await LocalNotifications.initializeLocalNotifications();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (_) => NotificationsBloc(
            LocalNotifications.requesPermissionLocalNotifications,
            LocalNotifications.showLocalNotification))
  ], child: const MyApp()));
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => provider_cat_eje(),
        ),
        ChangeNotifierProvider(
          create: (_) => provider_ejercicios(),
        ),
        ChangeNotifierProvider(
          create: (_) => provider_rutina(),
        ),
        ChangeNotifierProvider(
          create: (_) => provider_reproductor(),
        ),
        ChangeNotifierProvider(
          create: (_) => provider_entrenamiento(),
        ),
        ChangeNotifierProvider(
          create: (_) => provider_reto(),
        ),
        ChangeNotifierProvider(
          create: (_) => RetoDetallesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => provider_nutricion(),
        ),
        ChangeNotifierProvider(
          create: (_) => provider_novedad(),
        ),
      ],
      child: GetMaterialApp(
        //supportedLocales: _localization.supportedLocales,
        //localizationsDelegates: _localization.localizationsDelegates,
        localizationsDelegates: const [

          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: const Locale("es"),
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: AppTheme().orangeTheme,
        initialRoute: "home",
        getPages: [
          //GetPage(name: "/home", page: () => const Welcome()),
           GetPage(name: "/home", page: () =>  Permisos()),
          //GetPage(name: "/home", page: () =>  Profile()),

        ],
      ),
    );
  }
}






