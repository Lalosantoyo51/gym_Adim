import 'dart:async';

import 'package:flutter/cupertino.dart';

class RetoDetallesProvider with ChangeNotifier {
  double conteinerFirst = .65;
  double conteinerSecond = .3;
  double conteinerthird = .8;
  double stop1 = .45;
  double stop2 = .75;
  int isScroll = 1;

  cambiarEstado(int isenable) {
    isScroll = isenable;

    if (isScroll == 3) {
      conteinerFirst = .35;
      conteinerSecond = .6;
      conteinerthird = .5;
      stop1 = .1;
      stop2 = .75;
    } else if (isScroll == 2) {
      conteinerFirst = .2;
      conteinerSecond = .75;
      conteinerthird = .8;
      stop1 = .1;
      stop2 = .75;
    } else if (isScroll == 1) {
      conteinerFirst = .65;
      conteinerSecond = .3;
      conteinerthird = .8;
      stop1 = .45;
      stop2 = .75;
    }

    notifyListeners();
  }
}
