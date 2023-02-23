import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked_services/stacked_services.dart';

import 'starRatingList.dart';

class LevelCompleteDialog extends StatelessWidget {
  final DialogRequest dialogRequest;
  final Function(DialogResponse) onDialogTap;
  const LevelCompleteDialog({
    Key key,
    this.dialogRequest,
    this.onDialogTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800.sp,
      padding: EdgeInsets.all(20.0.sp),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: Lottie.asset(
              'assets/lottie/notebook.json',
              width: 400.sp,
              height: 200.sp,
              repeat: false,
            ),
          ),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            child: StarRatingList(
              value: dialogRequest.customData['starCount'],
              // color: Theme.of(context).accentColor,
              size: 150.sp,
            ),
          ),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            width: 600.sp,
            height: 100.sp,
            decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(
                0.5,
              ),
              borderRadius: BorderRadius.circular(
                20.sp,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/timer.json',
                  width: 100.sp,
                  height: 80.sp,
                  repeat: false,
                ),
                Text(
                  ' Time : ',
                  style: TextStyle(
                    fontSize: 52.sp,
                    color: Colors.yellow,
                  ),
                ),
                Text(
                  dialogRequest.customData['durationPlayed'],
                  style: TextStyle(
                    fontSize: 52.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              bottom: 30.sp,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  // Complete the dialog when you're done with it to return some data
                  onTap: () => onDialogTap(
                      DialogResponse(confirmed: false, responseData: "reset")),
                  child: Container(
                    child: dialogRequest.showIconInMainButton
                        ? Lottie.asset(
                            'assets/lottie/reset.json',
                            width: 70.sp,
                            height: 70.sp,
                          )
                        : Text(dialogRequest.secondaryButtonTitle),
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.symmetric(vertical: 10),
                    width: 120.sp,
                    height: 120.sp,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(40.sp),
                    ),
                  ),
                ),
                GestureDetector(
                  // Complete the dialog when you're done with it to return some data
                  onTap: () => onDialogTap(
                      DialogResponse(confirmed: false, responseData: "home")),
                  child: Container(
                    child: dialogRequest.showIconInMainButton
                        ? Lottie.asset('assets/lottie/home.json')
                        : Text(dialogRequest.secondaryButtonTitle),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: 120.sp,
                    height: 120.sp,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(40.sp),
                    ),
                  ),
                ),
                GestureDetector(
                  // Complete the dialog when you're done with it to return some data
                  onTap: () => onDialogTap(DialogResponse(confirmed: true)),
                  child: Container(
                    child: dialogRequest.showIconInMainButton
                        ? Lottie.asset('assets/lottie/fastForward.json')
                        : Text(dialogRequest.mainButtonTitle),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: 120.sp,
                    height: 120.sp,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(40.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
