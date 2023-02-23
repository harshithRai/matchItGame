import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StarRatingList extends StatelessWidget {
  final int value;
  // final color;
  final double size;
  const StarRatingList({
    Key key,
    @required this.value,
    // @required this.color,
    @required this.size,
  });
  @override
  Widget build(BuildContext context) {
    return StarDisplay(
      value: this.value,
      size: this.size,
    );
  }
}

class StarDisplayWidget extends StatelessWidget {
  final int value;
  final Widget filledStar;
  final Widget unFilledStar;
  final Widget halfFilledStar;
  const StarDisplayWidget({
    Key key,
    this.value = 0,
    @required this.filledStar,
    @required this.unFilledStar,
    @required this.halfFilledStar,
  })  : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) {
          if (index + 1 <= value) {
            return filledStar;
          } else if (index + 1 > value && value > index) {
            return halfFilledStar;
          }
          return unFilledStar;
        },
      ),
    );
  }
}

class StarDisplay extends StarDisplayWidget {
  StarDisplay({Key key, int value = 0, double size})
      : super(
          key: key,
          value: value,
          filledStar: Lottie.asset(
            'assets/lottie/StarAnimation.json',
            width: size,
            height: size,
            repeat: false,
          ),
          unFilledStar: Lottie.asset(
            'assets/lottie/emptyStar.json',
            width: size,
            height: size,
            repeat: false,
          ),
          halfFilledStar: const Icon(Icons.star_half),
        );
}
