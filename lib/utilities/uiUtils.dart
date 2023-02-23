import 'package:flutter/widgets.dart';

import '../constants/enums.dart';

DeviceScreenType getDeviceScreenType(MediaQueryData mediaQueryData) {
  double _deviceWidth = mediaQueryData.size.shortestSide;

  if (_deviceWidth > 950) {
    return DeviceScreenType.Desktop;
  }

  if (_deviceWidth > 600) {
    return DeviceScreenType.Tablet;
  }

  return DeviceScreenType.Mobile;
}

class WidgetClipper extends CustomClipper<Path> {
  final String side;
  final String type;
  WidgetClipper({this.side, this.type});

  // available types: vertical, horizontal, diagonal

  @override
  Path getClip(Size size) {
    final path = Path();
    switch (type) {
      case "vertical":
        if (side == "left") {
          path.lineTo(0.0, size.height);
          path.lineTo(size.width / 2, size.height);
          path.lineTo(size.width / 2, 0.0);
        } else if (side == "right") {
          path.moveTo(size.width / 2, 0.0);
          path.lineTo(size.width / 2, size.height);
          path.lineTo(size.width, size.height);
          path.lineTo(size.width, 0.0);
        }
        break;

      case "diagonal":
        if (side == "left") {
          path.lineTo(0.0, size.height);
          path.lineTo(size.width, 0.0);
          path.lineTo(0.0, 0.0);
        } else if (side == "right") {
          path.moveTo(size.width, 0.0);
          path.lineTo(0.0, size.height);
          path.lineTo(size.width, size.height);
          path.lineTo(size.width, 0.0);
        }

        break;
      case "horizontal":
        if (side == "left") {
          path.lineTo(0.0, size.height / 2);
          path.lineTo(size.width, size.height / 2);
          path.lineTo(size.width, 0.0);
        } else if (side == "right") {
          path.moveTo(0.0, size.height / 2);
          path.lineTo(size.width, size.height / 2);
          path.lineTo(size.width, size.height);
          path.lineTo(0.0, size.height);
        }
        break;
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget cardWidgetBuilder() {
  return Container();
}
