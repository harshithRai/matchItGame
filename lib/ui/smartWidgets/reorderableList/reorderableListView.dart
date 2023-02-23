import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import './reorderableListViewModel.dart';

class ReorderableListView extends StatelessWidget {
  final List<Widget> widgetList;

  const ReorderableListView({Key key, this.widgetList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReorderableListViewModel>.reactive(
      builder: (context, model, child) {
        return Container();
      },
      viewModelBuilder: () => ReorderableListViewModel(),
      onModelReady: (model) => model.initialize(),
    );
  }
}
