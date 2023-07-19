import 'package:administrador/screens/gym/providers/provider_rutina.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Nivel extends StatelessWidget {
  //final VoidCallback? onTap;
  final ValueChanged<double>? onChanged;
  final double initialRating;
  final double size;
  late double rating;
  final bool isEnabled;
  Nivel({
    super.key,
    required this.initialRating,
    required this.size,
    this.onChanged,
    // this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final rutinasProvider = Provider.of<provider_rutina>(context);
    return RatingBar.builder(
      ignoreGestures: isEnabled,
      itemSize: size,
      initialRating: initialRating,
      unratedColor: const Color.fromARGB(255, 158, 158, 158),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return const Icon(
              Icons.circle,
              color: Colors.green,
            );
          case 1:
            return const Icon(
              Icons.circle,
              color: Colors.amber,
            );
          case 2:
            return const Icon(
              Icons.circle,
              color: Colors.orange,
            );
          case 3:
            return const Icon(
              Icons.circle,
              color: Colors.redAccent,
            );
          case 4:
            return const Icon(
              Icons.circle,
              color: Colors.red,
            );
        }
        return Container();
      },
      onRatingUpdate: onChanged!,
    );
  }
}
