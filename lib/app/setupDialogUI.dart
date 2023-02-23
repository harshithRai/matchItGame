import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/locator.dart';
import '../constants/enums.dart';
import '../ui/plainWidgets/achievementsDialog.dart';
import '../ui/plainWidgets/leaderboardDialog.dart';
import '../ui/plainWidgets/levelCompleteDialog.dart';
import '../ui/plainWidgets/levelFailedDialog.dart';

void setupDialogUI() {
  var dialogService = locator<DialogService>();

  dialogService.registerCustomDialogBuilder(
    variant: CustomDialogType.levelCompleted,
    builder: (context, dialogRequest) {
      return Dialog(
        child: LevelCompleteDialog(
          dialogRequest: dialogRequest,
          onDialogTap: (dialogResponse) =>
              dialogService.completeDialog(dialogResponse),
        ),
      );
    },
  );

  dialogService.registerCustomDialogBuilder(
    variant: CustomDialogType.levelFailed,
    builder: (context, dialogRequest) {
      return Dialog(
        child: LevelFailedDialog(
          dialogRequest: dialogRequest,
          onDialogTap: (dialogResponse) =>
              dialogService.completeDialog(dialogResponse),
        ),
      );
    },
  );

  dialogService.registerCustomDialogBuilder(
    variant: CustomDialogType.achievement,
    builder: (context, dialogRequest) {
      return Dialog(
        child: AchievementsDialog(
          dialogRequest: dialogRequest,
          onDialogTap: (dialogResponse) =>
              dialogService.completeDialog(dialogResponse),
        ),
      );
    },
  );

  dialogService.registerCustomDialogBuilder(
    variant: CustomDialogType.leaderboard,
    builder: (context, dialogRequest) {
      return Dialog(
        child: LeaderboardDialog(
          dialogRequest: dialogRequest,
          onDialogTap: (dialogResponse) =>
              dialogService.completeDialog(dialogResponse),
        ),
      );
    },
  );
}
