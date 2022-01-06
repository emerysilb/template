import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget loadingAnimation(BuildContext context) {
  return LoadingAnimationWidget.halfTringleDot(
    color: Theme.of(context).primaryColorLight,
    size: 100,
  );
}
