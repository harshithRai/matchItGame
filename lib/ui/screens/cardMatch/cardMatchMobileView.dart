import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import '../../../models/store.dart';
import '../../../utilities/uiUtils.dart';
import '../../responsive/sizeConfig.dart';
import '../../smartWidgets/appBarMatchGame/appBarMatchGameView.dart';
import 'cardMatchViewModel.dart';

class CardMatchMobilePortraitView extends StatelessWidget {
  const CardMatchMobilePortraitView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CardMatchViewModel>.reactive(
      builder: (context, model, child) {
        int i = -1;
        return Scaffold(
          appBar: AppBarMatchGameView(
            title: '${model.currentLevel}',
            time: '${model.durationPlayed}',
            reset: model.resetCards,
          ),
          body: SafeArea(
            child: model.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: SizeConfig.safeAreaHeightExcludingAppBar,
                            width: SizeConfig.safeAreaWidth,
                            padding: EdgeInsets.all(20.0.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: model.matchCards.map<Widget>(
                                        (e) {
                                          i = model.matchCards.indexOf(e);
                                          return AbsorbPointer(
                                            absorbing: e.isMatched,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 0.0,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                              ),
                                              key: model.sourceKey[i],
                                              child: GestureDetector(
                                                onTapDown: (details) => model
                                                    .playVoice(e.sourceVoice),
                                                child: model.leftShowDraggable
                                                    ? buildDraggableCards(
                                                        e,
                                                        model,
                                                        "left",
                                                        "source",
                                                      )
                                                    : buildDragTargetCards(
                                                        model,
                                                        e,
                                                        "left",
                                                        "source",
                                                      ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList() ??
                                      [],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: model.matchCards.map<Widget>(
                                        (e) {
                                          i = model.matchCards.indexOf(e);
                                          return AbsorbPointer(
                                            absorbing: e.isMatched,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 0.0,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                              ),
                                              key: model.matchKey[i],
                                              child: GestureDetector(
                                                onTapDown: (details) => model
                                                    .playVoice(e.matchVoice),
                                                child: model.rightShowDraggable
                                                    ? buildDraggableCards(
                                                        e,
                                                        model,
                                                        "right",
                                                        "match",
                                                      )
                                                    : buildDragTargetCards(
                                                        model,
                                                        e,
                                                        "right",
                                                        "match",
                                                      ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList() ??
                                      []
                                    ..shuffle(Random(model.randomSeed)),
                                ),
                              ],
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                      CustomPaint(
                        foregroundPainter: ShapesPainter(
                          sourceOffsetList: model.sourceOffset,
                          matchOffsetList: model.matchOffset,
                          sourceCardSize: model.sourceCardSize,
                          matchCardSize: model.matchCardSize,
                          lineColor: Theme.of(context).accentColor,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
      viewModelBuilder: () => CardMatchViewModel(),
      disposeViewModel: true,
      onModelReady: (model) => model.initialize(),
    );
  }

  DragTarget<String> buildDragTargetCards(
      CardMatchViewModel model, MatchCard e, String side, String cardType) {
    return DragTarget(
      builder: (BuildContext context, List<String> incoming, List rejected) {
        return Container(
          width: 300.sp,
          height: 200.sp,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.0,
              color: Theme.of(context).accentColor,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: buildCard(
                  model,
                  e,
                  cardType,
                  200.sp,
                  200.sp,
                ),
              ),
              if (e.isMatched)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Lottie.asset(
                      'assets/lottie/success.json',
                      width: 80.sp,
                      height: 80.sp,
                      repeat: false,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      onWillAccept: (data) {
        return data == e.id.toString() && !e.isMatched;
      },
      onAccept: (data) {
        e.isMatched = true;
        // model.playSound("success");
        model.playVoice(cardType == "source" ? e.sourceVoice : e.matchVoice);
        model.incrementScore(model.matchCards.indexOf(e));
      },
    );
  }

  Draggable<String> buildDraggableCards(
      MatchCard e, CardMatchViewModel model, String side, String cardType) {
    return Draggable<String>(
      dragAnchor: DragAnchor.child,
      onDragStarted: () {
        model.markDragStatus(side);
      },
      onDragCompleted: () {
        model.markDragStatus("none");
      },
      onDragEnd: (details) {
        model.markDragStatus("none");
      },
      onDraggableCanceled: (velocity, offset) {
        model.markDragStatus("none");
      },
      data: e?.id.toString(),
      child: buildDraggableCard(model, e, cardType),
      feedback: buildDraggableCard(model, e, cardType),
      childWhenDragging: buildDraggableCard(model, e, cardType),
    );
  }

  Container buildDraggableCard(
      CardMatchViewModel model, MatchCard e, String cardType) {
    return Container(
      width: 300.sp,
      height: 200.sp,
      // color: Colors.red,
      child: Stack(
        alignment: Alignment.center,
        children: [
          buildCard(
            model,
            e,
            cardType,
            200.sp,
            200.sp,
          ),
          if (e.isMatched)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Lottie.asset(
                  'assets/lottie/success.json',
                  width: 80.sp,
                  height: 80.sp,
                  repeat: false,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildCard(CardMatchViewModel model, MatchCard e, String cardType,
      double height, double width) {
    switch (cardType) {
      case "source":
        if (e.sourceImagePath.isNotEmpty && e.sourceWidgetType == "image") {
          // return SvgPicture.string(
          //   model.getImageString(
          //     e.sourceImagePath,
          //   ),
          //   height: height,
          //   width: width,
          // );
          var imageSrc = e.sourceImagePath;
          var side = "left";
          if (e.isMatched || !e.clipCard) {
            side = null;
          }
          if (e.finalImagePath != null && e.isMatched) {
            imageSrc = e.finalImagePath;
          }

          return buildImageWidget(imageSrc, height, width, model, side,
              e.clipType, e.sourceImageCount, e.id, cardType, false);
        } else if (e.sourceWidgetType == "number") {
          return Material(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff3b88c3),
                borderRadius: BorderRadius.circular(25.sp),
              ),
              padding: EdgeInsets.all(12.0.sp),
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.contain,
                child: Text(
                  e.sourceText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: 70.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              height: height,
              width: width,
            ),
          );
        }
        return Material(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff3b88c3),
              borderRadius: BorderRadius.circular(25.sp),
            ),
            child: Center(
              child: Text(
                e.sourceText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp,
                  // fontSize: 70.sp,
                  color: Colors.white,
                ),
              ),
            ),
            height: height,
            width: width,
          ),
        );
      case "match":
        if (e.matchImagePath != null &&
            e.matchImagePath.isNotEmpty &&
            e.matchWidgetType == "image") {
          var imageSrc = e.matchImagePath;
          var side = "right";
          var showShadow = e.showShadow;

          if (e.isMatched || !e.clipCard) {
            side = null;
          }
          if (e.finalImagePath != null && e.isMatched) {
            imageSrc = e.finalImagePath;
            side = null;
            showShadow = false;
          }
          return buildImageWidget(imageSrc, height, width, model, side,
              e.clipType, e.matchImageCount, e.id, cardType, showShadow);
        } else if (e.matchWidgetType == "number") {
          return Material(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff3b88c3),
                borderRadius: BorderRadius.circular(25.sp),
              ),
              padding: EdgeInsets.all(12.0.sp),
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.contain,
                child: Text(
                  e.matchText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: 70.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              height: height,
              width: width,
            ),
          );
        }
        return Material(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff3b88c3),
              borderRadius: BorderRadius.circular(25.sp),
            ),
            child: Center(
              child: Text(
                e.matchText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp,
                  // fontSize: 70.sp,
                  color: Colors.white,
                ),
              ),
            ),
            height: height,
            width: width,
          ),
        );
      default:
        return Container(
          child: Text('Not sure'),
          height: height,
          width: width,
        );
    }
  }

  Widget buildImageWidget(
    String imageFileName,
    double heigth,
    double width,
    CardMatchViewModel model,
    String side,
    String type,
    int imageCount,
    int id,
    String cardType,
    bool showShadow,
  ) {
    // imageCount = 20;
    var arr = imageFileName.split(".");

    var rowCount = model.getRowColCount(imageCount)['row'];
    var colCount = model.getRowColCount(imageCount)['col'];
    var minRowCol = rowCount > colCount ? rowCount : colCount;

    var imageRendered = 0;

    List<Widget> children = new List.generate(
      rowCount,
      (int i) {
        var imageLeft = imageCount - imageRendered;
        if (imageLeft > colCount) {
          imageLeft = colCount;
        }
        imageRendered = imageRendered + imageLeft;
        List<Widget> rowChildren = new List.generate(imageLeft, (index) {
          if (arr[arr.length - 1] == 'svg') {
            return SizedBox(
              height: heigth / minRowCol,
              width: width / minRowCol,
              child: ClipPath(
                child: SvgPicture.file(
                  cardType == "source"
                      ? model.sourceImageCachedPath[id]
                      : model.matchImageCachedPath[id],

                  color: !showShadow
                      ? null
                      : model.themeMode == 'dark'
                          ? Colors.white60
                          : Colors.black54,
                  // white60
                ),
                clipper:
                    side != null ? WidgetClipper(side: side, type: type) : side,
              ),
            );
          }
          return ClipPath(
            child: Image.file(
              cardType == "source"
                  ? model.sourceImageCachedPath[id]
                  : model.matchImageCachedPath[id],
              height: heigth,
              width: width,
            ),
            clipper:
                side != null ? WidgetClipper(side: side, type: type) : side,
          );
        });
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowChildren,
        );
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class ShapesPainter extends CustomPainter {
  final List<Offset> sourceOffsetList;
  final List<Offset> matchOffsetList;
  final Size sourceCardSize;
  final Size matchCardSize;
  final Color lineColor;
  ShapesPainter({
    this.sourceOffsetList,
    this.matchOffsetList,
    this.sourceCardSize,
    this.matchCardSize,
    this.lineColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the paint color to be white
    paint.color = lineColor;
    paint.strokeWidth = 2.0;
    paint.strokeCap = StrokeCap.round;
    for (var i = 0; i < sourceOffsetList.length; i++) {
      Offset s = Offset(sourceOffsetList[i].dx + sourceCardSize.width,
          sourceOffsetList[i].dy - (sourceCardSize.height.sp / 2.sp));
      Offset m = Offset(matchOffsetList[i].dx,
          matchOffsetList[i].dy - (matchCardSize.height.sp / 2.sp));
      canvas.drawLine(s, m, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
