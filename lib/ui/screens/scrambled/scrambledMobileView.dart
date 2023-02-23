import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../smartWidgets/appBar/appBarView.dart';
import 'scrambledViewModel.dart';

class ScrambledMobilePortraitView extends StatelessWidget {
  const ScrambledMobilePortraitView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScrambledViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBarView(
            title: 'Scrambled',
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Image.network(
                        'https://pbs.twimg.com/profile_images/927446347879292930/Fi0D7FGJ_400x400.jpg'),
                  ),
                ),
                Center(
                  child: Container(
                    child: Row(
                      children: List.generate(
                        model.data.length,
                        (index) {
                          return Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(5),
                            color: Colors.blue,
                            child: (model.userMatched.length > index)
                                ? Text(model.userMatched[index])
                                : null,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        model.data.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              model.removeCharIndex(index);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(5),
                              color: Colors.blue,
                              child: (model.scrambled.length > index)
                                ? Text(model.scrambled[index])
                                : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => ScrambledViewModel(),
      onModelReady: (model) => model.initialize(),
    );
  }
}
