import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked_services/stacked_services.dart';

class AchievementsDialog extends StatelessWidget {
  final DialogRequest dialogRequest;
  final Function(DialogResponse) onDialogTap;
  const AchievementsDialog({
    Key key,
    this.dialogRequest,
    this.onDialogTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).dialogTheme.backgroundColor,
      height: 0.57.sh,
      margin: EdgeInsets.all(
        10.0.sp,
      ),
      child: Column(
        children: [
          Container(
            height: 0.07.sh,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                'Achievements!',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1.color,
                  fontSize: 52.0.sp,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 10.0.sp,
              bottom: 10.0.sp,
            ),
            height: 0.43.sh - 10.0.sp,
            child: GridView.builder(
              itemCount: dialogRequest.customData['achievements'].length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16.0.sp,
                crossAxisSpacing: 16.0.sp,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        MdiIcons.star,
                        size: 82.0.sp,
                        color: Colors.yellow[600],
                      ),
                      Text(
                        dialogRequest.customData['achievements'][index]['value']
                            .toString(),
                        style: TextStyle(
                          fontSize: 32.0.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 0.06.sh - 10.0.sp,
            child: FlatButton(
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  30.0.sp,
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 38.0.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                onDialogTap(
                  DialogResponse(confirmed: true),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
