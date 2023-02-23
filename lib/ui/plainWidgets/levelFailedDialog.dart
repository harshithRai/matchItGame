import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_services/stacked_services.dart';

class LevelFailedDialog extends StatelessWidget {
  final DialogRequest dialogRequest;
  final Function(DialogResponse) onDialogTap;
  const LevelFailedDialog({
    Key key,
    this.dialogRequest,
    this.onDialogTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0.sp),
      height: 500.0.sp,
      child: Column(
        children: [
          Text(
            "X",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 252.0.sp,
            ),
          ),
          FlatButton(
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                30.0.sp,
              ),
            ),
            child: Text(
              'PLAY AGAIN',
              style: TextStyle(
                fontSize: 38.0.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              onDialogTap(
                DialogResponse(confirmed: false, responseData: "reset"),
              );
            },
          ),
        ],
      ),
    );
  }
}
