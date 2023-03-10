import 'package:flutter/material.dart';
import 'package:matchme/utilities/uiUtils.dart';
import 'sizingInformation.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
      BuildContext context, SizingInformation sizingInformation) builder;
  const ResponsiveBuilder({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        var sizingInformation = SizingInformation(
          deviceScreenType: getDeviceScreenType(mediaQuery),
          screenSize: mediaQuery.size,
          localWidgetSize:
              Size(boxConstraints.maxWidth, boxConstraints.maxHeight),
        );
        return builder(context, sizingInformation);
      },
    );
  }
}
