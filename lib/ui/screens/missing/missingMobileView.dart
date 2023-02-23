import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import './missingViewModel.dart';

class MissingMobilePortraitView extends StatelessWidget {
  MissingMobilePortraitView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MissingViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  model.alphabetList.length,
                  (index) {
                    if (model.dragIndex != null) {
                      return DragTarget(
                        builder:
                            (context, List<String> incoming, List rejected) {
                          return Container(
                            color: Colors.green,
                            height: 50,
                            width: 50,
                            child: Text(
                              model.moveIndex == index
                                  ? ''
                                  : model.alphabetList[index],
                            ),
                          );
                        },
                        onMove: (details) {
                          print('movbe');
                          model.onMove(index);
                        },
                        onLeave: (data) {
                          // model.reset();
                        },
                        onAccept: (data) {
                          print('acce');
                          model.onDragAccepted(index);
                        },
                        onWillAccept: (data) {
                          print('will accept');
                          return true;
                        },
                      );
                    }
                    return Draggable(
                      data: model.alphabetList[index],
                      dragAnchor: DragAnchor.child,
                      onDragStarted: () {
                        model.onDragStart(index);
                        // print(index);
                      },
                      onDragCompleted: () {
                        //Called when the draggable is dropped and accepted by a DragTarget
                        print('dragCompltee');
                        // model.onDragCompleted(index);
                      },
                      onDragEnd: (details) {
                        print('dragEnd');
                        model.onDragCancelled();
                      },
                      onDraggableCanceled: (velocity, offset) {
                        print('dragCancel');
                        model.onDragCancelled();
                      },
                      childWhenDragging: Container(
                        color: Colors.transparent,
                        height: 50,
                        width: 50,
                      ),
                      axis: Axis.horizontal,
                      child: Container(
                        color: Colors.red,
                        height: 50,
                        width: 50,
                        child: Text(
                          model.alphabetList[index],
                        ),
                      ),
                      feedback: Container(
                        color: Colors.blue,
                        height: 50,
                        width: 50,
                        child: Text(
                          model.alphabetList[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => MissingViewModel(),
      disposeViewModel: true,
      onModelReady: (model) => model.initialize(),
    );
  }
}

class MissingMobileLandscapeView extends StatelessWidget {
  MissingMobileLandscapeView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          'Mobile Landscape view',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}
