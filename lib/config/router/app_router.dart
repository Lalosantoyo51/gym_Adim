import 'package:administrador/presentation/screens/detallesPush.dart';
import 'package:administrador/presentation/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';



final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details/:pushMessageId',
          builder: (BuildContext context, GoRouterState state) {
            return   DetallesPush(pushMessageId:  state.pathParameters["pushMessageId"]!);
          },
        ),
      ],
    ),
  ],
);